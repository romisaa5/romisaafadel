import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

/// Full-viewport fine technical grid background with architectural dots,
/// subtle grain texture, and restrained animated ambient lighting.
///
/// Designed to precisely match the visual atmosphere of the reference portfolio,
/// adapted to Romisaa Fadel's mauve and plum brand palette.
class FineGridBackground extends StatefulWidget {
  const FineGridBackground({
    super.key,
    required this.isDark,
    this.parallaxOffset = Offset.zero,
    this.child,
  });

  final bool isDark;
  final Offset parallaxOffset;
  final Widget? child;

  @override
  State<FineGridBackground> createState() => _FineGridBackgroundState();
}

class _FineGridBackgroundState extends State<FineGridBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animCtrl,
      builder: (context, child) {
        return CustomPaint(
          painter: _FineGridPainter(
            isDark: widget.isDark,
            t: _animCtrl.value,
            parallaxOffset: widget.parallaxOffset,
          ),
          child: widget.child,
        );
      },
      child: widget.child,
    );
  }
}

class _FineGridPainter extends CustomPainter {
  _FineGridPainter({
    required this.isDark,
    required this.t,
    required this.parallaxOffset,
  });

  final bool isDark;
  final double t;
  final Offset parallaxOffset;

  static const double gridSize = 72.0;

  // Pre-computed pseudo-random grain specks (deterministic via seed)
  static final List<({double x, double y, double r, double a})> _specks = () {
    final rng = math.Random(1024);
    return List.generate(80, (_) => (
          x: rng.nextDouble(),
          y: rng.nextDouble(),
          r: 0.6 + rng.nextDouble() * 0.9,
          a: 0.05 + rng.nextDouble() * 0.12,
        ));
  }();

  @override
  void paint(Canvas canvas, Size size) {
    final bgRect = Offset.zero & size;

    // 1. Base surface color
    final bgColor = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    canvas.drawRect(bgRect, Paint()..color = bgColor);

    // 2. Soft ambient radial highlights (shifting subtly with animation and parallax)
    final heroGlowCenter = Offset(
      size.width * 0.70 + parallaxOffset.dx * 1.5,
      size.height * 0.38 + parallaxOffset.dy * 1.5,
    );
    final glowRadius = math.max(size.width, size.height) * 0.45;

    final glowColor = isDark
        ? AppColors.mauve.withValues(alpha: 0.09 + t * 0.04)
        : AppColors.dustyRose.withValues(alpha: 0.08 + t * 0.03);

    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [glowColor, Colors.transparent],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: heroGlowCenter, radius: glowRadius));
    canvas.drawRect(bgRect, glowPaint);

    // Secondary soft corner ambient highlight
    final cornerCenter = Offset(
      size.width * 0.15 - parallaxOffset.dx,
      size.height * 0.75 - parallaxOffset.dy,
    );
    final cornerGlowColor = isDark
        ? AppColors.darkSurfaceVariant.withValues(alpha: 0.25)
        : AppColors.softBlush.withValues(alpha: 0.35);
    final cornerPaint = Paint()
      ..shader = RadialGradient(
        colors: [cornerGlowColor, Colors.transparent],
      ).createShader(Rect.fromCircle(center: cornerCenter, radius: size.width * 0.35));
    canvas.drawRect(bgRect, cornerPaint);

    // 3. Blueprint Fine Grid Lines
    final gridLineColor = isDark
        ? AppColors.dustyRose.withValues(alpha: 0.055)
        : AppColors.mauve.withValues(alpha: 0.065);

    final gridPaint = Paint()
      ..color = gridLineColor
      ..strokeWidth = 0.75
      ..style = PaintingStyle.stroke;

    final numCols = (size.width / gridSize).ceil() + 1;
    final numRows = (size.height / gridSize).ceil() + 1;

    for (int i = 0; i <= numCols; i++) {
      final x = i * gridSize;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (int j = 0; j <= numRows; j++) {
      final y = j * gridSize;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // 4. Subtle moving light sweep on selected grid lines
    final sweepX = (t * (size.width + 300)) - 150;
    final sweepPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          (isDark ? AppColors.softBlush : AppColors.mauve)
              .withValues(alpha: isDark ? 0.08 : 0.07),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(sweepX - 40, 0, 80, size.height))
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(sweepX, 0), Offset(sweepX, size.height), sweepPaint);

    // 5. Intersection Dots (with slight organic pulsing opacity)
    final dotBaseColor = isDark ? AppColors.softBlush : AppColors.mauve;

    for (int i = 0; i <= numCols; i++) {
      final x = i * gridSize;
      for (int j = 0; j <= numRows; j++) {
        final y = j * gridSize;

        // Pulse selected dots based on location & time
        final phase = (i * 7 + j * 13) % 10;
        final isPulsing = phase < 3;
        final pulse = isPulsing ? math.sin(t * math.pi * 2 + phase) * 0.06 : 0.0;
        final dotAlpha = (isDark ? 0.16 : 0.18) + pulse;

        final dotPaint = Paint()
          ..color = dotBaseColor.withValues(alpha: dotAlpha.clamp(0.04, 0.40))
          ..style = PaintingStyle.fill;

        canvas.drawCircle(Offset(x, y), 1.25, dotPaint);
      }
    }

    // 6. Scattered fine speckles / paper texture
    for (final s in _specks) {
      final sx = s.x * size.width;
      final sy = s.y * size.height;
      final speckPaint = Paint()
        ..color = dotBaseColor.withValues(alpha: isDark ? s.a * 0.8 : s.a)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(sx, sy), s.r, speckPaint);
    }
  }

  @override
  bool shouldRepaint(_FineGridPainter old) =>
      old.isDark != isDark ||
      old.t != t ||
      old.parallaxOffset != parallaxOffset;
}
