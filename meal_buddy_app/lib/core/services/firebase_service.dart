import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5000/api';
  static const String _tokenBoxName = 'auth_tokens';

  // Hive 초기화
  static Future<void> initialize() async {
    await Hive.initFlutter();
    await Hive.openBox(_tokenBoxName);
  }

  // 토큰 저장/조회
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

  // HTTP 헤더 생성
  static Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // 인증 관련 API
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String nickname,
    required List<String> foodPreferences,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'email': email,
        'password': password,
        'nickname': nickname,
        'food_preferences': foodPreferences,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      await saveToken(data['access_token']);
      return data;
    } else {
      throw Exception('회원가입 실패: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await saveToken(data['access_token']);
      return data;
    } else {
      throw Exception('로그인 실패: ${response.body}');
    }
  }

  static Future<void> logout() async {
    await removeToken();
  }

  // 사용자 관련 API
  static Future<Map<String, dynamic>> getProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/profile'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('프로필 조회 실패: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> updateProfile({
    String? nickname,
    List<String>? foodPreferences,
    String? profileImageUrl,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/profile'),
      headers: await _getHeaders(),
      body: jsonEncode({
        if (nickname != null) 'nickname': nickname,
        if (foodPreferences != null) 'food_preferences': foodPreferences,
        if (profileImageUrl != null) 'profile_image_url': profileImageUrl,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('프로필 수정 실패: ${response.body}');
    }
  }

  static Future<List<Map<String, dynamic>>> getNearbyUsers({
    required double latitude,
    required double longitude,
    int maxDistance = 1000,
  }) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/users/nearby?lat=$latitude&lng=$longitude&distance=$maxDistance'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['users']);
    } else {
      throw Exception('근처 사용자 조회 실패: ${response.body}');
    }
  }

  static Future<void> updateLocation({
    required double latitude,
    required double longitude,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/location'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'latitude': latitude,
        'longitude': longitude,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('위치 업데이트 실패: ${response.body}');
    }
  }

  // 친구 관련 API
  static Future<List<Map<String, dynamic>>> getFriends() async {
    final response = await http.get(
      Uri.parse('$baseUrl/friends'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['friendships']);
    } else {
      throw Exception('친구 목록 조회 실패: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> sendFriendRequest(int friendId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/friends/request'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'friend_id': friendId,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('친구 요청 실패: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> respondToFriendRequest({
    required int friendshipId,
    required String action, // 'accept' or 'reject'
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/friends/$action'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'friendship_id': friendshipId,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('친구 요청 응답 실패: ${response.body}');
    }
  }

  static Future<void> deleteFriendship(int friendshipId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/friends/$friendshipId'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception('친구 관계 삭제 실패: ${response.body}');
    }
  }

  // 메시지 관련 API
  static Future<List<Map<String, dynamic>>> getMessages(
      int friendshipId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/messages/$friendshipId'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['messages']);
    } else {
      throw Exception('메시지 조회 실패: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> sendMessage({
    required int friendshipId,
    required String content,
    String messageType = 'text',
    String? imageUrl,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/messages'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'friendship_id': friendshipId,
        'content': content,
        'message_type': messageType,
        if (imageUrl != null) 'image_url': imageUrl,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('메시지 전송 실패: ${response.body}');
    }
  }

  static Future<void> markMessagesAsRead(int friendshipId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/messages/read'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'friendship_id': friendshipId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('메시지 읽음 처리 실패: ${response.body}');
    }
  }

  // 이미지 업로드 (로컬 스토리지 사용)
  static Future<String> uploadImage(
      List<int> imageBytes, String fileName) async {
    // 실제 구현에서는 Flask 백엔드의 파일 업로드 API를 사용
    // 현재는 임시로 로컬 경로 반환
    return 'uploads/$fileName';
  }

  // 온도 시스템 관련 API
  static Future<Map<String, dynamic>> getTemperatureHistory(
      int friendshipId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/friends/$friendshipId/temperature'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('온도 기록 조회 실패: ${response.body}');
    }
  }
}
