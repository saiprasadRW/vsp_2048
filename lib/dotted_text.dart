import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class DottedText extends StatefulWidget {
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
  State<DottedText> createState() => _DottedTextState();
}

class _DottedTextState extends State<DottedText> {
  List<Offset>? _dots;
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    _rasterize();
  }

  @override
  void didUpdateWidget(covariant DottedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text ||
        oldWidget.style != widget.style ||
        oldWidget.dotRadius != widget.dotRadius ||
        oldWidget.dotSpacing != widget.dotSpacing) {
      _disposeImage();
      _rasterize();
    }
  }

  @override
  void dispose() {
    _disposeImage();
    super.dispose();
  }

  void _disposeImage() {
    _image?.dispose();
    _image = null;
    _dots = null;
  }

  Future<void> _rasterize() async {
    final text = widget.text;
    final style = widget.style;
    final dotRadius = widget.dotRadius;
    final dotSpacing = widget.dotSpacing;

    if (!mounted) return;

    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    );

    // Use a reasonable size for layout
    textPainter.layout(maxWidth: 300);

    final width = math.min(textPainter.width, 300.0).ceil();
    final height = textPainter.height.ceil();
    if (width <= 0 || height <= 0) return;

    final recorder = ui.PictureRecorder();
    final textCanvas = Canvas(recorder);
    textPainter.paint(textCanvas, Offset.zero);
    final picture = recorder.endRecording();

    final image = await picture.toImage(width, height);
    if (!mounted) {
      image.dispose();
      return;
    }

    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null || !mounted) {
      image.dispose();
      return;
    }

    final pixels = byteData.buffer.asUint8List();
    final step = dotRadius * 2 + dotSpacing;
    final dots = <Offset>[];

    for (double y = 0; y < height; y += step) {
      for (double x = 0; x < width; x += step) {
        final px = x.toInt().clamp(0, width - 1);
        final py = y.toInt().clamp(0, height - 1);
        final idx = (py * width + px) * 4;
        final alpha = pixels[idx + 3];

        if (alpha > 30) {
          dots.add(Offset(x, y));
        }
      }
    }

    setState(() {
      _image = image;
      _dots = dots;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_dots == null || _image == null) {
      return const SizedBox.shrink();
    }

    return CustomPaint(
      size: Size(_image!.width.toDouble(), _image!.height.toDouble()),
      painter: _DottedTextPainter(
        dots: _dots!,
        dotRadius: widget.dotRadius,
        color: widget.style.color ?? Colors.white,
      ),
    );
  }
}

class _DottedTextPainter extends CustomPainter {
  _DottedTextPainter({
    required this.dots,
    required this.dotRadius,
    required this.color,
  });

  final List<Offset> dots;
  final double dotRadius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()..color = color;
    for (final dot in dots) {
      canvas.drawCircle(dot, dotRadius, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _DottedTextPainter oldDelegate) {
    return oldDelegate.dots != dots ||
        oldDelegate.dotRadius != dotRadius ||
        oldDelegate.color != color;
  }
}
