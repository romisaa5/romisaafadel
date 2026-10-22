import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

/// Full-screen ambient background for the splash screen.
///
/// Creates layered animated orbs that drift slowly across the canvas,
/// building depth and atmosphere without expensive blur or particle effects.
/// All animations are driven by a single parent [AnimationController].
class AmbientBackground extends StatefulWidget {
  const AmbientBackground({super.key, required this.opacity});

  /// Controls how visible the background is (0.0 → 1.0).
  final Animation<double> opacity;

  @override
  State<AmbientBackground> createState() => _AmbientBackgroundState();
}

class _AmbientBackgroundState extends State<AmbientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _driftController;

  @override
  void initState() {
    super.initState();
    _driftController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _driftController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;

    return IgnorePointer(
      child: FadeTransition(
        opacity: widget.opacity,
        child: Container(
          color: bgColor,
          child: AnimatedBuilder(
            animation: _driftController,
            builder: (context, _) {
              return CustomPaint(
                painter: _AmbientOrbPainter(
                  progress: _driftController.value,
                  isDark: isDark,
                ),
                child: const SizedBox.expand(),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AmbientOrbPainter extends CustomPainter {
  const _AmbientOrbPainter({required this.progress, required this.isDark});

  final double progress;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final eased = Curves.easeInOut.transform(progress);

    // Orb 1 — large, top-right, primary accent colour
    _drawOrb(
      canvas,
      center: Offset(
        size.width * 0.75 + math.sin(eased * math.pi) * size.width * 0.08,
        size.height * 0.2 + math.cos(eased * math.pi) * size.height * 0.06,
      ),
      radius: size.width * 0.38,
      color: isDark
          ? AppColors.mauve.withValues(alpha: 0.12)
          : AppColors.dustyRose.withValues(alpha: 0.18),
    );

    // Orb 2 — medium, bottom-left
    _drawOrb(
      canvas,
      center: Offset(
        size.width * 0.15 + math.cos(eased * math.pi) * size.width * 0.06,
        size.height * 0.78 + math.sin(eased * math.pi) * size.height * 0.05,
      ),
      radius: size.width * 0.28,
      color: isDark
          ? AppColors.deepPlum.withValues(alpha: 0.55)
          : AppColors.softBlush.withValues(alpha: 0.60),
    );

    // Orb 3 — small, center-left, detail accent
    _drawOrb(
      canvas,
      center: Offset(
        size.width * 0.25 + math.sin(eased * math.pi * 1.3) * size.width * 0.05,
        size.height * 0.42 +
            math.cos(eased * math.pi * 0.9) * size.height * 0.08,
      ),
      radius: size.width * 0.16,
      color: isDark
          ? AppColors.dustyRose.withValues(alpha: 0.07)
          : AppColors.mauve.withValues(alpha: 0.10),
    );
  }

  void _drawOrb(
    Canvas canvas, {
    required Offset center,
    required double radius,
    required Color color,
  }) {
    final paint = Paint()
      ..shader = RadialGradient(colors: [color, color.withValues(alpha: 0.0)])
          .createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_AmbientOrbPainter old) => old.progress != progress;
}
