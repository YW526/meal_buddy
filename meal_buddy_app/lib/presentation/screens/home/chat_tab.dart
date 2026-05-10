import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme.dart';
import '../../controllers/friendship_controller.dart';
import '../../controllers/auth_controller.dart';
import '../chat/chat_room_screen.dart';

class ChatTab extends StatelessWidget {
  const ChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    final friendshipController = Get.find<FriendshipController>();
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Image.asset('assets/images/boblogo.png'),
        ),
        title: const Text('채팅'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              friendshipController.loadFriendships();
            },
            tooltip: '새로고침',
          ),
        ],
      ),
      body: Obx(() {
        if (friendshipController.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // 디버깅: 전체 friendships 확인
        print(
            '🔍 [ChatTab] 전체 friendships: ${friendshipController.friendships.length}개');
        for (var f in friendshipController.friendships) {
          print(
              '  - ID: ${f['id']}, Status: ${f['status']}, User: ${f['user']?['nickname']}, Friend: ${f['friend']?['nickname']}');
        }

        // 모든 friendships 표시 (accepted + pending)
        final allFriendships = friendshipController.friendships
            .map((f) => Map<String, dynamic>.from(f))
            .toList();

        // accepted와 pending 분리
        final acceptedFriends = allFriendships
            .where((f) =>
                f['status'] == 'accepted' ||
                f['status'].toString() == 'accepted')
            .toList();

        // pending 요청 분리 (받은 요청 + 보낸 요청)
        final currentUserId = authController.userData['id'];
        final receivedRequests = allFriendships.where((f) {
          final status = f['status'];
          final isPending =
              status == 'pending' || status.toString() == 'pending';
          // 내가 받은 요청 (friend_id가 현재 사용자)
          final isReceivedRequest = f['friend_id'] == currentUserId;
          return isPending && isReceivedRequest;
        }).toList();

        final sentRequests = allFriendships.where((f) {
          final status = f['status'];
          final isPending =
              status == 'pending' || status.toString() == 'pending';
          // 내가 보낸 요청 (user_id가 현재 사용자)
          final isSentRequest = f['user_id'] == currentUserId;
          return isPending && isSentRequest;
        }).toList();

        print('🔍 [ChatTab] Accepted friends: ${acceptedFriends.length}개');
        print('🔍 [ChatTab] Received requests: ${receivedRequests.length}개');
        print('🔍 [ChatTab] Sent requests: ${sentRequests.length}개');

        if (acceptedFriends.isEmpty &&
            receivedRequests.isEmpty &&
            sentRequests.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  '아직 채팅할 친구가 없습니다',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '밥친구를 신청하고 채팅을 시작해보세요!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: receivedRequests.length +
              sentRequests.length +
              acceptedFriends.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            // 받은 요청을 먼저 표시
            if (index < receivedRequests.length) {
              final friendship = receivedRequests[index];
              final friend =
                  Map<String, dynamic>.from(friendship['user']); // 요청을 보낸 사람

              return _buildPendingRequestItem(
                context,
                friendship,
                friend,
                friendshipController,
                isReceived: true,
                currentUserId: currentUserId,
              );
            }
            // 보낸 요청 표시
            else if (index < receivedRequests.length + sentRequests.length) {
              final friendship = sentRequests[index - receivedRequests.length];
              final friend =
                  Map<String, dynamic>.from(friendship['friend']); // 요청을 받은 사람

              return _buildPendingRequestItem(
                context,
                friendship,
                friend,
                friendshipController,
                isReceived: false,
                currentUserId: currentUserId,
              );
            }
            // accepted 친구들 표시
            else {
              final friendship = acceptedFriends[
                  index - receivedRequests.length - sentRequests.length];
              final isUserInitiator = friendship['user_id'] == currentUserId;
              final friend = Map<String, dynamic>.from(
                  isUserInitiator ? friendship['friend'] : friendship['user']);

              return _buildChatListItem(
                context,
                friendship,
                friend,
              );
            }
          },
        );
      }),
    );
  }

  Widget _buildChatListItem(
    BuildContext context,
    Map<String, dynamic> friendship,
    Map<String, dynamic> friend,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: AppTheme.splash,
        backgroundImage: friend['profile_image_url'] != null
            ? NetworkImage(friend['profile_image_url'])
            : null,
        child: friend['profile_image_url'] == null
            ? const Icon(Icons.person, size: 32, color: Colors.white)
            : null,
      ),
      title: Row(
        children: [
          Text(
            friend['nickname'] ?? '알 수 없음',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          // 온라인 상태 표시
          if (friend['is_online'] == true)
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
      subtitle: Text(
        '마지막 메시지가 여기에 표시됩니다',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '방금',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          // 읽지 않은 메시지 뱃지
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: AppTheme.primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Text(
              '3',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        // 채팅방으로 이동
        Get.to(
          () => ChatRoomScreen(
            friendshipId: friendship['id'],
            friendName: friend['nickname'] ?? '알 수 없음',
            friendProfileImage: friend['profile_image_url'],
          ),
        );
      },
    );
  }

  Widget _buildPendingRequestItem(
    BuildContext context,
    Map<String, dynamic> friendship,
    Map<String, dynamic> friend,
    FriendshipController friendshipController, {
    required bool isReceived,
    required int currentUserId,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isReceived ? Colors.orange[50] : Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isReceived ? Colors.orange[200]! : Colors.blue[200]!,
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: AppTheme.splash,
          backgroundImage: friend['profile_image_url'] != null
              ? NetworkImage(friend['profile_image_url'])
              : null,
          child: friend['profile_image_url'] == null
              ? const Icon(Icons.person, size: 32, color: Colors.white)
              : null,
        ),
        title: Row(
          children: [
            Text(
              friend['nickname'] ?? '알 수 없음',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isReceived ? Colors.orange[200] : Colors.blue[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isReceived ? '요청' : '대기',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isReceived ? Colors.orange[900] : Colors.blue[900],
                ),
              ),
            ),
          ],
        ),
        subtitle: Text(
          isReceived ? '친구 요청이 도착했습니다' : '친구 요청을 보냈습니다',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        trailing: isReceived
            ? // 받은 요청: 수락/거절 버튼
            Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 55,
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () async {
                        final success = await friendshipController
                            .acceptFriendRequest(friendship['id']);
                        if (success) {
                          Get.snackbar(
                              '성공', '${friend['nickname']}님과 친구가 되었습니다.');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        '수락',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  SizedBox(
                    width: 55,
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () async {
                        final success = await friendshipController
                            .rejectFriendRequest(friendship['id']);
                        if (success) {
                          Get.snackbar(
                              '알림', '${friend['nickname']}님의 친구 요청을 거절했습니다.');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        '거절',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : // 보낸 요청: 취소 버튼
            SizedBox(
                width: 60,
                height: 36,
                child: ElevatedButton(
                  onPressed: () async {
                    final success = await friendshipController
                        .deleteFriendship(friendship['id']);
                    if (success) {
                      Get.snackbar(
                          '알림', '${friend['nickname']}님에게 보낸 친구 요청을 취소했습니다.');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black,
                    elevation: 0,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    '취소',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
