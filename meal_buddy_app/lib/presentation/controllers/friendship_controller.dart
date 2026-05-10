import 'package:get/get.dart';
import '../../core/services/api_service.dart';
import './auth_controller.dart';

class FriendshipController extends GetxController {
  final _isLoading = false.obs;
  final _friendships = <Map<String, dynamic>>[].obs;
  final _nearbyUsers = <Map<String, dynamic>>[].obs;
  final _pendingRequests = <Map<String, dynamic>>[].obs;

  // Getters
  bool get isLoading => _isLoading.value;
  List<Map<String, dynamic>> get friendships => _friendships.toList();
  List<Map<String, dynamic>> get nearbyUsers => _nearbyUsers.toList();
  List<Map<String, dynamic>> get pendingRequests => _pendingRequests.toList();

  @override
  void onInit() {
    super.onInit();

    // AuthController 가져오기
    final authController = Get.find<AuthController>();

    // 로그인 상태 변화 감지
    ever(authController.isLoggedInRx, (isLoggedIn) {
      if (isLoggedIn) {
        // 로그인 상태면 친구 목록 로드
        loadFriendships();
      } else {
        // 로그아웃 상태면 목록 비우기
        _friendships.clear();
        _nearbyUsers.clear();
        _pendingRequests.clear();
      }
    });

    // 이미 로그인 상태라면 즉시 로드
    if (authController.isLoggedIn) {
      loadFriendships();
    }
  }

  /// 친구 목록 로드
  Future<void> loadFriendships() async {
    _isLoading.value = true;

    try {
      final friendships = await ApiService.getFriendships();

      // 디버깅: API 응답 확인
      print('🔍 [FriendshipController] API 응답 받음: ${friendships.length}개');
      for (var f in friendships) {
        print(
            '  - ID: ${f['id']}, Status: ${f['status']}, User: ${f['user']?['nickname']}, Friend: ${f['friend']?['nickname']}');
      }

      final authController = Get.find<AuthController>();
      final currentUserId = authController.userData['id'];

      // 각 friendship을 올바르게 파싱
      _friendships.value = friendships.map((f) {
        // 현재 사용자가 user_id인지 friend_id인지 확인
        final isUserInitiator = f['user_id'] == currentUserId;
        final friend = isUserInitiator ? f['friend'] : f['user'];
        final user = isUserInitiator ? f['user'] : f['friend'];

        return {
          'id': f['id'],
          'user_id': f['user_id'],
          'friend_id': f['friend_id'],
          'status': f['status'],
          'temperature': f['temperature'],
          'created_at': f['created_at'],
          'user': user != null ? Map<String, dynamic>.from(user) : null,
          'friend': friend != null ? Map<String, dynamic>.from(friend) : null,
        };
      }).toList();

      // 디버깅: 파싱된 데이터 확인
      print('🔍 [FriendshipController] 파싱 완료: ${_friendships.length}개');
      final acceptedCount =
          _friendships.where((f) => f['status'] == 'accepted').length;
      print('  - Accepted: $acceptedCount개');
      print(
          '  - Pending: ${_friendships.where((f) => f['status'] == 'pending').length}개');

      // 대기 중인 요청 분리
      _pendingRequests.value = _friendships
          .where((friendship) => friendship['status'] == 'pending')
          .toList();
    } catch (e) {
      print('❌ [FriendshipController] 오류: $e');
      Get.snackbar('오류', '친구 목록을 불러오는데 실패했습니다: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  /// 근처 사용자 로드
  Future<void> loadNearbyUsers({
    required double latitude,
    required double longitude,
    int maxDistance = 1000,
  }) async {
    _isLoading.value = true;

    try {
      final users = await ApiService.getNearbyUsers(
        latitude: latitude,
        longitude: longitude,
        maxDistance: maxDistance,
      );

      // 이미 친구인 사용자 제외
      final friendIds = friendships
          .map((friendship) => friendship['friend_id'] as int)
          .toList();

      _nearbyUsers.value = users
          .where((user) => !friendIds.contains(user['user']['id']))
          .toList();
    } catch (e) {
      Get.snackbar('오류', '근처 사용자를 불러오는데 실패했습니다.');
    } finally {
      _isLoading.value = false;
    }
  }

  /// 친구 요청 보내기
  Future<bool> sendFriendRequest(int friendId) async {
    try {
      await ApiService.sendFriendRequest(friendId);

      Get.snackbar('성공', '친구 요청을 보냈습니다.');

      // 근처 사용자 목록에서 제거
      _nearbyUsers.removeWhere((user) => user['user']['id'] == friendId);

      return true;
    } catch (e) {
      Get.snackbar('오류', e.toString());
      return false;
    }
  }

  /// 친구 요청 수락
  Future<bool> acceptFriendRequest(int friendshipId) async {
    try {
      await ApiService.acceptFriendRequest(friendshipId);

      Get.snackbar('성공', '친구 요청을 수락했습니다.');

      // 친구 목록 새로고침
      await loadFriendships();

      return true;
    } catch (e) {
      Get.snackbar('오류', e.toString());
      return false;
    }
  }

  /// 친구 요청 거절
  Future<bool> rejectFriendRequest(int friendshipId) async {
    try {
      await ApiService.rejectFriendRequest(friendshipId);

      Get.snackbar('성공', '친구 요청을 거절했습니다.');

      // 친구 목록 새로고침
      await loadFriendships();

      return true;
    } catch (e) {
      Get.snackbar('오류', e.toString());
      return false;
    }
  }

  /// 친구 관계 삭제
  Future<bool> deleteFriendship(int friendshipId) async {
    try {
      await ApiService.deleteFriendship(friendshipId);

      Get.snackbar('성공', '친구 관계를 삭제했습니다.');

      // 친구 목록 새로고침
      await loadFriendships();

      return true;
    } catch (e) {
      Get.snackbar('오류', e.toString());
      return false;
    }
  }

  /// 친구 검색
  List<Map<String, dynamic>> searchFriends(String query) {
    if (query.isEmpty) return friendships;

    return friendships.where((friendship) {
      final friend = friendship['friend'];
      final nickname = friend['nickname']?.toString().toLowerCase() ?? '';
      return nickname.contains(query.toLowerCase());
    }).toList();
  }

  /// 온도별 친구 필터링
  List<Map<String, dynamic>> getFriendsByTemperature(int minTemperature) {
    return friendships.where((friendship) {
      final temperature = friendship['temperature'] as int? ?? 0;
      return temperature >= minTemperature;
    }).toList();
  }

  /// 온라인 친구만 필터링
  List<Map<String, dynamic>> getOnlineFriends() {
    return friendships.where((friendship) {
      final friend = friendship['friend'];
      return friend['is_online'] == true;
    }).toList();
  }

  /// 친구 요청 개수
  int get pendingRequestCount => pendingRequests.length;

  /// 친구 수
  int get friendCount => friendships
      .where((friendship) => friendship['status'] == 'accepted')
      .length;
}
