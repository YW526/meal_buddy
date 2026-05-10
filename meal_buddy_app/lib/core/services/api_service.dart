import 'dart:io';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:get/get.dart' hide FormData, MultipartFile;
import '../../presentation/controllers/auth_controller.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:3000';
  static const String _tokenBoxName = 'auth_tokens';

  static late Dio _dio;
  static IO.Socket? _socket;

  // 초기화
  static Future<void> initialize() async {
    await Hive.initFlutter();
    await Hive.openBox(_tokenBoxName);
    // user_data는 더 이상 사용하지 않음 - AuthController에서만 관리

    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // 인터셉터 설정
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          // 토큰 만료 시 로그아웃 처리
          logout();
        }
        handler.next(error);
      },
    ));
  }

  // 토큰 관리
  static Future<void> saveToken(String token) async {
    final tokenBox = Hive.box(_tokenBoxName);
    await tokenBox.put('auth_token', token);
  }

  static Future<String?> getToken() async {
    final tokenBox = Hive.box(_tokenBoxName);
    return tokenBox.get('auth_token') as String?;
  }

  static Future<void> removeToken() async {
    final tokenBox = Hive.box(_tokenBoxName);
    await tokenBox.delete('auth_token');
  }

  // 사용자 데이터 관리는 AuthController에서 함
  // Hive는 사용하지 않음 - 토큰만 저장

  // ==================== 인증 관련 API ====================

  /// 회원가입
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String nickname,
    required int age,
    required String gender,
    required List<String> foodPreferences,
    String? profileImageUrl,
  }) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'email': email,
        'password': password,
        'nickname': nickname,
        'age': age,
        'gender': gender,
        'food_preferences': foodPreferences,
        if (profileImageUrl != null) 'profile_image_url': profileImageUrl,
      });

      final data = response.data;
      await saveToken(data['access_token']);
      // 사용자 데이터는 AuthController에서 관리

      return data;
    } on DioException catch (e) {
      throw _handleDioError(e, '회원가입');
    }
  }

  /// 비밀번호 변경
  static Future<Map<String, dynamic>> password({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post('/auth/update_password', data: {
        'email': email,
        'password': password,
      });

      final data = response.data;
      await saveToken(data['access_token']);
      // 사용자 데이터는 AuthController에서 관리

      return data;
    } on DioException catch (e) {
      throw _handleDioError(e, '비밀번호 변경');
    }
  }

  /// 로그인
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      // 로그인 전 기존 토큰만 삭제
      await removeToken();

      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      final data = response.data;
      // 토큰만 저장, 사용자 데이터는 AuthController에서 관리
      await saveToken(data['access_token']);

      return data;
    } on DioException catch (e) {
      throw _handleDioError(e, '로그인');
    }
  }

  /// 로그아웃
  static Future<void> logout() async {
    // 토큰만 삭제 (사용자 데이터는 AuthController에서 관리)
    await removeToken();

    // 소켓 연결 해제
    _disconnectSocket();

    // Hive 박스 토큰만 완전히 비우기
    final tokenBox = Hive.box(_tokenBoxName);
    await tokenBox.clear();

    print('✅ 로그아웃 완료: 토큰 삭제됨');
  }

  // ==================== 사용자 관련 API ====================

  /// 내 프로필 조회
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _dio.get('/users/profile');
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e, '프로필 조회');
    }
  }

  /// 프로필 수정
  static Future<Map<String, dynamic>> updateProfile({
    String? nickname,
    String? age,
    List<String>? foodPreferences,
    String? profileImageUrl,
  }) async {
    try {
      final response = await _dio.patch('/users/profile', data: {
        if (nickname != null) 'nickname': nickname,
        if (age != null) 'age': age,
        if (foodPreferences != null) 'food_preferences': foodPreferences,
        if (profileImageUrl != null) 'profile_image_url': profileImageUrl,
      });

      // 사용자 데이터는 AuthController에서 관리
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e, '프로필 수정');
    }
  }

  /// 위치 업데이트
  static Future<void> updateLocation({
    required double latitude,
    required double longitude,
  }) async {
    try {
      await _dio.post('/users/location', data: {
        'latitude': latitude,
        'longitude': longitude,
      });
    } on DioException catch (e) {
      throw _handleDioError(e, '위치 업데이트');
    }
  }

  /// 근처 사용자 조회
  static Future<List<Map<String, dynamic>>> getNearbyUsers({
    required double latitude,
    required double longitude,
    int maxDistance = 1000,
  }) async {
    try {
      final response = await _dio.get('/users/nearby', queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'maxDistance': maxDistance,
      });

      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e, '근처 사용자 조회');
    }
  }

  // ==================== 게시글 관련 API ====================

  /// 게시글 목록 조회
  static Future<List<Map<String, dynamic>>> getPosts({
    String? foodType,
    double? latitude,
    double? longitude,
    int? maxDistance,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (foodType != null) queryParams['food_type'] = foodType;
      if (latitude != null) queryParams['latitude'] = latitude;
      if (longitude != null) queryParams['longitude'] = longitude;
      if (maxDistance != null) queryParams['max_distance'] = maxDistance;

      final response = await _dio.get('/posts', queryParameters: queryParams);

      // API 응답이 { data: [...], meta: {...} } 형식
      if (response.data is Map && response.data.containsKey('data')) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      }

      // 만약 직접 배열로 오는 경우 (하위 호환)
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e, '게시글 조회');
    }
  }

  /// 게시글 생성
  static Future<Map<String, dynamic>> createPost({
    required String title,
    required String content,
    required String place,
    required String menu,
    required String time,
    required String foodType,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final response = await _dio.post('/posts', data: {
        'title': title,
        'content': content,
        'place': place,
        'menu': menu,
        'time': time,
        'food_type': foodType,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      });

      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e, '게시글 생성');
    }
  }

  /// 게시글 수정
  static Future<Map<String, dynamic>> updatePost({
    required int postId,
    String? title,
    String? content,
    String? place,
    String? menu,
    String? time,
    String? foodType,
  }) async {
    try {
      final response = await _dio.patch('/posts/$postId', data: {
        if (title != null) 'title': title,
        if (content != null) 'content': content,
        if (place != null) 'place': place,
        if (menu != null) 'menu': menu,
        if (time != null) 'time': time,
        if (foodType != null) 'food_type': foodType,
      });

      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e, '게시글 수정');
    }
  }

  /// 게시글 삭제
  static Future<void> deletePost(int postId) async {
    try {
      await _dio.delete('/posts/$postId');
    } on DioException catch (e) {
      throw _handleDioError(e, '게시글 삭제');
    }
  }

  // ==================== 친구 관계 API ====================

  /// 친구 요청
  static Future<Map<String, dynamic>> sendFriendRequest(int friendId) async {
    try {
      final response = await _dio.post('/friendships/request', data: {
        'friend_id': friendId,
      });

      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e, '친구 요청');
    }
  }

  /// 친구 목록 조회
  static Future<List<Map<String, dynamic>>> getFriendships() async {
    try {
      final response = await _dio.get('/friendships');
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e, '친구 목록 조회');
    }
  }

  /// 친구 요청 수락
  static Future<Map<String, dynamic>> acceptFriendRequest(
      int friendshipId) async {
    try {
      final response = await _dio.put('/friendships/$friendshipId/accept');
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e, '친구 요청 수락');
    }
  }

  /// 친구 요청 거절
  static Future<Map<String, dynamic>> rejectFriendRequest(
      int friendshipId) async {
    try {
      final response = await _dio.put('/friendships/$friendshipId/reject');
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e, '친구 요청 거절');
    }
  }

  /// 친구 관계 삭제
  static Future<void> deleteFriendship(int friendshipId) async {
    try {
      await _dio.delete('/friendships/$friendshipId');
    } on DioException catch (e) {
      throw _handleDioError(e, '친구 관계 삭제');
    }
  }

  // ==================== 메시지 API ====================

  /// 메시지 목록 조회
  static Future<List<Map<String, dynamic>>> getMessages(
      int friendshipId) async {
    try {
      final response = await _dio.get('/messages/$friendshipId');
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e, '메시지 조회');
    }
  }

  /// 메시지 전송
  static Future<Map<String, dynamic>> sendMessage({
    required int friendshipId,
    required String content,
    String messageType = 'text',
    String? imageUrl,
  }) async {
    try {
      final response = await _dio.post('/messages/$friendshipId', data: {
        'content': content,
        'message_type': messageType,
        if (imageUrl != null) 'image_url': imageUrl,
      });

      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e, '메시지 전송');
    }
  }

  /// 메시지 읽음 처리
  static Future<void> markMessageAsRead(int messageId) async {
    try {
      await _dio.put('/messages/$messageId/read');
    } on DioException catch (e) {
      throw _handleDioError(e, '메시지 읽음 처리');
    }
  }

  // ==================== Socket.io 연결 ====================

  /// Socket.io 연결
  static void connectSocket() async {
    if (_socket != null && _socket!.connected) {
      print('✅ Socket 이미 연결되어 있음');
      return;
    }

    final token = await getToken();
    print('🔌 Socket 연결 시도... (Token: ${token?.substring(0, 20)}...)');

    _socket = IO.io('http://localhost:3000/chat', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': {
        'token': token,
      },
    });

    _socket!.connect();

    _socket!.onConnect((_) {
      print('✅ Socket 연결 성공!');
    });

    _socket!.onDisconnect((_) {
      print('❌ Socket 연결 끊김');
    });

    _socket!.onError((error) {
      print('⚠️ Socket 오류: $error');
    });

    _socket!.onConnectError((error) {
      print('⚠️ Socket 연결 오류: $error');
    });
  }

  /// Socket.io 연결 해제
  static void _disconnectSocket() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket = null;
    }
  }

  /// 채팅방 입장
  static void joinChatRoom(int friendshipId) async {
    if (_socket != null && _socket!.connected) {
      try {
        //final authController = Get.find<dynamic>();
        final authController = Get.find<AuthController>();
        final userId = authController.userData['id'];
        print('🚪 채팅방 입장 요청: friendshipId=$friendshipId, userId=$userId');
        _socket!.emit('join_room', {
          'friendshipId': friendshipId,
          'userId': userId,
        });
      } catch (e) {
        print('❌ AuthController를 찾을 수 없음: $e');
      }
    } else {
      print('❌ Socket이 연결되지 않아 채팅방 입장 불가');
    }
  }

  /// 채팅방 퇴장
  static void leaveChatRoom(int friendshipId) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit('leave_room', {'friendshipId': friendshipId});
    }
  }

  /// 실시간 메시지 전송
  static void sendRealtimeMessage({
    required int friendshipId,
    required String content,
    String messageType = 'text',
    String? imageUrl,
  }) async {
    if (_socket != null && _socket!.connected) {
      try {
        //final authController = Get.find<dynamic>();
        final authController = Get.find<AuthController>();
        final userId = authController.userData['id'];
        print(
            '📤 메시지 전송: friendshipId=$friendshipId, userId=$userId, content=$content');
        _socket!.emit('send_message', {
          'friendshipId': friendshipId,
          'userId': userId,
          'content': content,
          'messageType': messageType,
          if (imageUrl != null) 'imageUrl': imageUrl,
        });
      } catch (e) {
        print('❌ AuthController를 찾을 수 없음: $e');
      }
    } else {
      print('❌ Socket이 연결되지 않아 메시지 전송 불가');
    }
  }

  /// 메시지 수신 리스너 등록
  static void onMessageReceived(Function(Map<String, dynamic>) callback) {
    if (_socket != null) {
      // 기존 리스너 제거 (중복 방지)
      _socket!.off('new_message');

      print('👂 new_message 리스너 등록');
      _socket!.on('new_message', (data) {
        print('📨 new_message 이벤트 수신: $data');
        callback(Map<String, dynamic>.from(data));
      });
    } else {
      print('❌ Socket이 null이라 리스너 등록 불가');
    }
  }

  /// 타이핑 상태 전송
  static void sendTypingStatus({
    required int friendshipId,
    required bool isTyping,
  }) async {
    if (_socket != null && _socket!.connected) {
      try {
        //final authController = Get.find<dynamic>();
        final authController = Get.find<AuthController>();
        final userId = authController.userData['id'];
        _socket!.emit('typing', {
          'friendshipId': friendshipId,
          'userId': userId,
          'isTyping': isTyping,
        });
      } catch (e) {
        print('❌ AuthController를 찾을 수 없음: $e');
      }
    }
  }

  /// 타이핑 상태 수신 리스너 등록
  static void onTypingStatusReceived(Function(Map<String, dynamic>) callback) {
    if (_socket != null) {
      // 기존 리스너 제거 (중복 방지)
      _socket!.off('user_typing');

      print('👂 user_typing 리스너 등록');
      _socket!.on('user_typing', (data) {
        print('⌨️ user_typing 이벤트 수신: $data');
        callback(Map<String, dynamic>.from(data));
      });
    } else {
      print('❌ Socket이 null이라 리스너 등록 불가');
    }
  }

  // ==================== 파일 업로드 ====================

  /// 이미지 업로드
  static Future<String> uploadImage(File imageFile) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imageFile.path),
      });

      final response = await _dio.post('/upload/image', data: formData);
      return response.data['image_url'];
    } on DioException catch (e) {
      throw _handleDioError(e, '이미지 업로드');
    }
  }

  // ==================== 유틸리티 ====================

  /// Dio 에러 처리
  static String _handleDioError(DioException e, String operation) {
    String message = '$operation 실패';

    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final data = e.response!.data;

      switch (statusCode) {
        case 400:
          message = data['message'] ?? '잘못된 요청입니다.';
          break;
        case 401:
          message = '인증이 필요합니다.';
          break;
        case 403:
          message = '권한이 없습니다.';
          break;
        case 404:
          message = '요청한 리소스를 찾을 수 없습니다.';
          break;
        case 409:
          message = data['message'] ?? '이미 존재하는 데이터입니다.';
          break;
        case 500:
          message = '서버 오류가 발생했습니다.';
          break;
        default:
          message = data['message'] ?? '알 수 없는 오류가 발생했습니다.';
      }
    } else if (e.type == DioExceptionType.connectionTimeout) {
      message = '연결 시간이 초과되었습니다.';
    } else if (e.type == DioExceptionType.receiveTimeout) {
      message = '응답 시간이 초과되었습니다.';
    } else if (e.type == DioExceptionType.connectionError) {
      message = '서버에 연결할 수 없습니다.';
    }

    return message;
  }

  /// 연결 상태 확인
  static bool get isConnected => _socket?.connected ?? false;

  /// 토큰 유효성 확인
  static Future<bool> isTokenValid() async {
    final token = await getToken();
    return token != null;
  }
}
