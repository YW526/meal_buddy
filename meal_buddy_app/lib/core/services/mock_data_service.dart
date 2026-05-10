import 'dart:math';

class MockDataService {
  static final Random _random = Random();

  // 가상 사용자 데이터
  static final List<Map<String, dynamic>> _mockUsers = [
    {
      'id': 1,
      'nickname': '김밥친구',
      'food_preferences': ['한식', '분식'],
      'profile_image_url': 'https://picsum.photos/200/200?random=1',
      'latitude': 37.5665,
      'longitude': 126.9780,
      'temperature': 75,
      'last_active': DateTime.now().subtract(const Duration(minutes: 5)),
      'is_online': true,
      'distance': 120,
    },
    {
      'id': 2,
      'nickname': '피자러버',
      'food_preferences': ['양식', '피자'],
      'profile_image_url': 'https://picsum.photos/200/200?random=2',
      'latitude': 37.5665,
      'longitude': 126.9780,
      'temperature': 60,
      'last_active': DateTime.now().subtract(const Duration(minutes: 10)),
      'is_online': false,
      'distance': 350,
    },
    {
      'id': 3,
      'nickname': '초밥마스터',
      'food_preferences': ['일식', '초밥'],
      'profile_image_url': 'https://picsum.photos/200/200?random=3',
      'latitude': 37.5665,
      'longitude': 126.9780,
      'temperature': 85,
      'last_active': DateTime.now().subtract(const Duration(minutes: 2)),
      'is_online': true,
      'distance': 80,
    },
    {
      'id': 4,
      'nickname': '중식탐험가',
      'food_preferences': ['중식', '마라탕'],
      'profile_image_url': 'https://picsum.photos/200/200?random=4',
      'latitude': 37.5665,
      'longitude': 126.9780,
      'temperature': 45,
      'last_active': DateTime.now().subtract(const Duration(minutes: 15)),
      'is_online': false,
      'distance': 520,
    },
    {
      'id': 5,
      'nickname': '카페인러버',
      'food_preferences': ['카페', '디저트'],
      'profile_image_url': 'https://picsum.photos/200/200?random=5',
      'latitude': 37.5665,
      'longitude': 126.9780,
      'temperature': 90,
      'last_active': DateTime.now().subtract(const Duration(minutes: 1)),
      'is_online': true,
      'distance': 200,
    },
  ];

  // 가상 친구 관계 데이터
  static final List<Map<String, dynamic>> _mockFriendships = [
    {
      'id': 1,
      'user_id': 1,
      'friend_id': 2,
      'status': 'accepted',
      'temperature': 75,
      'friend': _mockUsers[1],
      'last_message': '오늘 점심 같이 먹을까요?',
      'last_message_time': DateTime.now().subtract(const Duration(minutes: 30)),
      'unread_count': 2,
    },
    {
      'id': 2,
      'user_id': 1,
      'friend_id': 3,
      'status': 'accepted',
      'temperature': 85,
      'friend': _mockUsers[2],
      'last_message': '좋아요! 어디서 만날까요?',
      'last_message_time': DateTime.now().subtract(const Duration(hours: 2)),
      'unread_count': 0,
    },
    {
      'id': 3,
      'user_id': 1,
      'friend_id': 4,
      'status': 'pending',
      'temperature': 50,
      'friend': _mockUsers[3],
      'last_message': null,
      'last_message_time': null,
      'unread_count': 0,
    },
  ];

  // 가상 메시지 데이터
  static final List<Map<String, dynamic>> _mockMessages = [
    {
      'id': 1,
      'friendship_id': 1,
      'sender_id': 2,
      'content': '안녕하세요! 밥 같이 먹을까요?',
      'message_type': 'text',
      'is_read': false,
      'created_at': DateTime.now().subtract(const Duration(minutes: 30)),
      'sender': _mockUsers[1],
    },
    {
      'id': 2,
      'friendship_id': 1,
      'sender_id': 1,
      'content': '네! 좋아요. 어디서 만날까요?',
      'message_type': 'text',
      'is_read': true,
      'created_at': DateTime.now().subtract(const Duration(minutes: 25)),
      'sender': _mockUsers[0],
    },
    {
      'id': 3,
      'friendship_id': 1,
      'sender_id': 2,
      'content': '강남역 근처 어때요?',
      'message_type': 'text',
      'is_read': false,
      'created_at': DateTime.now().subtract(const Duration(minutes: 20)),
      'sender': _mockUsers[1],
    },
    {
      'id': 4,
      'friendship_id': 2,
      'sender_id': 3,
      'content': '오늘 초밥 어때요?',
      'message_type': 'text',
      'is_read': true,
      'created_at': DateTime.now().subtract(const Duration(hours: 2)),
      'sender': _mockUsers[2],
    },
    {
      'id': 5,
      'friendship_id': 2,
      'sender_id': 1,
      'content': '좋아요! 어디서 만날까요?',
      'message_type': 'text',
      'is_read': true,
      'created_at':
          DateTime.now().subtract(const Duration(hours: 1, minutes: 55)),
      'sender': _mockUsers[0],
    },
  ];

  // 가상 온도 기록 데이터
  static final List<Map<String, dynamic>> _mockTemperatureHistory = [
    {
      'id': 1,
      'friendship_id': 1,
      'old_temperature': 70,
      'new_temperature': 75,
      'reason': 'chat',
      'description': '채팅 활동',
      'created_at': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'id': 2,
      'friendship_id': 1,
      'old_temperature': 65,
      'new_temperature': 70,
      'reason': 'accept',
      'description': '친구 요청 수락',
      'created_at': DateTime.now().subtract(const Duration(days: 3)),
    },
    {
      'id': 3,
      'friendship_id': 2,
      'old_temperature': 80,
      'new_temperature': 85,
      'reason': 'chat',
      'description': '채팅 활동',
      'created_at': DateTime.now().subtract(const Duration(hours: 12)),
    },
  ];

  // 근처 사용자 조회 (가상)
  static Future<List<Map<String, dynamic>>> getNearbyUsers({
    required double latitude,
    required double longitude,
    int maxDistance = 1000,
  }) async {
    // 모의 지연
    await Future.delayed(Duration(milliseconds: 500 + _random.nextInt(1000)));

    // 거리별로 필터링된 사용자 반환
    return _mockUsers.where((user) => user['distance'] <= maxDistance).toList();
  }

  // 친구 목록 조회 (가상)
  static Future<List<Map<String, dynamic>>> getFriends() async {
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(500)));
    return _mockFriendships;
  }

  // 메시지 조회 (가상)
  static Future<List<Map<String, dynamic>>> getMessages(
      int friendshipId) async {
    await Future.delayed(Duration(milliseconds: 200 + _random.nextInt(300)));

    return _mockMessages
        .where((message) => message['friendship_id'] == friendshipId)
        .toList()
      ..sort((a, b) => b['created_at'].compareTo(a['created_at']));
  }

  // 메시지 전송 (가상)
  static Future<Map<String, dynamic>> sendMessage({
    required int friendshipId,
    required String content,
    String messageType = 'text',
    String? imageUrl,
  }) async {
    await Future.delayed(Duration(milliseconds: 100 + _random.nextInt(200)));

    final newMessage = {
      'id': _mockMessages.length + 1,
      'friendship_id': friendshipId,
      'sender_id': 1, // 현재 사용자
      'content': content,
      'message_type': messageType,
      'image_url': imageUrl,
      'is_read': false,
      'created_at': DateTime.now(),
      'sender': _mockUsers[0], // 현재 사용자
    };

    _mockMessages.add(newMessage);

    // 온도 증가 (채팅 시)
    final friendship = _mockFriendships.firstWhere(
      (f) => f['id'] == friendshipId,
      orElse: () => <String, dynamic>{},
    );

    if (friendship != null && friendship['status'] == 'accepted') {
      final oldTemp = friendship['temperature'];
      friendship['temperature'] = (oldTemp + 1).clamp(0, 100);
    }

    return newMessage;
  }

  // 친구 요청 전송 (가상)
  static Future<Map<String, dynamic>> sendFriendRequest(int friendId) async {
    await Future.delayed(Duration(milliseconds: 500 + _random.nextInt(1000)));

    final newFriendship = {
      'id': _mockFriendships.length + 1,
      'user_id': 1,
      'friend_id': friendId,
      'status': 'pending',
      'temperature': 50,
      'friend': _mockUsers.firstWhere((u) => u['id'] == friendId),
      'last_message': null,
      'last_message_time': null,
      'unread_count': 0,
    };

    _mockFriendships.add(newFriendship);
    return newFriendship;
  }

  // 친구 요청 응답 (가상)
  static Future<Map<String, dynamic>> respondToFriendRequest({
    required int friendshipId,
    required String action, // 'accept' or 'reject'
  }) async {
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(500)));

    final friendship =
        _mockFriendships.firstWhere((f) => f['id'] == friendshipId);

    if (action == 'accept') {
      friendship['status'] = 'accepted';
      friendship['temperature'] = 60; // 수락 시 온도 증가
    } else if (action == 'reject') {
      friendship['status'] = 'rejected';
      friendship['temperature'] = 40; // 거절 시 온도 감소
    }

    return friendship;
  }

  // 온도 기록 조회 (가상)
  static Future<List<Map<String, dynamic>>> getTemperatureHistory(
      int friendshipId) async {
    await Future.delayed(Duration(milliseconds: 200 + _random.nextInt(300)));

    return _mockTemperatureHistory
        .where((record) => record['friendship_id'] == friendshipId)
        .toList()
      ..sort((a, b) => b['created_at'].compareTo(a['created_at']));
  }

  // 프로필 조회 (가상)
  static Future<Map<String, dynamic>> getProfile() async {
    await Future.delayed(Duration(milliseconds: 200 + _random.nextInt(300)));

    return {
      'id': 1,
      'email': 'test@example.com',
      'nickname': '테스트사용자',
      'food_preferences': ['한식', '양식'],
      'profile_image_url': 'https://picsum.photos/200/200?random=0',
      'latitude': 37.5665,
      'longitude': 126.9780,
      'last_active': DateTime.now(),
      'is_online': true,
      'created_at': DateTime.now().subtract(const Duration(days: 30)),
      'stats': {
        'total_friends': 15,
        'total_meetings': 8,
        'average_temperature': 72,
      },
    };
  }

  // 프로필 업데이트 (가상)
  static Future<Map<String, dynamic>> updateProfile({
    String? nickname,
    List<String>? foodPreferences,
    String? profileImageUrl,
  }) async {
    await Future.delayed(Duration(milliseconds: 500 + _random.nextInt(1000)));

    // 실제로는 서버에서 업데이트하지만, 여기서는 성공 응답만 반환
    return {
      'success': true,
      'message': '프로필이 성공적으로 업데이트되었습니다.',
    };
  }

  // 위치 업데이트 (가상)
  static Future<void> updateLocation({
    required double latitude,
    required double longitude,
  }) async {
    await Future.delayed(Duration(milliseconds: 200 + _random.nextInt(300)));
    // 실제로는 서버에서 위치를 업데이트하지만, 여기서는 성공만 반환
  }

  // 로그인 (가상)
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(Duration(milliseconds: 1000 + _random.nextInt(2000)));

    if (email == 'test@example.com' && password == 'password') {
      return {
        'success': true,
        'access_token':
            'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
        'user': await getProfile(),
      };
    } else {
      throw Exception('이메일 또는 비밀번호가 올바르지 않습니다.');
    }
  }

  // 회원가입 (가상)
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String nickname,
    required List<String> foodPreferences,
  }) async {
    await Future.delayed(Duration(milliseconds: 1500 + _random.nextInt(2000)));

    return {
      'success': true,
      'access_token': 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
      'user': {
        'id': _mockUsers.length + 1,
        'email': email,
        'nickname': nickname,
        'food_preferences': foodPreferences,
        'profile_image_url': null,
        'latitude': null,
        'longitude': null,
        'last_active': DateTime.now(),
        'is_online': true,
        'created_at': DateTime.now(),
      },
    };
  }

  // 로그아웃 (가상)
  static Future<void> logout() async {
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(500)));
    // 실제로는 토큰을 삭제하지만, 여기서는 성공만 반환
  }
}
