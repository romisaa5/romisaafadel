import 'package:flutter/material.dart';

/// Pixel-perfect vector brand icons for GitHub, Google Play, Apple App Store, and LinkedIn.
///
/// Built using precise vector paths so they render flawlessly across all pixel densities
/// without requiring extra external icon packages.
class BrandIcon extends StatelessWidget {
  const BrandIcon.github({
    super.key,
    this.size = 20,
    this.color,
  }) : _type = _BrandIconType.github;

  const BrandIcon.googlePlay({
    super.key,
    this.size = 20,
    this.color,
  }) : _type = _BrandIconType.googlePlay;

  const BrandIcon.appStore({
    super.key,
    this.size = 20,
    this.color,
  }) : _type = _BrandIconType.appStore;

  const BrandIcon.linkedIn({
    super.key,
    this.size = 20,
    this.color,
  }) : _type = _BrandIconType.linkedIn;

  final double size;
  final Color? color;
  final _BrandIconType _type;

  @override
  Widget build(BuildContext context) {
    final effectiveColor =
        color ?? IconTheme.of(context).color ?? Colors.white;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _BrandIconPainter(
          type: _type,
          color: effectiveColor,
        ),
      ),
    );
  }
}

enum _BrandIconType {
  github,
  googlePlay,
  appStore,
  linkedIn,
}

class _BrandIconPainter extends CustomPainter {
  _BrandIconPainter({
    required this.type,
    required this.color,
  });

  final _BrandIconType type;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.save();
    canvas.scale(size.width / 24.0, size.height / 24.0);

    switch (type) {
      case _BrandIconType.github:
        _paintGithub(canvas, paint);
        break;
      case _BrandIconType.googlePlay:
        _paintGooglePlay(canvas, paint);
        break;
      case _BrandIconType.appStore:
        _paintAppStore(canvas, paint);
        break;
      case _BrandIconType.linkedIn:
        _paintLinkedIn(canvas, paint);
        break;
    }

    canvas.restore();
  }

  void _paintGithub(Canvas canvas, Paint paint) {
    final path = Path()
      ..moveTo(12.0, 1.75)
      ..cubicTo(5.92, 1.75, 1.0, 6.67, 1.0, 12.75)
      ..cubicTo(1.0, 17.62, 4.16, 21.74, 8.55, 23.2)
      ..cubicTo(9.1, 23.3, 9.3, 22.96, 9.3, 22.67)
      ..cubicTo(9.3, 22.41, 9.29, 21.55, 9.29, 20.61)
      ..cubicTo(6.23, 21.28, 5.58, 19.34, 5.58, 19.34)
      ..cubicTo(5.08, 18.07, 4.36, 17.73, 4.36, 17.73)
      ..cubicTo(3.36, 17.05, 4.44, 17.06, 4.44, 17.06)
      ..cubicTo(5.55, 17.14, 6.13, 18.2, 6.13, 18.2)
      ..cubicTo(7.11, 19.88, 8.7, 19.39, 9.33, 19.11)
      ..cubicTo(9.43, 18.4, 9.71, 17.91, 10.03, 17.64)
      ..cubicTo(7.59, 17.36, 5.02, 16.42, 5.02, 12.22)
      ..cubicTo(5.02, 11.02, 5.45, 10.04, 6.15, 9.27)
      ..cubicTo(6.04, 8.99, 5.66, 7.87, 6.26, 6.35)
      ..cubicTo(6.26, 6.35, 7.18, 6.06, 9.28, 7.48)
      ..cubicTo(10.15, 7.24, 11.08, 7.12, 12.0, 7.11)
      ..cubicTo(12.92, 7.12, 13.85, 7.24, 14.73, 7.48)
      ..cubicTo(16.82, 6.06, 17.74, 6.35, 17.74, 6.35)
      ..cubicTo(18.34, 7.87, 17.96, 8.99, 17.85, 9.27)
      ..cubicTo(18.56, 10.04, 18.98, 11.02, 18.98, 12.22)
      ..cubicTo(18.98, 16.43, 16.4, 17.35, 13.95, 17.62)
      ..cubicTo(14.35, 17.96, 14.7, 18.63, 14.7, 19.65)
      ..cubicTo(14.7, 21.12, 14.69, 22.3, 14.69, 22.67)
      ..cubicTo(14.69, 22.96, 14.89, 23.31, 15.45, 23.2)
      ..cubicTo(19.84, 21.73, 23.0, 17.62, 23.0, 12.75)
      ..cubicTo(23.0, 6.67, 18.08, 1.75, 12.0, 1.75)
      ..close();
    canvas.drawPath(path, paint);
  }

  void _paintGooglePlay(Canvas canvas, Paint paint) {
    // Official Google Play polygon shape
    final path = Path()
      ..moveTo(3.6, 2.5)
      ..cubicTo(3.3, 2.8, 3.1, 3.3, 3.1, 4.0)
      ..lineTo(3.1, 20.0)
      ..cubicTo(3.1, 20.7, 3.3, 21.2, 3.6, 21.5)
      ..lineTo(3.7, 21.6)
      ..lineTo(13.6, 12.0)
      ..lineTo(3.7, 2.4)
      ..close();

    final path2 = Path()
      ..moveTo(16.9, 8.7)
      ..lineTo(13.6, 12.0)
      ..lineTo(16.9, 15.3)
      ..lineTo(20.7, 13.1)
      ..cubicTo(21.8, 12.5, 21.8, 11.5, 20.7, 10.9)
      ..close();

    final path3 = Path()
      ..moveTo(3.6, 2.5)
      ..lineTo(13.6, 12.0)
      ..lineTo(16.9, 8.7)
      ..lineTo(6.4, 2.7)
      ..cubicTo(5.2, 2.0, 4.2, 1.9, 3.6, 2.5)
      ..close();

    final path4 = Path()
      ..moveTo(3.6, 21.5)
      ..cubicTo(4.2, 22.1, 5.2, 22.0, 6.4, 21.3)
      ..lineTo(16.9, 15.3)
      ..lineTo(13.6, 12.0)
      ..lineTo(3.6, 21.5)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path2, paint);
    canvas.drawPath(path3, paint);
    canvas.drawPath(path4, paint);
  }

  void _paintAppStore(Canvas canvas, Paint paint) {
    // Apple App Store iconic Apple logo
    final path = Path()
      ..moveTo(18.71, 19.5)
      ..cubicTo(17.88, 20.71, 17.0, 21.9, 15.66, 21.93)
      ..cubicTo(14.32, 21.95, 13.89, 21.14, 12.37, 21.14)
      ..cubicTo(10.83, 21.14, 10.36, 21.91, 9.09, 21.95)
      ..cubicTo(7.77, 22.0, 6.78, 20.67, 5.95, 19.47)
      ..cubicTo(4.25, 17.03, 2.96, 12.58, 4.71, 9.54)
      ..cubicTo(5.58, 8.03, 7.13, 7.07, 8.81, 7.05)
      ..cubicTo(10.1, 7.02, 11.32, 7.92, 12.11, 7.92)
      ..cubicTo(12.89, 7.92, 14.37, 6.84, 15.93, 7.0)
      ..cubicTo(16.58, 7.03, 18.42, 7.26, 19.61, 9.0)
      ..cubicTo(19.5, 9.07, 17.65, 10.15, 17.67, 12.4)
      ..cubicTo(17.7, 15.08, 20.03, 15.97, 20.07, 15.99)
      ..cubicTo(20.04, 16.08, 19.7, 17.27, 18.71, 19.5)
      ..close();

    // Leaf
    final leaf = Path()
      ..moveTo(14.85, 5.37)
      ..cubicTo(15.54, 4.54, 16.0, 3.38, 15.87, 2.21)
      ..cubicTo(14.87, 2.25, 13.62, 2.88, 12.91, 3.71)
      ..cubicTo(12.28, 4.43, 11.74, 5.61, 11.89, 6.75)
      ..cubicTo(13.01, 6.84, 14.18, 6.18, 14.85, 5.37)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(leaf, paint);
  }

  void _paintLinkedIn(Canvas canvas, Paint paint) {
    // LinkedIn "in" symbol
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        const Rect.fromLTWH(2, 2, 20, 20),
        const Radius.circular(4.5),
      ));

    final cutPaint = Paint()
      ..blendMode = BlendMode.clear
      ..isAntiAlias = true;

    // Draw base container
    canvas.drawPath(path, paint);

    // Letter 'i' dot
    canvas.drawCircle(const Offset(7.1, 7.2), 1.45, cutPaint);
    // Letter 'i' stem
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(5.8, 9.8, 2.6, 8.2),
        const Radius.circular(0.8),
      ),
      cutPaint,
    );

    // Letter 'n'
    final nPath = Path()
      ..moveTo(10.4, 9.8)
      ..lineTo(12.8, 9.8)
      ..lineTo(12.8, 11.0)
      ..cubicTo(13.4, 10.1, 14.6, 9.6, 16.0, 9.6)
      ..cubicTo(18.3, 9.6, 19.5, 11.0, 19.5, 13.6)
      ..lineTo(19.5, 18.0)
      ..lineTo(16.9, 18.0)
      ..lineTo(16.9, 14.2)
      ..cubicTo(16.9, 13.1, 16.4, 12.3, 15.2, 12.3)
      ..cubicTo(13.9, 12.3, 13.0, 13.3, 13.0, 14.6)
      ..lineTo(13.0, 18.0)
      ..lineTo(10.4, 18.0)
      ..close();

    canvas.drawPath(nPath, cutPaint);
  }

  @override
  bool shouldRepaint(covariant _BrandIconPainter oldDelegate) {
    return oldDelegate.type != type || oldDelegate.color != color;
  }
}
