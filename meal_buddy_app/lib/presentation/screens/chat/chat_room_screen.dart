import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme.dart';
import '../../controllers/chat_controller.dart';
import '../../controllers/auth_controller.dart';
import 'chat_map.dart';

class ChatRoomScreen extends StatelessWidget {
  final int friendshipId;
  final String friendName;
  final String? friendProfileImage;

  const ChatRoomScreen({
    super.key,
    required this.friendshipId,
    required this.friendName,
    this.friendProfileImage,
  });

  @override
  Widget build(BuildContext context) {
    final chatController = Get.find<ChatController>();
    final authController = Get.find<AuthController>();
    final messageController = TextEditingController();
    final scrollController = ScrollController();

    // 채팅방 입장
    chatController.enterChatRoom(friendshipId);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppTheme.splash,
              backgroundImage: friendProfileImage != null
                  ? NetworkImage(friendProfileImage!)
                  : null,
              child: friendProfileImage == null
                  ? const Icon(Icons.person, size: 20, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friendName,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Obx(() => Text(
                        chatController.otherUserTyping ? '입력 중...' : '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.primaryColor,
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // 채팅방 설정 메뉴
              _showChatRoomMenu(context, friendshipId);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 메시지 목록
          Expanded(
            child: Obx(() {
              if (chatController.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (chatController.messages.isEmpty) {
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
                        '첫 메시지를 보내보세요!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }

              // 메시지 목록 표시
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (scrollController.hasClients) {
                  scrollController.animateTo(
                    scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              });

              return ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: chatController.messages.length,
                itemBuilder: (context, index) {
                  final message = chatController.messages[index];
                  final isMyMessage =
                      message['sender_id'] == authController.userData['id'];

                  return _buildMessageBubble(
                    message: message['content'] ?? '',
                    isMyMessage: isMyMessage,
                    time: message['created_at'] ?? '',
                    isRead: message['is_read'] ?? false,
                  );
                },
              );
            }),
          ),

          // 메시지 입력 영역
          SafeArea(
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // 이미지 첨부 버튼 (향후 구현)
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {
                      Get.to(ChatMapScreen(
                        friendshipId: friendshipId,
                        friendName: friendName,
                        friendProfileImage: friendProfileImage,
                      ));
                    },
                    color: AppTheme.primaryColor,
                  ),

                  // 텍스트 입력 필드
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: '메시지를 입력하세요',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      maxLines: null,
                      onChanged: (text) {
                        // 타이핑 상태 전송
                        chatController.sendTypingStatus(text.isNotEmpty);
                      },
                    ),
                  ),

                  const SizedBox(width: 8),

                  // 전송 버튼
                  CircleAvatar(
                    backgroundColor: AppTheme.primaryColor,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () async {
                        final text = messageController.text.trim();
                        if (text.isEmpty) return;

                        // 메시지 전송
                        await chatController.sendMessage(content: text);

                        // 입력 필드 초기화
                        messageController.clear();

                        // 타이핑 상태 해제
                        chatController.sendTypingStatus(false);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble({
    required String message,
    required bool isMyMessage,
    required String time,
    required bool isRead,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMyMessage) ...[
            // 상대방 프로필 사진
            CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.splash,
              backgroundImage: friendProfileImage != null
                  ? NetworkImage(friendProfileImage!)
                  : null,
              child: friendProfileImage == null
                  ? const Icon(Icons.person, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 8),
          ],

          // 메시지 내용
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isMyMessage ? AppTheme.primaryColor : Colors.grey[200],
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                message,
                style: TextStyle(
                  color: isMyMessage ? Colors.white : Colors.black87,
                  fontSize: 15,
                ),
              ),
            ),
          ),

          const SizedBox(width: 6),

          // 시간 & 읽음 표시
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatTime(time),
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
              if (isMyMessage)
                Text(
                  isRead ? '읽음' : '1',
                  style: TextStyle(
                    fontSize: 10,
                    color: isRead ? Colors.grey : AppTheme.primaryColor,
                    fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(String timestamp) {
    if (timestamp.isEmpty) return '';

    try {
      final DateTime dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();

      if (dateTime.day == now.day &&
          dateTime.month == now.month &&
          dateTime.year == now.year) {
        // 오늘: 시간만 표시
        return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      } else {
        // 다른 날: 날짜 표시
        return '${dateTime.month}/${dateTime.day}';
      }
    } catch (e) {
      return '';
    }
  }

  void _showChatRoomMenu(BuildContext context, int friendshipId) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('채팅방 나가기'),
              onTap: () {
                Navigator.pop(context);
                _confirmLeaveChatRoom(context, friendshipId);
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_off),
              title: const Text('알림 끄기'),
              onTap: () {
                Navigator.pop(context);
                Get.snackbar('알림', '알림 설정 기능은 곧 추가됩니다!');
              },
            ),
            ListTile(
              leading: const Icon(Icons.block),
              title: const Text('차단하기', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                Get.snackbar('알림', '차단 기능은 곧 추가됩니다!');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLeaveChatRoom(BuildContext context, int friendshipId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('채팅방 나가기'),
        content: const Text('채팅방을 나가시겠습니까?\n대화 내용은 유지됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Get.back();
              Get.snackbar('알림', '채팅방에서 나갔습니다.');
            },
            child: const Text('나가기', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
