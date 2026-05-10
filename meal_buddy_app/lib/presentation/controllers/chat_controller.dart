import 'package:get/get.dart';
import '../../core/services/api_service.dart';

class ChatController extends GetxController {
  final _isLoading = false.obs;
  final _messages = <Map<String, dynamic>>[].obs;
  final _isTyping = false.obs;
  final _otherUserTyping = false.obs;
  final _currentFriendshipId = 0.obs;
  

  // Getters
  bool get isLoading => _isLoading.value;
  List<Map<String, dynamic>> get messages => _messages;
  bool get isTyping => _isTyping.value;
  bool get otherUserTyping => _otherUserTyping.value;
  int get currentFriendshipId => _currentFriendshipId.value;

  @override
  void onInit() {
    super.onInit();
    // Socket 리스너는 enterChatRoom에서 설정
  }

  @override
  void onClose() {
    _leaveCurrentRoom();
    super.onClose();
  }

  /// Socket.io 리스너 설정
  void _setupSocketListeners() {
    print('👂 Socket 리스너 설정 시작');

    // 메시지 수신 리스너
    ApiService.onMessageReceived((message) {
      print('📨 메시지 수신: $message');
      // friendship_id 또는 friendshipId 모두 지원
      final messageFriendshipId =
          message['friendship_id'] ?? message['friendshipId'];
      if (messageFriendshipId == _currentFriendshipId.value) {
        _messages.add(message);
        _messages.refresh();
        print('✅ 메시지 추가됨. 총 ${_messages.length}개');
      } else {
        print(
            '❌ 다른 채팅방의 메시지: $messageFriendshipId vs ${_currentFriendshipId.value}');
      }
    });

    // 타이핑 상태 수신 리스너
    ApiService.onTypingStatusReceived((data) {
      print('⌨️ 타이핑 상태 수신: $data');
      final dataFriendshipId = data['friendship_id'] ?? data['friendshipId'];
      if (dataFriendshipId == _currentFriendshipId.value) {
        _otherUserTyping.value = data['is_typing'] ?? data['isTyping'] ?? false;
      }
    });

    print('✅ Socket 리스너 설정 완료');
  }

  /// 채팅방 입장
  Future<void> enterChatRoom(int friendshipId) async {
    _leaveCurrentRoom();

    _currentFriendshipId.value = friendshipId;
    _messages.clear();

    print('🚪 채팅방 입장: Friendship ID = $friendshipId');

    // Socket.io 연결
    ApiService.connectSocket();

    // Socket 연결 대기
    await Future.delayed(const Duration(milliseconds: 500));

    // Socket 리스너 설정 (연결 후에 설정)
    _setupSocketListeners();

    // 채팅방 입장
    ApiService.joinChatRoom(friendshipId);

    // 메시지 로드
    await loadMessages(friendshipId);
  }

  /// 채팅방 퇴장
  void _leaveCurrentRoom() {
    if (_currentFriendshipId.value > 0) {
      ApiService.leaveChatRoom(_currentFriendshipId.value);
      _currentFriendshipId.value = 0;
    }
  }

  /// 메시지 로드
  Future<void> loadMessages(int friendshipId) async {
    _isLoading.value = true;

    try {
      final messages = await ApiService.getMessages(friendshipId);
      _messages.value = messages;
    } catch (e) {
      Get.snackbar('오류', '메시지를 불러오는데 실패했습니다.');
    } finally {
      _isLoading.value = false;
    }
  }

  /// 메시지 전송
  Future<bool> sendMessage({
    required String content,
    String messageType = 'text',
    String? imageUrl,
  }) async {
    if (content.trim().isEmpty && imageUrl == null) {
      return false;
    }

    if (_currentFriendshipId.value == 0) {
      Get.snackbar('오류', '채팅방에 입장하지 않았습니다.');
      return false;
    }

    try {
      print('📤 메시지 전송: $content');

      // 실시간 메시지 전송
      ApiService.sendRealtimeMessage(
        friendshipId: _currentFriendshipId.value,
        content: content.trim(),
        messageType: messageType,
        imageUrl: imageUrl,
      );

      // 타이핑 상태 해제
      _isTyping.value = false;
      ApiService.sendTypingStatus(
        friendshipId: _currentFriendshipId.value,
        isTyping: false,
      );

      return true;
    } catch (e) {
      print('❌ 메시지 전송 실패: $e');
      Get.snackbar('오류', '메시지 전송에 실패했습니다.');
      return false;
    }
  }

  /// 타이핑 상태 전송
  void sendTypingStatus(bool isTyping) {
    if (_currentFriendshipId.value > 0) {
      _isTyping.value = isTyping;
      ApiService.sendTypingStatus(
        friendshipId: _currentFriendshipId.value,
        isTyping: isTyping,
      );
    }
  }

  /// 메시지 읽음 처리
  Future<void> markMessageAsRead(int messageId) async {
    try {
      await ApiService.markMessageAsRead(messageId);

      // 로컬 메시지 상태 업데이트
      final messageIndex =
          _messages.indexWhere((msg) => msg['id'] == messageId);
      if (messageIndex != -1) {
        _messages[messageIndex]['is_read'] = true;
        _messages.refresh();
      }
    } catch (e) {
      print('메시지 읽음 처리 실패: $e');
    }
  }

  /// 모든 메시지 읽음 처리
  Future<void> markAllMessagesAsRead() async {
    for (final message in _messages) {
      if (message['is_read'] == false) {
        await markMessageAsRead(message['id']);
      }
    }
  }

  /// 메시지 검색
  List<Map<String, dynamic>> searchMessages(String query) {
    if (query.isEmpty) return _messages;

    return _messages.where((message) {
      final content = message['content']?.toString().toLowerCase() ?? '';
      return content.contains(query.toLowerCase());
    }).toList();
  }

  /// 이미지 메시지만 필터링
  List<Map<String, dynamic>> getImageMessages() {
    return _messages.where((message) {
      return message['message_type'] == 'image';
    }).toList();
  }

  /// 위치 메시지만 필터링
  List<Map<String, dynamic>> getLocationMessages() {
    return _messages.where((message) {
      return message['message_type'] == 'location';
    }).toList();
  }

  /// 읽지 않은 메시지 개수
  int get unreadMessageCount {
    return _messages.where((message) => message['is_read'] == false).length;
  }

  /// 메시지 개수
  int get messageCount => _messages.length;

  /// 마지막 메시지
  Map<String, dynamic>? get lastMessage {
    if (_messages.isEmpty) return null;
    return _messages.last;
  }

  /// 메시지 새로고침
  Future<void> refreshMessages() async {
    if (_currentFriendshipId.value > 0) {
      await loadMessages(_currentFriendshipId.value);
    }
  }
}
