import 'package:flutter/material.dart';
import 'package:flutter_2048/game_logic.dart';
import 'package:flutter_2048/onboarding_page.dart';
import 'package:flutter_2048/splash_screen.dart';
import 'package:flutter_2048/theme_controller.dart';
import 'package:flutter_2048/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedMode = await ThemeController.getSavedThemeMode();
  final prefs = await SharedPreferences.getInstance();
  final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
  runApp(MyApp(
    controller: ThemeController(savedMode),
    showOnboarding: !hasSeenOnboarding,
  ));
}

class MyApp extends StatelessWidget {
  final ThemeController controller;
  final bool showOnboarding;
  const MyApp({super.key, required this.controller, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeMode>(
      valueListenable: controller,
      builder: (_, theme, __) {
        final destination = showOnboarding
            ? OnboardingPage(themeController: controller)
            : GamePage(themeController: controller);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: '2048 Game',
          theme: controller.currentTheme,
          home: SplashContent(
            themeController: controller,
            destination: destination,
          ),
        );
      },
    );
  }
}
