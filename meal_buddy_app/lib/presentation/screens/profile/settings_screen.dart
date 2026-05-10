import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _locationSharingEnabled = true;
  bool _temperatureAlertsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_outlined),
        ),
      ),
      body: ListView(
        children: [
          // 알림 설정
          _buildSectionHeader('알림 설정'),
          SwitchListTile(
            title: const Text('푸시 알림'),
            subtitle: const Text('새 메시지 및 밥친구 신청 알림'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('위치 공유'),
            subtitle: const Text('주변 밥친구 검색을 위한 위치 공유'),
            value: _locationSharingEnabled,
            onChanged: (value) {
              setState(() {
                _locationSharingEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('온도 알림'),
            subtitle: const Text('밥친구 온도 변화 알림'),
            value: _temperatureAlertsEnabled,
            onChanged: (value) {
              setState(() {
                _temperatureAlertsEnabled = value;
              });
            },
          ),

          const Divider(),

          // 앱 정보
          _buildSectionHeader('앱 정보'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('버전'),
            subtitle: const Text('1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('이용약관'),
            onTap: () {
              // TODO: 이용약관 보기
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('개인정보처리방침'),
            onTap: () {
              // TODO: 개인정보처리방침 보기
            },
          ),

          const Divider(),

          // 계정 관리
          _buildSectionHeader('계정 관리'),
          ListTile(
            leading:
                const Icon(Icons.logout, color: AppTheme.primaryTextColor),
            title: const Text('로그아웃'),
            //subtitle: const Text('모든 데이터가 영구적으로 삭제됩니다'),
            onTap: () {
              Get.toNamed('/login');
              //_showDeleteAccountDialog();
            },
          ),
          ListTile(
            leading:
                const Icon(Icons.delete_forever, color: AppTheme.errorColor),
            title: const Text('계정 삭제'),
            subtitle: const Text('모든 데이터가 영구적으로 삭제됩니다'),
            onTap: () {
              _showDeleteAccountDialog();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('계정 삭제'),
        content: const Text('정말로 계정을 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: 계정 삭제 로직
              Get.offAllNamed('/login');
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.errorColor,
            ),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}
