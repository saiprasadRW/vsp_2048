import 'package:flutter/material.dart';
import 'package:flutter_2048/dot_field.dart';
import 'package:flutter_2048/game_theme_extension.dart';
import 'package:flutter_2048/matrix_rain.dart';
import 'package:flutter_2048/theme_controller.dart';
import 'package:flutter_2048/themes.dart';
import 'package:google_fonts/google_fonts.dart';

class _ThemePreview {
  final Color background;
  final Color cardBg;
  final Color textColor;
  final List<Color> tileColors;
  final TextStyle nameStyle;

  const _ThemePreview({
    required this.background,
    required this.cardBg,
    required this.textColor,
    required this.tileColors,
    required this.nameStyle,
  });
}

final Map<AppThemeMode, _ThemePreview> _previews = {
  AppThemeMode.light: const _ThemePreview(
    background: Colors.white,
    cardBg: Color(0xFF808080),
    textColor: Colors.black,
    tileColors: [
      Color(0xFF808080),
      Color(0xFF1C1C1C),
      Color(0xFF333333),
      Color(0xFF4F4F4F),
    ],
    nameStyle: TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.bold,
      fontFamily: 'Inter',
    ),
  ),
  AppThemeMode.dark: const _ThemePreview(
    background: Colors.black,
    cardBg: Color(0xFF808080),
    textColor: Colors.white,
    tileColors: [
      Color(0xFF808080),
      Color(0xFF1C1C1C),
      Color(0xFF333333),
      Color(0xFF4F4F4F),
    ],
    nameStyle: TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.bold,
      fontFamily: 'Inter',
    ),
  ),
  AppThemeMode.gothicWhite: const _ThemePreview(
    background: Colors.white,
    cardBg: Color.fromARGB(255, 66, 36, 173),
    textColor: Colors.black,
    tileColors: [
      Color(0xFF2B2B2B),
      Color(0xFFFF6B6B),
      Color(0xFFFFA94D),
      Color(0xFFFFD43B),
    ],
    nameStyle: TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontFamily: 'Special Gothic Expanded One',
    ),
  ),
  AppThemeMode.gothicDark: const _ThemePreview(
    background: Colors.black,
    cardBg: Color.fromARGB(255, 66, 36, 173),
    textColor: Colors.white,
    tileColors: [
      Color(0xFF2B2B2B),
      Color(0xFFFF6B6B),
      Color(0xFFFFA94D),
      Color(0xFFFFD43B),
    ],
    nameStyle: TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontFamily: 'Special Gothic Expanded One',
    ),
  ),
  AppThemeMode.blush: const _ThemePreview(
    background: Color(0xFFFFE6E8),
    cardBg: Color(0xFFF8C8DC),
    textColor: Color(0xFFB23A48),
    tileColors: [
      Color(0xFFFFE6E8),
      Color(0xFFFFC1CC),
      Color(0xFFFFA3B5),
      Color(0xFFFF7F9C),
    ],
    nameStyle: TextStyle(
      color: Color(0xFFB23A48),
      fontSize: 14,
      fontWeight: FontWeight.bold,
      fontFamily: 'DM Serif Display',
    ),
  ),
  AppThemeMode.redDragon: const _ThemePreview(
    background: Color(0xFF1A0000),
    cardBg: Color(0xFF2B2B2B),
    textColor: Color(0xFFD4AF37),
    tileColors: [
      Color(0xFF6A0000),
      Color(0xFF8B1A1A),
      Color(0xFFA83232),
      Color(0xFFCC5C2C),
    ],
    nameStyle: TextStyle(
      color: Color(0xFFD4AF37),
      fontSize: 14,
      fontWeight: FontWeight.bold,
      fontFamily: 'Wonton',
    ),
  ),
  AppThemeMode.starlight: _ThemePreview(
    background: const Color(0xFF0D1B2A),
    cardBg: const Color(0xFF1B2838),
    textColor: const Color(0xFFFFD700),
    tileColors: const [
      Color(0xFF08121F),
      Color(0xFF2D8CFF),
      Color(0xFFE53935),
      Color(0xFFFFD54F),
    ],
    nameStyle: GoogleFonts.michroma(
      color: const Color(0xFFFFD700),
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
  ),
  AppThemeMode.devMode: _ThemePreview(
    background: const Color(0xFF0D1117),
    cardBg: const Color(0xFF161B22),
    textColor: const Color(0xFF39D353),
    tileColors: const [
      Color(0xFF0D1117),
      Color(0xFF1B4332),
      Color(0xFF24543D),
      Color(0xFF2D6A4F),
    ],
    nameStyle: GoogleFonts.jetBrainsMono(
      color: const Color(0xFF58A6FF),
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
  ),
};

class SettingsPage extends StatelessWidget {
  final ThemeController controller;

  const SettingsPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final themeExtension = Theme.of(context).extension<GameThemeExtension>();
    final bool isImage = themeExtension?.isImage ?? false;
    final String? imagePath = themeExtension?.imagePath;
    final bool hasDotField = themeExtension?.hasDotField ?? false;
    final bool hasMatrixBg = themeExtension?.hasMatrixBg ?? false;
    final toolbarHeight =
        Theme.of(context).appBarTheme.toolbarHeight ?? kToolbarHeight;
    final appBarHeight = MediaQuery.of(context).padding.top + toolbarHeight;

    final content = Padding(
      padding: (hasDotField || hasMatrixBg)
          ? EdgeInsets.only(top: appBarHeight)
          : EdgeInsets.zero,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenW = constraints.maxWidth;
          final gridPadding = screenW * 0.03;
          final gridSpacing = screenW * 0.025;
          final cardWidth = (screenW - gridPadding * 2 - gridSpacing) / 2;
          final tilePadding = cardWidth * 0.07;
          final tileGap = cardWidth * 0.04;
          final tileSize = (cardWidth - tilePadding * 2 - tileGap) / 2;
          final borderRadius = cardWidth * 0.1;
          final tileRadius = tileSize * 0.15;
          final nameFontSize = cardWidth * 0.085;

          final cardCount = AppThemeMode.values.length;
          final rows = <Widget>[];
          for (var i = 0; i < cardCount; i += 2) {
            final left = AppThemeMode.values[i];
            final right = i + 1 < cardCount ? AppThemeMode.values[i + 1] : null;
            rows.add(Padding(
              padding: EdgeInsets.symmetric(horizontal: gridPadding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildCard(
                      left, controller, cardWidth, tilePadding, tileGap,
                      tileSize, borderRadius, tileRadius, nameFontSize,
                    ),
                  ),
                  SizedBox(width: gridSpacing),
                  Expanded(
                    child: right != null
                        ? _buildCard(
                            right, controller, cardWidth, tilePadding, tileGap,
                            tileSize, borderRadius, tileRadius, nameFontSize,
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ));
            if (i + 2 < cardCount) {
              rows.add(SizedBox(height: gridSpacing));
            }
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: gridPadding),
            child: Column(children: rows),
          );
        },
      ),
    );

    final bodyContent = isImage && imagePath != null
        ? Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  opacity: const AlwaysStoppedAnimation(0.5),
                ),
              ),
              content,
            ],
          )
        : hasMatrixBg
            ? Stack(
                children: [
                  Positioned.fill(
                    child: MatrixRain(
                      baseColor: const Color(0xFF39D353),
                    ),
                  ),
                  content,
                ],
              )
            : hasDotField
                ? Stack(
                    children: [
                      Positioned.fill(
                        child: DotField(
                          sparkle: true,
                          glow: true,
                          gradientFrom: themeExtension?.dotFieldGradientFrom ??
                              const Color.fromRGBO(30, 100, 220, 0.35),
                          gradientTo: themeExtension?.dotFieldGradientTo ??
                              const Color.fromRGBO(100, 160, 230, 0.25),
                        ),
                      ),
                      content,
                    ],
                  )
                : content;

    return Scaffold(
      extendBodyBehindAppBar: hasDotField || hasMatrixBg,
      appBar: AppBar(
        backgroundColor: (hasDotField || hasMatrixBg)
            ? Colors.transparent
            : Theme.of(context).appBarTheme.backgroundColor,
        title: const Text("Select Theme"),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: bodyContent,
    );
  }

  Widget _buildCard(
    AppThemeMode mode,
    ThemeController controller,
    double cardWidth,
    double tilePadding,
    double tileGap,
    double tileSize,
    double borderRadius,
    double tileRadius,
    double nameFontSize,
  ) {
    final preview = _previews[mode]!;
    final isSelected = controller.value == mode;
    final displayName =
        '${mode.name[0].toUpperCase()}${mode.name.substring(1)}';

    return GestureDetector(
      onTap: () => controller.setThemeMode(mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: preview.cardBg,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: isSelected
                ? preview.textColor
                : preview.textColor.withOpacity(0.15),
            width: isSelected ? cardWidth * 0.025 : cardWidth * 0.005,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: preview.textColor.withOpacity(0.35),
                    blurRadius: cardWidth * 0.1,
                    spreadRadius: cardWidth * 0.01,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                  tilePadding, tilePadding, tilePadding, tileGap * 0.8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child:
                              _buildTile(preview.tileColors[0], tileRadius)),
                      SizedBox(width: tileGap),
                      Expanded(
                          child:
                              _buildTile(preview.tileColors[1], tileRadius)),
                    ],
                  ),
                  SizedBox(height: tileGap),
                  Row(
                    children: [
                      Expanded(
                          child:
                              _buildTile(preview.tileColors[2], tileRadius)),
                      SizedBox(width: tileGap),
                      Expanded(
                          child:
                              _buildTile(preview.tileColors[3], tileRadius)),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: tileGap),
              child: Text(
                displayName,
                style: preview.nameStyle.copyWith(fontSize: nameFontSize),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: tileGap * 0.8),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(Color color, double radius) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
