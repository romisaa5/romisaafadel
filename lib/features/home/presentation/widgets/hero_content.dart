import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/responsive/responsive_utils.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Editorial typography half of the Hero section.
///
/// Features:
///   • Expressive Italic Serif Headline (DM Serif Display / Amiri) with natural 2-line break.
///   • Monospaced technical descriptor (JetBrains Mono) underneath the headline.
///   • Clean, legible sans-serif introduction paragraph (Outfit).
///   • Subtle, periodic light-sweep across the headline.
///   • Staggered entrance animations driven by parent controller.
class HeroContent extends StatelessWidget {
  const HeroContent({
    super.key,
    required this.nameOpacity,
    required this.nameSlide,
    required this.titleOpacity,
    required this.titleSlide,
    required this.introOpacity,
    required this.introSlide,
  });

  final double nameOpacity;
  final Offset nameSlide;
  final double titleOpacity;
  final Offset titleSlide;
  final double introOpacity;
  final Offset introSlide;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final primaryTextColor = isDark ? AppColors.ivory : AppColors.deepPlum;
    final secondaryTextColor = isDark
        ? AppColors.dustyRose.withValues(alpha: 0.90)
        : AppColors.mauve.withValues(alpha: 0.90);
    final bodyColor = isDark
        ? AppColors.ivory.withValues(alpha: 0.75)
        : AppColors.deepPlum.withValues(alpha: 0.75);

    final isCompact = context.isCompact;
    final isMedium = context.isMedium;

    // Headline sizing based on breakpoint
    final double headlineSize = isCompact ? 36.0 : (isMedium ? 48.0 : 60.0);
    final double headlineLineHeight = isArabic ? 1.35 : 1.08;

    return Column(
      crossAxisAlignment:
          isCompact ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Editorial Headline with Italic Serif & Subtle Shimmer ───────
        Opacity(
          opacity: nameOpacity,
          child: Transform.translate(
            offset: nameSlide,
            child: _ShimmerHeadline(
              isDark: isDark,
              child: RichText(
                textAlign: isCompact ? TextAlign.center : TextAlign.start,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: isArabic
                          ? '${l10n.heroGreetingPart1} '
                          : '${l10n.heroGreetingPart1}\n',
                      style: isArabic
                          ? GoogleFonts.amiri(
                              fontSize: headlineSize,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.italic,
                              color: primaryTextColor,
                              height: headlineLineHeight,
                            )
                          : GoogleFonts.dmSerifDisplay(
                              fontSize: headlineSize,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic,
                              color: primaryTextColor,
                              letterSpacing: -0.5,
                              height: headlineLineHeight,
                            ),
                    ),
                    TextSpan(
                      text: l10n.heroGreetingPart2,
                      style: isArabic
                          ? GoogleFonts.amiri(
                              fontSize: headlineSize,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.italic,
                              color: primaryTextColor,
                              height: headlineLineHeight,
                            )
                          : GoogleFonts.dmSerifDisplay(
                              fontSize: headlineSize,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic,
                              color: primaryTextColor,
                              letterSpacing: -0.5,
                              height: headlineLineHeight,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // ── Supporting Technical Descriptor (JetBrains Mono) ────────────
        Opacity(
          opacity: titleOpacity,
          child: Transform.translate(
            offset: titleSlide,
            child: Text(
              l10n.professionalTitle,
              textAlign: isCompact ? TextAlign.center : TextAlign.start,
              style: isArabic
                  ? GoogleFonts.cairo(
                      fontSize: isCompact ? 13.0 : 15.0,
                      fontWeight: FontWeight.w600,
                      color: secondaryTextColor,
                      letterSpacing: 0.5,
                    )
                  : GoogleFonts.jetBrainsMono(
                      fontSize: isCompact ? 13.0 : 15.0,
                      fontWeight: FontWeight.w500,
                      color: secondaryTextColor,
                      letterSpacing: 0.6,
                    ),
            ),
          ),
        ),

        const SizedBox(height: 28),

        // ── Introduction paragraph (Clean Sans-serif) ───────────────────
        Opacity(
          opacity: introOpacity,
          child: Transform.translate(
            offset: introSlide,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 510),
              child: Text(
                l10n.heroIntroduction,
                textAlign: isCompact ? TextAlign.center : TextAlign.start,
                style: GoogleFonts.outfit(
                  fontSize: isCompact ? 15.0 : 17.0,
                  fontWeight: FontWeight.w400,
                  color: bodyColor,
                  height: 1.75,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shimmer headline — periodic restrained light-sweep across the display name
// ─────────────────────────────────────────────────────────────────────────────

class _ShimmerHeadline extends StatefulWidget {
  const _ShimmerHeadline({
    required this.child,
    required this.isDark,
  });

  final Widget child;
  final bool isDark;

  @override
  State<_ShimmerHeadline> createState() => _ShimmerHeadlineState();
}

class _ShimmerHeadlineState extends State<_ShimmerHeadline>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _shimmer = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);

    // Initial delay then periodic repeat
    _scheduleNext(initialDelay: const Duration(milliseconds: 2200));
  }

  void _scheduleNext({Duration initialDelay = const Duration(seconds: 6)}) {
    Future.delayed(initialDelay, () {
      if (!mounted) return;
      _ctrl.forward(from: 0).then((_) => _scheduleNext());
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmer,
      builder: (context, child) {
        final t = _shimmer.value;
        final left = (t - 0.20).clamp(0.0, 1.0);
        final center = t.clamp(0.0, 1.0);
        final right = (t + 0.20).clamp(0.0, 1.0);

        final shimmerHighlight = widget.isDark
            ? AppColors.softBlush.withValues(alpha: 0.85)
            : AppColors.dustyRose.withValues(alpha: 0.65);
        final baseColor =
            widget.isDark ? AppColors.ivory : AppColors.deepPlum;

        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              baseColor,
              shimmerHighlight,
              baseColor,
            ],
            stops: [left, center, right],
          ).createShader(bounds),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
