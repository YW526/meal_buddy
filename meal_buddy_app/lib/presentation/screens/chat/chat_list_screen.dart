import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes.dart';
import '../../../app/theme.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('채팅'),
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: AppTheme.primaryColor,
              child: Text(
                '김${index + 1}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text('김밥친구${index + 1}'),
            subtitle: Text('안녕하세요! 밥 먹을까요?'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('5분 전'),
                if (index % 2 == 0)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      '1',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
              ],
            ),
            onTap: () {
              Get.toNamed(AppRoutes.chat);
            },
          );
        },
      ),
    );
  }
}
