import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes.dart';
import 'theme.dart';

class MealBuddyApp extends StatelessWidget {
  const MealBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '밥친구',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.pages,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fadeIn,
    );
  }
}
