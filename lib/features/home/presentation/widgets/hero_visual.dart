import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

/// Animated architectural portrait for the portfolio hero section.
///
/// Includes a gentle floating motion, hover scale, ambient brand glow,
/// parallax layers, a dashed contour, and floating information badges.
/// The profile image stays in its natural full color at all times.
class HeroVisual extends StatelessWidget {
  const HeroVisual({
    super.key,
    required this.opacity,
    required this.scale,
    this.parallaxOffset = Offset.zero,
    required this.isWide,
  });

  final double opacity;
  final double scale;
  final Offset parallaxOffset;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = isWide ? 380.0 : 310.0;
    final height = isWide ? 490.0 : 400.0;

    return Opacity(
      opacity: opacity,
      child: Transform.scale(
        scale: scale,
        child: _EditorialPortrait(
          width: width,
          height: height,
          isDark: isDark,
          parallaxOffset: parallaxOffset,
          isWide: isWide,
        ),
      ),
    );
  }
}

class _EditorialPortrait extends StatefulWidget {
  const _EditorialPortrait({
    required this.width,
    required this.height,
    required this.isDark,
    required this.parallaxOffset,
    required this.isWide,
  });

  final double width;
  final double height;
  final bool isDark;
  final Offset parallaxOffset;
  final bool isWide;

  @override
  State<_EditorialPortrait> createState() => _EditorialPortraitState();
}

class _EditorialPortraitState extends State<_EditorialPortrait>
    with TickerProviderStateMixin {
  late final AnimationController _hoverAnim;
  late final AnimationController _floatAnim;

  @override
  void initState() {
    super.initState();

    _hoverAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _floatAnim = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _hoverAnim.dispose();
    _floatAnim.dispose();
    super.dispose();
  }

  void _onEnter(PointerEvent event) => _hoverAnim.forward();

  void _onExit(PointerEvent event) => _hoverAnim.reverse();

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final w = widget.width;
    final h = widget.height;
    final rawP = widget.parallaxOffset;
    final p = Offset(
      rawP.dx.isFinite ? rawP.dx : 0.0,
      rawP.dy.isFinite ? rawP.dy : 0.0,
    );

    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      child: SizedBox(
        width: w + 74,
        height: h + 74,
        child: AnimatedBuilder(
          animation: Listenable.merge([_hoverAnim, _floatAnim]),
          builder: (context, _) {
            final hover = Curves.easeOutCubic.transform(_hoverAnim.value);
            final phase = _floatAnim.value * 2 * math.pi;
            final floatY = math.sin(phase) * 7;
            final floatX = math.cos(phase) * 2.5;
            final glowPulse = (math.sin(phase) + 1) / 2;

            return Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // Ambient glow gently pulses behind the portrait.
                Positioned(
                  left: 37 - p.dx * 0.5,
                  top: 37 - p.dy * 0.5 + floatY * 0.35,
                  child: Container(
                    width: w,
                    height: h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(42),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.mauve.withValues(
                            alpha: (isDark ? 0.18 : 0.11) + glowPulse * 0.08,
                          ),
                          blurRadius: 55 + glowPulse * 18,
                          spreadRadius: 5 + glowPulse * 5,
                        ),
                        BoxShadow(
                          color: AppColors.dustyRose.withValues(
                            alpha: (isDark ? 0.10 : 0.06) + glowPulse * 0.035,
                          ),
                          blurRadius: 95,
                          spreadRadius: 12,
                        ),
                      ],
                    ),
                  ),
                ),

                // Offset dashed architectural contour.
                Positioned(
                  left: 26 + p.dx * 0.4 - floatX * 0.35,
                  top: 26 + p.dy * 0.4 - floatY * 0.3,
                  child: CustomPaint(
                    size: Size(w + 22, h + 22),
                    painter: _DashedContourPainter(
                      isDark: isDark,
                      radius: 44,
                      color: (isDark ? AppColors.dustyRose : AppColors.mauve)
                          .withValues(alpha: 0.24 + glowPulse * 0.13),
                    ),
                  ),
                ),

                // Main portrait: subtle floating movement and hover scale.
                Positioned(
                  left: 37 + p.dx + floatX,
                  top: 37 + p.dy + floatY,
                  child: Transform.scale(
                    scale: 1 + hover * 0.025,
                    child: Transform.rotate(
                      angle: (p.dx / 12).clamp(-1.0, 1.0) * 0.012 * hover,
                      child: Container(
                        width: w,
                        height: h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(38),
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder.withValues(alpha: 0.85),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  (isDark ? Colors.black : AppColors.deepPlum)
                                      .withValues(alpha: isDark ? 0.40 : 0.09),
                              blurRadius: 28 + hover * 12,
                              offset: Offset(0, 14 + hover * 5),
                            ),
                            BoxShadow(
                              color: AppColors.mauve.withValues(
                                alpha: hover * (isDark ? 0.20 : 0.13),
                              ),
                              blurRadius: 35,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(36.8),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Container(
                                color: isDark
                                    ? AppColors.darkSurfaceVariant
                                    : AppColors.lightSurfaceVariant,
                              ),
                              _buildProfileImage(isDark),
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                height: h * 0.20,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.white.withValues(
                                          alpha: isDark ? 0.08 : 0.12,
                                        ),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                height: h * 0.20,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        (isDark
                                                ? AppColors.darkBackground
                                                : AppColors.lightBackground)
                                            .withValues(alpha: 0.25),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Technology badge, floating independently near the bottom.
                Positioned(
                  bottom: 9 + floatY * 0.5,
                  right: 0 - floatX * 0.4,
                  child: Transform.rotate(
                    angle: 0.045 - hover * 0.025,
                    child: _FloatingBadge(
                      isDark: isDark,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.flutter_dash,
                            size: 19,
                            color: isDark
                                ? AppColors.dustyRose
                                : AppColors.mauve,
                          ),
                          const SizedBox(width: 7),
                          const Text('Flutter Developer'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileImage(bool isDark) {
    return Image.asset(
      'assets/images/profile.jpg',
      fit: BoxFit.cover,
      alignment: const Alignment(0, -0.2),
      errorBuilder: (_, _, _) => _FallbackPortrait(
        isDark: isDark,
        width: widget.width,
        height: widget.height,
      ),
    );
  }
}

class _FloatingBadge extends StatelessWidget {
  const _FloatingBadge({required this.isDark, required this.child});

  final bool isDark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: (isDark ? AppColors.darkSurface : Colors.white).withValues(
          alpha: 0.94,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (isDark ? AppColors.dustyRose : AppColors.mauve).withValues(
            alpha: 0.22,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.mauve.withValues(alpha: isDark ? 0.16 : 0.09),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          color: isDark ? AppColors.ivory : AppColors.deepPlum,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        child: child,
      ),
    );
  }
}

class _DashedContourPainter extends CustomPainter {
  const _DashedContourPainter({
    required this.isDark,
    required this.radius,
    required this.color,
  });

  final bool isDark;
  final double radius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    _drawDashedPath(canvas, path, paint, dashWidth: 6, dashSpace: 5);
  }

  void _drawDashedPath(
    Canvas canvas,
    Path source,
    Paint paint, {
    required double dashWidth,
    required double dashSpace,
  }) {
    for (final metric in source.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final length = (distance + dashWidth < metric.length)
            ? dashWidth
            : metric.length - distance;
        canvas.drawPath(metric.extractPath(distance, distance + length), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedContourPainter old) =>
      old.isDark != isDark || old.color != color || old.radius != radius;
}

class _FallbackPortrait extends StatelessWidget {
  const _FallbackPortrait({
    required this.isDark,
    required this.width,
    required this.height,
  });

  final bool isDark;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: isDark
          ? AppColors.darkSurfaceVariant
          : AppColors.lightSurfaceVariant,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => Center(
                  child: Text(
                    'RF',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.dustyRose : AppColors.mauve,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Romisaa Fadel',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.ivory : AppColors.deepPlum,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
