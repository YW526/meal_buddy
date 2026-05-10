import 'package:get/get.dart';

import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/signup_screen.dart';
import '../presentation/screens/auth/password_screen.dart';

import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/home/create_text.dart';

import '../presentation/screens/home/search_tab.dart';
import '../presentation/screens/home/friend_list.dart';

import '../presentation/screens/chat/chat_list_screen.dart';
import '../presentation/screens/chat/chat_screen.dart';
//import '../presentation/screens/chat/chat_map.dart';

import '../presentation/screens/profile/profile_screen.dart';
import '../presentation/screens/home/settings_tab.dart';
import '../presentation/screens/profile/settings_screen.dart';
import '../presentation/screens/profile/setting_edit.dart';

import '../presentation/screens/common/splash_screen.dart';

import '../presentation/screens/home/food/food_screen.dart';
import '../presentation/screens/home/food/food_sushi.dart';
import '../presentation/screens/home/food/food_pizza.dart';
import '../presentation/screens/home/food/food_chicken.dart';
import '../presentation/screens/home/food/food_burger.dart';

class AppRoutes {
  // 라우트 이름 상수
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String password = '/password';
  static const String home = '/home';
  static const String create = '/create';
  static const String search = '/search';
  static const String friendList = '/friend-list';
  static const String chatList = '/chat-list';
  static const String chat = '/chat';
  static const String chatMap = '/chat-map';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String settingsEdit = '/settings-edit';
  static const String setProfile = '/setProfile';
  static const String food = '/food';
  static const String foodSushi = '/food-sushi';
  static const String foodPizza = '/food-pizza';
  static const String foodChicken = '/food-chicken';
  static const String foodBurger = '/food-burger';
  // 라우트 페이지 목록
  static final List<GetPage> pages = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: signup,
      page: () => const SignupScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: password,
      page: () => const PasswordScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: create,
      page: () => const Create(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: search,
      page: () => const SearchTab(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: friendList,
      page: () => const FriendList(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: chatList,
      page: () => const ChatListScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: chat,
      page: () => const ChatScreen(),
      transition: Transition.fadeIn,
    ),
    /*GetPage(
      name: chatMap,
      page: () => ChatMapScreen(),
      transition: Transition.fadeIn,
    ),*/
    GetPage(
      name: profile,
      page: () => const ProfileScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: settings,
      page: () => const SettingsScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: settingsEdit,
      page: () => const SettingEditScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: setProfile,
      page: () => const SettingsTab(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: food,
      page: () => const FoodScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: foodSushi,
      page: () => const FoodSushiScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: foodPizza,
      page: () => const FoodPizzaScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: foodChicken,
      page: () => const FoodChickenScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: foodBurger,
      page: () => const FoodBurgerScreen(),
      transition: Transition.fadeIn,
    ),
  ];
}
