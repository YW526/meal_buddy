import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes.dart';
import '../../../app/theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 정보'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: 프로필 수정
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 프로필 이미지
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppTheme.primaryColor,
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '김밥친구',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  '🍚 한식',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // 통계 정보
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('밥친구', '5명'),
                  _buildStatItem('평균 온도', '75도'),
                  _buildStatItem('총 밥 횟수', '12회'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 메뉴 항목들
          _buildMenuItem(
            icon: Icons.chat,
            title: '채팅 목록',
            onTap: () => Get.toNamed(AppRoutes.chatList),
          ),
          _buildMenuItem(
            icon: Icons.location_on,
            title: '내 위치',
            onTap: () {
              // TODO: 위치 설정
            },
          ),
          _buildMenuItem(
            icon: Icons.notifications,
            title: '알림 설정',
            onTap: () => Get.toNamed(AppRoutes.settings),
          ),
          _buildMenuItem(
            icon: Icons.help,
            title: '도움말',
            onTap: () {
              // TODO: 도움말
            },
          ),
          _buildMenuItem(
            icon: Icons.logout,
            title: '로그아웃',
            onTap: () {
              // TODO: 로그아웃
              Get.offAllNamed(AppRoutes.login);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryColor),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
