import 'dart:math';
import 'package:flutter/material.dart';

class MatrixRain extends StatefulWidget {
  final Color baseColor;

  const MatrixRain({super.key, this.baseColor = const Color(0xFF39D353)});

  @override
  State<MatrixRain> createState() => _MatrixRainState();
}

class _MatrixRainState extends State<MatrixRain>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_ColumnData> _columns = [];
  final Random _random = Random();

  static const _chars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#\$%&*';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    )..addListener(_tick);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_columns.isEmpty) {
      _initColumns();
    }
    _controller.repeat();
  }

  void _initColumns() {
    final screenW = MediaQuery.of(context).size.width;
    final colWidth = screenW / 20;
    final colCount = (screenW / colWidth).ceil();

    for (var i = 0; i < colCount; i++) {
      _columns.add(_ColumnData(
        x: i * colWidth,
        speed: 0.3 + _random.nextDouble() * 0.7,
        chars: _generateChars(),
        y: -_random.nextDouble() * 400,
      ));
    }
  }

  List<String> _generateChars() {
    return List.generate(
        15 + _random.nextInt(10), (_) => _chars[_random.nextInt(_chars.length)]);
  }

  void _tick() {
    if (!mounted) return;
    setState(() {
      for (final col in _columns) {
        col.y += col.speed * 3;
        if (col.y > MediaQuery.of(context).size.height + 200) {
          col.y = -200.0 - _random.nextDouble() * 200;
          col.speed = 0.3 + _random.nextDouble() * 0.7;
          col.chars = _generateChars();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final baseColor = widget.baseColor;

    return CustomPaint(
      size: Size.infinite,
      painter: _MatrixPainter(
        columns: _columns,
        screenHeight: screenH,
        baseColor: baseColor,
      ),
    );
  }
}

class _ColumnData {
  double x;
  double speed;
  List<String> chars;
  double y;

  _ColumnData({
    required this.x,
    required this.speed,
    required this.chars,
    required this.y,
  });
}

class _MatrixPainter extends CustomPainter {
  final List<_ColumnData> columns;
  final double screenHeight;
  final Color baseColor;

  _MatrixPainter({
    required this.columns,
    required this.screenHeight,
    required this.baseColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final charHeight = size.height / 25;

    for (final col in columns) {
      for (var i = 0; i < col.chars.length; i++) {
        final charY = col.y + i * charHeight;
        if (charY < -charHeight || charY > size.height + charHeight) continue;

        final fade = (i / col.chars.length).clamp(0.0, 1.0);
        final alpha = ((1.0 - fade) * 255).toInt().clamp(0, 255);

        final color = i == 0
            ? baseColor
            : Color.fromARGB(alpha, baseColor.red, baseColor.green, baseColor.blue);

        final textPainter = TextPainter(
          text: TextSpan(
            text: col.chars[i],
            style: TextStyle(
              color: color,
              fontSize: charHeight * 0.85,
              fontFamily: 'monospace',
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        textPainter.paint(canvas, Offset(col.x, charY));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MatrixPainter oldDelegate) => true;
}
