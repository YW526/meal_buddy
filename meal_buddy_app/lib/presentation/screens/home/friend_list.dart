import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme.dart';
import '../../widgets/common/custom_button.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/friendship_controller.dart';

class FriendList extends GetView<HomeController> {
  const FriendList({super.key});

  @override
  Widget build(BuildContext context) {
    final friendshipController = Get.find<FriendshipController>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_outlined),
        ),
        title: const Text("친구 신청 목록"),
      ),
      body: Obx(() {
        final pendingRequests = friendshipController.pendingRequests;

        if (pendingRequests.isEmpty) {
          return const Center(
            child: Text(
              '신청받은 친구가 없습니다.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: pendingRequests.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final request = pendingRequests[index];
            final friend = request['friend'];

            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppTheme.splash,
                    backgroundImage: friend['profile_image_url'] != null
                        ? NetworkImage(friend['profile_image_url'])
                        : null,
                    child: friend['profile_image_url'] == null
                        ? const Icon(Icons.person, size: 28, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          friend['nickname'] ?? '친구',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${friend['age']}세 | ${friend['gender']}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      // 수락 버튼
                      CustomButton(
                        onPressed: () async {
                          final success = await friendshipController.acceptFriendRequest(request['id']);
                          if (success) {
                            Get.snackbar('성공', '${friend['nickname']}님과 친구가 되었습니다.');
                          }
                        },
                        text: '수락',
                        width: 70,
                        height: 36,
                        //fontSize: 14,
                      ),
                      const SizedBox(width: 8),
                      // 거절 버튼
                      CustomButton(
                        onPressed: () async {
                          final success = await friendshipController.rejectFriendRequest(request['id']);
                          if (success) {
                            Get.snackbar('알림', '${friend['nickname']}님의 친구 요청을 거절했습니다.');
                          }
                        },
                        text: '거절',
                        width: 70,
                        height: 36,
                        //fontSize: 14,
                        backgroundColor: Colors.grey[300],
                        textColor: Colors.black,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}