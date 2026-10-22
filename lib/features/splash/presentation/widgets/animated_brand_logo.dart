import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/responsive/responsive_utils.dart';

/// Animated brand logo reveal for the splash screen.
///
/// The logo PNG has a white background. Treatment by theme:
/// - **Dark mode**: The logo is rendered inside a light circle container
///   (soft blush / ivory tinted) so the dark RF letters remain visible,
///   while the circle itself blends elegantly with the dark canvas.
/// - **Light mode**: White background is naturally consistent with ivory.
///
/// Reveal animation stages (all driven by the parent animation):
///   1. Scale from 0.6 → 1.0 with an elastic overshoot.
///   2. Opacity fade from 0.0 → 1.0.
///   3. A subtle upward translation as it settles.
///   4. A soft glow pulse after the reveal.
class AnimatedBrandLogo extends StatelessWidget {
  const AnimatedBrandLogo({
    super.key,
    required this.scaleAnimation,
    required this.opacityAnimation,
    required this.slideAnimation,
    required this.glowAnimation,
  });

  final Animation<double> scaleAnimation;
  final Animation<double> opacityAnimation;
  final Animation<Offset> slideAnimation;
  final Animation<double> glowAnimation;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final logoSize = context.splashLogoDiameter;

    return FadeTransition(
      opacity: opacityAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: AnimatedBuilder(
            animation: glowAnimation,
            builder: (context, child) {
              return Container(
                width: logoSize,
                height: logoSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.mauve.withValues(
                        alpha: 0.35 * glowAnimation.value,
                      ),
                      blurRadius: 60 * glowAnimation.value,
                      spreadRadius: 10 * glowAnimation.value,
                    ),
                    BoxShadow(
                      color: AppColors.dustyRose.withValues(
                        alpha: 0.20 * glowAnimation.value,
                      ),
                      blurRadius: 120 * glowAnimation.value,
                      spreadRadius: 20 * glowAnimation.value,
                    ),
                  ],
                ),
                child: child,
              );
            },
            child: ClipOval(
              child: _LogoImage(isDark: isDark, size: logoSize),
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoImage extends StatelessWidget {
  const _LogoImage({required this.isDark, required this.size});

  final bool isDark;
  final double size;

  @override
  Widget build(BuildContext context) {
    // In dark mode, render the logo on a soft blush tinted circle so the
    // deep plum RF letters remain fully legible against the dark canvas.
    final bgColor = isDark
        ? const Color(0xFFEBDFE7) // slightly warmer soft blush for dark bg
        : AppColors.lightBackground;

    return Container(
      width: size,
      height: size,
      color: bgColor,
      child: Image.asset(
        'assets/images/logo.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stack) {
          return _FallbackLogo(size: size, isDark: isDark);
        },
      ),
    );
  }
}

/// Text-based RF fallback shown if logo.png cannot be loaded.
class _FallbackLogo extends StatelessWidget {
  const _FallbackLogo({required this.size, required this.isDark});

  final double size;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border.all(
          color: AppColors.mauve,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          'RF',
          style: TextStyle(
            fontSize: size * 0.35,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.dustyRose : AppColors.mauve,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
