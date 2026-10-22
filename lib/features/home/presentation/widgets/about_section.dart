import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/responsive/responsive_utils.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// About Me Section — Chapter 01 of the portfolio narrative.
///
/// Composition:
///   • Section Header: Monospaced tag + Expressive Italic Serif Headline + Full-width accent rule.
///   • Left Column: Narrative storytelling (Philosophy, Background, Mentorship, Engineering Pillars).
///   • Right Column: Interactive 4-card Bento grid (Experience, Education, Architecture, Community).
class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isDesktop = context.isWide;

    final primaryTextColor = isDark ? AppColors.ivory : AppColors.deepPlum;
    final secondaryTextColor = isDark
        ? AppColors.dustyRose.withValues(alpha: 0.90)
        : AppColors.mauve.withValues(alpha: 0.90);
    final bodyTextColor = isDark
        ? AppColors.ivory.withValues(alpha: 0.78)
        : AppColors.deepPlum.withValues(alpha: 0.78);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── 1. Section Header ──────────────────────────────────────────
        _SectionHeader(
          number: l10n.aboutSectionNumber,
          tag: l10n.aboutSectionTag,
          headline: l10n.aboutHeadline,
          isDark: isDark,
          isArabic: isArabic,
        ),

        const SizedBox(height: 48),

        // ── 2. Content: Two Columns on Desktop, Stacked on Mobile ───────
        if (isDesktop)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Story & Narrative
              Expanded(
                flex: 52,
                child: _AboutNarrative(
                  l10n: l10n,
                  isDark: isDark,
                  isArabic: isArabic,
                  primaryColor: primaryTextColor,
                  bodyColor: bodyTextColor,
                  accentColor: secondaryTextColor,
                ),
              ),
              const SizedBox(width: 54),
              // Bento Credentials Grid
              Expanded(
                flex: 48,
                child: _AboutBentoGrid(
                  l10n: l10n,
                  isDark: isDark,
                  isArabic: isArabic,
                ),
              ),
            ],
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _AboutNarrative(
                l10n: l10n,
                isDark: isDark,
                isArabic: isArabic,
                primaryColor: primaryTextColor,
                bodyColor: bodyTextColor,
                accentColor: secondaryTextColor,
              ),
              const SizedBox(height: 40),
              _AboutBentoGrid(
                l10n: l10n,
                isDark: isDark,
                isArabic: isArabic,
              ),
            ],
          ),

        const SizedBox(height: 64),

        // ── Architectural Section Separator ────────────────────────────
        _SectionDivider(isDark: isDark),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section Header with number, tag, italic serif headline, and horizontal rule
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.number,
    required this.tag,
    required this.headline,
    required this.isDark,
    required this.isArabic,
  });

  final String number;
  final String tag;
  final String headline;
  final bool isDark;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final accentColor = isDark ? AppColors.dustyRose : AppColors.mauve;
    final primaryTextColor = isDark ? AppColors.ivory : AppColors.deepPlum;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tag with index
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: (isDark ? AppColors.mauve : AppColors.softBlush)
                    .withValues(alpha: isDark ? 0.28 : 0.45),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isDark
                      ? AppColors.darkBorder
                      : AppColors.lightBorder.withValues(alpha: 0.8),
                  width: 0.8,
                ),
              ),
              child: Text(
                '$number // $tag',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                  color: accentColor,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        // Expressive headline + horizontal rule
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                headline,
                style: isArabic
                    ? GoogleFonts.amiri(
                        fontSize: 34.0,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        color: primaryTextColor,
                        height: 1.25,
                      )
                    : GoogleFonts.dmSerifDisplay(
                        fontSize: 36.0,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic,
                        color: primaryTextColor,
                        letterSpacing: -0.5,
                        height: 1.15,
                      ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Container(
                height: 1.0,
                color: isDark
                    ? AppColors.dustyRose.withValues(alpha: 0.15)
                    : AppColors.mauve.withValues(alpha: 0.18),
                margin: const EdgeInsets.only(bottom: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// About Narrative & Core Pillars
// ─────────────────────────────────────────────────────────────────────────────

class _AboutNarrative extends StatelessWidget {
  const _AboutNarrative({
    required this.l10n,
    required this.isDark,
    required this.isArabic,
    required this.primaryColor,
    required this.bodyColor,
    required this.accentColor,
  });

  final AppLocalizations l10n;
  final bool isDark;
  final bool isArabic;
  final Color primaryColor;
  final Color bodyColor;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Lead statement
        Text(
          l10n.aboutLead,
          style: GoogleFonts.outfit(
            fontSize: 19.0,
            fontWeight: FontWeight.w500,
            color: primaryColor,
            height: 1.60,
            letterSpacing: 0.1,
          ),
        ),

        const SizedBox(height: 20),

        // Detailed bio
        Text(
          l10n.aboutBio,
          style: GoogleFonts.outfit(
            fontSize: 15.5,
            fontWeight: FontWeight.w400,
            color: bodyColor,
            height: 1.80,
            letterSpacing: 0.15,
          ),
        ),

        const SizedBox(height: 16),

        // Community & Mentorship focus
        Text(
          l10n.aboutMentorship,
          style: GoogleFonts.outfit(
            fontSize: 15.5,
            fontWeight: FontWeight.w400,
            color: bodyColor,
            height: 1.80,
            letterSpacing: 0.15,
          ),
        ),

        const SizedBox(height: 28),

        // Three Engineering Values Pillars
        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: [
            _PillarChip(
              icon: Icons.layers_outlined,
              label: isArabic ? 'معمارية نظيفة وقابلة للتوسع' : 'Clean & Scalable Architecture',
              isDark: isDark,
            ),
            _PillarChip(
              icon: Icons.speed_rounded,
              label: isArabic ? 'أداء عالي وسلاسة 60 إطار' : 'High-Performance 60fps UX',
              isDark: isDark,
            ),
            _PillarChip(
              icon: Icons.groups_outlined,
              label: isArabic ? 'إرشاد ومشاركة المعرفة' : 'Mentorship & Community Sharing',
              isDark: isDark,
            ),
          ],
        ),
      ],
    );
  }
}

class _PillarChip extends StatelessWidget {
  const _PillarChip({
    required this.icon,
    required this.label,
    required this.isDark,
  });

  final IconData icon;
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceVariant.withValues(alpha: 0.40)
            : AppColors.softBlush.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorder
              : AppColors.lightBorder.withValues(alpha: 0.65),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isDark ? AppColors.dustyRose : AppColors.mauve,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 13.0,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.ivory : AppColors.deepPlum,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Interactive Bento Credentials Grid (4 Cards)
// ─────────────────────────────────────────────────────────────────────────────

class _AboutBentoGrid extends StatelessWidget {
  const _AboutBentoGrid({
    required this.l10n,
    required this.isDark,
    required this.isArabic,
  });

  final AppLocalizations l10n;
  final bool isDark;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 460;

        if (isNarrow) {
          return Column(
            children: [
              _BentoCard(
                title: l10n.aboutCardExpTitle,
                subtitle: l10n.aboutCardExpSub,
                icon: Icons.code_rounded,
                isDark: isDark,
                accentBadge: 'Production Experience',
              ),
              const SizedBox(height: 14),
              _BentoCard(
                title: l10n.aboutCardEduTitle,
                subtitle: l10n.aboutCardEduSub,
                icon: Icons.school_outlined,
                isDark: isDark,
                accentBadge: 'Academic Degree',
              ),
              const SizedBox(height: 14),
              _BentoCard(
                title: l10n.aboutCardArchTitle,
                subtitle: l10n.aboutCardArchSub,
                icon: Icons.architecture_rounded,
                isDark: isDark,
                accentBadge: 'Core Discipline',
              ),
              const SizedBox(height: 14),
              _BentoCard(
                title: l10n.aboutCardCommunityTitle,
                subtitle: l10n.aboutCardCommunitySub,
                icon: Icons.volunteer_activism_outlined,
                isDark: isDark,
                accentBadge: 'Leadership & Sharing',
              ),
            ],
          );
        }

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _BentoCard(
                    title: l10n.aboutCardExpTitle,
                    subtitle: l10n.aboutCardExpSub,
                    icon: Icons.code_rounded,
                    isDark: isDark,
                    accentBadge: 'Experience',
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _BentoCard(
                    title: l10n.aboutCardEduTitle,
                    subtitle: l10n.aboutCardEduSub,
                    icon: Icons.school_outlined,
                    isDark: isDark,
                    accentBadge: 'Education',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _BentoCard(
                    title: l10n.aboutCardArchTitle,
                    subtitle: l10n.aboutCardArchSub,
                    icon: Icons.architecture_rounded,
                    isDark: isDark,
                    accentBadge: 'Architecture',
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _BentoCard(
                    title: l10n.aboutCardCommunityTitle,
                    subtitle: l10n.aboutCardCommunitySub,
                    icon: Icons.volunteer_activism_outlined,
                    isDark: isDark,
                    accentBadge: 'Mentorship',
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _BentoCard extends StatefulWidget {
  const _BentoCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isDark,
    required this.accentBadge,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool isDark;
  final String accentBadge;

  @override
  State<_BentoCard> createState() => _BentoCardState();
}

class _BentoCardState extends State<_BentoCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;

    final bgColor = isDark
        ? AppColors.darkSurface.withValues(alpha: 0.75)
        : Colors.white.withValues(alpha: 0.80);

    final borderColor = _hovered
        ? (isDark ? AppColors.dustyRose : AppColors.mauve)
        : (isDark
            ? AppColors.darkBorder
            : AppColors.lightBorder.withValues(alpha: 0.70));

    final iconBg = isDark
        ? AppColors.darkSurfaceVariant
        : const Color(0xFFF0E8ED);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0.0, _hovered ? -3.0 : 0.0, 0.0),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: (isDark ? Colors.black : AppColors.deepPlum).withValues(
                alpha: _hovered ? (isDark ? 0.35 : 0.08) : (isDark ? 0.15 : 0.03),
              ),
              blurRadius: _hovered ? 20 : 10,
              offset: Offset(0, _hovered ? 8 : 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder.withValues(alpha: 0.6),
                      width: 0.8,
                    ),
                  ),
                  child: Icon(
                    widget.icon,
                    size: 20,
                    color: isDark ? AppColors.dustyRose : AppColors.mauve,
                  ),
                ),
                Text(
                  widget.accentBadge.toUpperCase(),
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                    color: isDark
                        ? AppColors.dustyRose.withValues(alpha: 0.65)
                        : AppColors.mauve.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              widget.title,
              style: GoogleFonts.outfit(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.ivory : AppColors.deepPlum,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.subtitle,
              style: GoogleFonts.outfit(
                fontSize: 13.5,
                fontWeight: FontWeight.w400,
                color: isDark
                    ? AppColors.ivory.withValues(alpha: 0.68)
                    : AppColors.deepPlum.withValues(alpha: 0.68),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Architectural Section Divider with center dot
// ─────────────────────────────────────────────────────────────────────────────

class _SectionDivider extends StatelessWidget {
  const _SectionDivider({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final lineColor = isDark
        ? AppColors.dustyRose.withValues(alpha: 0.12)
        : AppColors.mauve.withValues(alpha: 0.14);

    final dotColor = isDark
        ? AppColors.softBlush.withValues(alpha: 0.50)
        : AppColors.deepPlum.withValues(alpha: 0.45);

    return Row(
      children: [
        Expanded(child: Container(height: 0.8, color: lineColor)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
        ),
        Expanded(child: Container(height: 0.8, color: lineColor)),
      ],
    );
  }
}
