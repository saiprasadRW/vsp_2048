import 'package:flutter/material.dart';
import 'package:flutter_2048/game_theme_extension.dart';

class GameOverOverlay extends StatelessWidget {
  final bool visible;

  const GameOverOverlay({super.key, required this.visible});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 800),
      opacity: visible ? 1.0 : 0.0,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context)
            .extension<GameThemeExtension>()!
            .gameOverBackgroundColor,
        padding: EdgeInsets.fromLTRB(0, 0, 0, screenHeight * 0.12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Game Over',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Theme.of(context).primaryColorLight,
                    )),
            SizedBox(height: screenHeight * 0.02),
            Text('Press Restart button to start new game',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).primaryColorLight,
                    )),
          ],
        ),
      ),
    );
  }
}
