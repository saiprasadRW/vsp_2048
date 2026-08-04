import 'package:flutter/material.dart';
import 'package:flutter_2048/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ValueNotifier<AppThemeMode> {
  ThemeController(super.value);

  Future<void> setThemeMode(AppThemeMode mode) async {
    value = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', mode.name);
  }

  static Future<AppThemeMode> getSavedThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeStr = prefs.getString('theme_mode') ?? 'light';
    return AppThemeMode.values.firstWhere((e) => e.name == themeStr,
        orElse: () => AppThemeMode.light);
  }

  ThemeData get currentTheme {
    switch (value) {
      case AppThemeMode.dark:
        return AppThemes.dark;
      case AppThemeMode.light:
        return AppThemes.light;
      case AppThemeMode.gothicWhite:
        return AppThemes.gothicWhite;
      case AppThemeMode.gothicDark:
        return AppThemes.gothicDark;
      case AppThemeMode.blush:
        return AppThemes.blush;
      case AppThemeMode.redDragon:
        return AppThemes.redDragon;
      case AppThemeMode.starlight:
        return AppThemes.starlight;
      case AppThemeMode.devMode:
        return AppThemes.devMode;
      default:
        return AppThemes.light;
    }
  }
}
