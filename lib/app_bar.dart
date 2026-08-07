import 'package:flutter/material.dart';
import 'package:flutter_2048/dot_field.dart';
import 'package:flutter_2048/game_theme_extension.dart';
import 'package:flutter_2048/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_page.dart'; // Adjust this import based on your project structure

class GameAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onRestart;
  final ThemeController themeController;

  const GameAppBar({
    super.key,
    required this.title,
    required this.onRestart,
    required this.themeController,
  });

  @override
  Widget build(BuildContext context) {
    final themeExtension = Theme.of(context).extension<GameThemeExtension>();
    final bool hasDotField = themeExtension?.hasDotField ?? false;

    final appBar = AppBar(
      automaticallyImplyLeading: false,
      title: Text(title),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SettingsPage(controller: themeController),
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.restart_alt_rounded),
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('board');
            await prefs.remove('gameOver');
            await prefs.remove('score');
            onRestart(); // Call restart callback from parent
          },
        ),
      ],
    );

    if (!hasDotField) return appBar;

    return Stack(
      children: [
        Positioned.fill(
          child: DotField(
            sparkle: true,
            glow: true,
            gradientFrom:
                themeExtension?.dotFieldGradientFrom ??
                    const Color.fromRGBO(30, 100, 220, 0.35),
            gradientTo:
                themeExtension?.dotFieldGradientTo ??
                    const Color.fromRGBO(100, 160, 230, 0.25),
          ),
        ),
        appBar,
      ],
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(themeController.currentTheme.appBarTheme.toolbarHeight ??
          kToolbarHeight);
}
