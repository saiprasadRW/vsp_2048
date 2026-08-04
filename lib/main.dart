import 'package:flutter/material.dart';
import 'package:flutter_2048/game_logic.dart';
import 'package:flutter_2048/splash_screen.dart';
import 'package:flutter_2048/theme_controller.dart';
import 'package:flutter_2048/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedMode = await ThemeController.getSavedThemeMode();
  runApp(MyApp(controller: ThemeController(savedMode)));
}

class MyApp extends StatelessWidget {
  final ThemeController controller;
  const MyApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeMode>(
      valueListenable: controller,
      builder: (_, theme, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: '2048 Game',
          theme: controller.currentTheme,
          home: SplashContent(
            themeController: controller,
            destination: GamePage(themeController: controller),
          ),
        );
      },
    );
  }
}
