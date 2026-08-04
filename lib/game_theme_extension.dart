import 'package:flutter/material.dart';

@immutable
class GameThemeExtension extends ThemeExtension<GameThemeExtension> {
  final Map<int, Color> tileColors;
  final Map<int, Color> tileTextColor;
  final Color defaultTileColor;
  final Color gameOverBackgroundColor;
  final bool isImage;
  final String? imagePath;
  final bool hasDotField;
  final Color dotFieldGradientFrom;
  final Color dotFieldGradientTo;
  final bool hasMatrixBg;

  const GameThemeExtension({
    required this.tileColors,
    this.tileTextColor = const {},
    required this.defaultTileColor,
    required this.gameOverBackgroundColor,
    this.isImage = false,
    this.imagePath,
    this.hasDotField = false,
    this.dotFieldGradientFrom = const Color.fromRGBO(30, 100, 220, 0.35),
    this.dotFieldGradientTo = const Color.fromRGBO(100, 160, 230, 0.25),
    this.hasMatrixBg = false,
  });

  @override
  GameThemeExtension copyWith(
      {Map<int, Color>? tileColors,
      Map<int, Color>? tileTextColor,
      Color? defaultTileColor,
      Color? gameOverBackgroundColor,
      bool? isImage,
      String? imagePath,
      bool? hasDotField,
      Color? dotFieldGradientFrom,
      Color? dotFieldGradientTo,
      bool? hasMatrixBg}) {
    return GameThemeExtension(
        tileColors: tileColors ?? this.tileColors,
        tileTextColor: tileTextColor ?? this.tileTextColor,
        defaultTileColor: defaultTileColor ?? this.defaultTileColor,
        gameOverBackgroundColor:
            gameOverBackgroundColor ?? this.gameOverBackgroundColor,
        isImage: isImage ?? this.isImage,
        imagePath: imagePath ?? this.imagePath,
        hasDotField: hasDotField ?? this.hasDotField,
        dotFieldGradientFrom: dotFieldGradientFrom ?? this.dotFieldGradientFrom,
        dotFieldGradientTo: dotFieldGradientTo ?? this.dotFieldGradientTo,
        hasMatrixBg: hasMatrixBg ?? this.hasMatrixBg);
  }

  @override
  GameThemeExtension lerp(ThemeExtension<GameThemeExtension>? other, double t) {
    if (other is! GameThemeExtension) return this;
    return GameThemeExtension(
        tileColors: other.tileColors,
        tileTextColor: other.tileTextColor,
        defaultTileColor:
            Color.lerp(defaultTileColor, other.defaultTileColor, t)!,
        gameOverBackgroundColor: Color.lerp(
            gameOverBackgroundColor, other.gameOverBackgroundColor, t)!,
        isImage: other.isImage,
        imagePath: other.imagePath,
        hasDotField: other.hasDotField,
        dotFieldGradientFrom:
            Color.lerp(dotFieldGradientFrom, other.dotFieldGradientFrom, t)!,
        dotFieldGradientTo:
            Color.lerp(dotFieldGradientTo, other.dotFieldGradientTo, t)!,
        hasMatrixBg: other.hasMatrixBg);
  }
}
