import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meal_buddy_app/presentation/screens/profile/profile_screen.dart';
import '../../../core/services/mock_data_service.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_thin_button.dart';
import '../../../app/theme.dart';
import '../../controllers/home_controller.dart';
import 'home_tab.dart';
import 'search_tab.dart';
import 'chat_tab.dart';
import 'settings_tab.dart';
//import 'test.dart';
import '../profile/settings_screen.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tabs = [
      const HomeTab(),
      const SearchTab(),
      const ChatTab(),
      const SettingsTab(),
    ];

    return Obx(() {
      return Scaffold(
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: tabs,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTab,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: '검색'),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline), label: '채팅'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
          ],
        ),
      );
    });
  }
}
