import 'package:flutter/material.dart';

class ScoreBoard extends StatelessWidget {
  final int score;
  final int highScore;

  const ScoreBoard({
    super.key,
    required this.score,
    required this.highScore,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _ScoreCard(value: score, label: 'Score'),
        SizedBox(width: screenWidth * 0.04),
        _ScoreCard(value: highScore, label: 'Best Score'),
      ],
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final int value;
  final String label;

  const _ScoreCard({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Expanded(
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        child: Container(
          padding: EdgeInsets.all(screenWidth * 0.02),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(screenWidth * 0.03),
            color: Theme.of(context).cardColor,
          ),
          child: Column(
            children: [
              Text(label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall),
              Text('$value',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
