import 'package:flutter/material.dart';

class GameWinOverlay extends StatelessWidget {
  final bool visible;

  const GameWinOverlay({super.key, required this.visible});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 800),
      opacity: visible ? 1.0 : 0.0,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.fromLTRB(0, 0, 0, screenHeight * 0.12),
        decoration: BoxDecoration(
          color: Colors.amber.withOpacity(0.75),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🔥You Win!🔥',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Theme.of(context).primaryColorDark,
                    )),
            SizedBox(height: screenHeight * 0.02),
            Text('Press Restart button to start new game',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).primaryColorDark,
                    )),
          ],
        ),
      ),
    );
  }
}
