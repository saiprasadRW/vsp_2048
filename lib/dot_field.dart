import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class DotField extends StatelessWidget {
  const DotField({
    super.key,
    this.dotRadius = 2.5,
    this.dotSpacing = 12,
    this.sparkle = false,
    this.glow = false,
    this.gradientFrom = const Color.fromRGBO(30, 100, 220, 0.5),
    this.gradientTo = const Color.fromRGBO(100, 160, 230, 0.4),
  });

  final double dotRadius;
  final double dotSpacing;
  final bool sparkle;
  final bool glow;
  final Color gradientFrom;
  final Color gradientTo;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return SizedBox(
          width: size.width,
          height: size.height,
          child: CustomPaint(
            painter: _DotFieldPainter(
              size: size,
              dotRadius: dotRadius,
              dotSpacing: dotSpacing,
              sparkle: sparkle,
              glow: glow,
              gradientFrom: gradientFrom,
              gradientTo: gradientTo,
            ),
          ),
        );
      },
    );
  }
}

class _DotFieldPainter extends CustomPainter {
  _DotFieldPainter({
    required this.size,
    required this.dotRadius,
    required this.dotSpacing,
    required this.sparkle,
    required this.glow,
    required this.gradientFrom,
    required this.gradientTo,
  });

  final Size size;
  final double dotRadius;
  final double dotSpacing;
  final bool sparkle;
  final bool glow;
  final Color gradientFrom;
  final Color gradientTo;

  @override
  void paint(Canvas canvas, Size canvasSize) {
    if (size.width <= 0 || size.height <= 0) return;

    final step = dotRadius + dotSpacing;
    final cols = (size.width / step).floor();
    final rows = (size.height / step).floor();
    final padX = (size.width % step) / 2;
    final padY = (size.height % step) / 2;

    final rng = math.Random(42);

    final path = Path();
    final rad = dotRadius / 2;

    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < cols; col++) {
        final ax = padX + col * step + step / 2;
        final ay = padY + row * step + step / 2;

        double r = rad;
        if (sparkle && rng.nextDouble() < 0.03) {
          r = rad * 1.8;
        }

        if (glow) {
          final glowPaint = Paint()
            ..shader = ui.Gradient.radial(
              Offset(ax, ay),
              r * 3,
              [
                gradientFrom.withOpacity(0.6),
                gradientFrom.withOpacity(0.0),
              ],
            );
          canvas.drawCircle(Offset(ax, ay), r * 3, glowPaint);
        }

        path.addOval(Rect.fromCircle(center: Offset(ax, ay), radius: r));
      }
    }

    final dotPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset.zero,
        Offset(size.width, size.height),
        [gradientFrom, gradientTo],
      );

    canvas.drawPath(path, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _DotFieldPainter oldDelegate) {
    return oldDelegate.size != size ||
        oldDelegate.dotRadius != dotRadius ||
        oldDelegate.dotSpacing != dotSpacing ||
        oldDelegate.sparkle != sparkle ||
        oldDelegate.glow != glow ||
        oldDelegate.gradientFrom != gradientFrom ||
        oldDelegate.gradientTo != gradientTo;
  }
}
