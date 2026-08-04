import 'package:flutter/material.dart';
import 'package:flutter_2048/dotted_text.dart';
import 'package:flutter_2048/game_theme_extension.dart';

class GameTile extends StatelessWidget {
  final int value;
  final int index;
  final Color Function(int) getTileColor;

  const GameTile({
    super.key,
    required this.value,
    required this.index,
    required this.getTileColor,
  });

  @override
  Widget build(BuildContext context) {
    final tileColor = getTileColor(value);
    final themeExtension = Theme.of(context).extension<GameThemeExtension>();
    final customTextColor = themeExtension?.tileTextColor[value];
    final textColor = customTextColor ??
        (tileColor.computeLuminance() > 0.3
            ? Theme.of(context).primaryColorDark
            : Theme.of(context).primaryColorLight);
    final bool hasDotField = themeExtension?.hasDotField ?? false;
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(8),
      color: tileColor,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: value > 250
              ? [
                  BoxShadow(
                    color: tileColor.withOpacity(0.7),
                    blurRadius: 20,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        alignment: Alignment.center,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: animation,
            child: child,
          ),
          child: value != 0
              ? hasDotField
                  ? DottedText(
                      text: '$value',
                      key: ValueKey<int>(value + index),
                      style: TextStyle(
                        color: textColor,
                        fontSize: value >= 1000
                            ? 14
                            : value >= 100
                                ? 18
                                : 24,
                        fontWeight: FontWeight.w600,
                      ),
                      dotRadius: value >= 1000 ? 0.6 : value >= 100 ? 0.8 : 1.0,
                    )
                  : Text(
                      '$value',
                      key: ValueKey<int>(value + index),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: textColor,
                            fontSize: value >= 1000
                                ? 14
                                : value >= 100
                                    ? 18
                                    : null,
                          ),
                    )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
