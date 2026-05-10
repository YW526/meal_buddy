import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'app/app.dart';
import 'core/services/api_service.dart';
import 'presentation/controllers/home_controller.dart';
import 'presentation/controllers/auth_controller.dart';
import 'presentation/controllers/friendship_controller.dart';
import 'presentation/controllers/chat_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화 (임시로 비활성화)
  // await Firebase.initializeApp();

  // API 서비스 초기화
  await ApiService.initialize();

  // AuthController를 먼저 초기화 (로그인 상태 확인)
  Get.put(AuthController());

  // FriendshipController 초기화
  Get.put(FriendshipController());

  // ChatController 초기화
  Get.put(ChatController());

  // HomeController는 나중에 초기화 (AuthController가 준비된 후)
  Get.put(HomeController());

  runApp(const MealBuddyApp());
}
