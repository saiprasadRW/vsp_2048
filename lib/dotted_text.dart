import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class DottedText extends StatelessWidget {
  const DottedText({
    super.key,
    required this.text,
    required this.style,
    this.dotRadius = 1.2,
    this.dotSpacing = 2,
  });

  final String text;
  final TextStyle style;
  final double dotRadius;
  final double dotSpacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _DottedTextPainter(
            text: text,
            style: style,
            dotRadius: dotRadius,
            dotSpacing: dotSpacing,
          ),
        );
      },
    );
  }
}

class _DottedTextPainter extends CustomPainter {
  _DottedTextPainter({
    required this.text,
    required this.style,
    required this.dotRadius,
    required this.dotSpacing,
  });

  final String text;
  final TextStyle style;
  final double dotRadius;
  final double dotSpacing;

  @override
  void paint(Canvas canvas, Size size) async {
    if (size.width <= 0 || size.height <= 0 || text.isEmpty) return;

    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width);

    final width = math.min(textPainter.width, size.width).ceil();
    final height = math.min(textPainter.height, size.height).ceil();
    if (width <= 0 || height <= 0) return;

    final recorder = ui.PictureRecorder();
    final textCanvas = Canvas(recorder);
    textPainter.paint(textCanvas, Offset.zero);
    final picture = recorder.endRecording();

    final image = await picture.toImage(width, height);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) return;
    final pixels = byteData.buffer.asUint8List();

    final dotPaint = Paint()..color = style.color ?? Colors.white;

    final ox = (size.width - width) / 2;
    final oy = (size.height - height) / 2;

    final step = dotRadius * 2 + dotSpacing;

    for (double y = 0; y < height; y += step) {
      for (double x = 0; x < width; x += step) {
        final px = x.toInt().clamp(0, width - 1);
        final py = y.toInt().clamp(0, height - 1);
        final idx = (py * width + px) * 4;
        final alpha = pixels[idx + 3];

        if (alpha > 30) {
          canvas.drawCircle(Offset(ox + x, oy + y), dotRadius, dotPaint);
        }
      }
    }

    image.dispose();
  }

  @override
  bool shouldRepaint(covariant _DottedTextPainter oldDelegate) {
    return oldDelegate.text != text ||
        oldDelegate.style != style ||
        oldDelegate.dotRadius != dotRadius ||
        oldDelegate.dotSpacing != dotSpacing;
  }
}
