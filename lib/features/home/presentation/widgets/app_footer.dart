import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/responsive/responsive_utils.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/url_launcher_web.dart';
import '../../../../core/widgets/brand_icons.dart';
import '../../../../l10n/generated/app_localizations.dart';

// ─────────────────────────────────────────────────────────────────────────────
// App Footer — Premium, Compact, Editorial Conclusion
// ─────────────────────────────────────────────────────────────────────────────

class AppFooter extends StatelessWidget {
  const AppFooter({
    super.key,
    required this.onHome,
    required this.onAbout,
    required this.onSkills,
    required this.onExperience,
    required this.onProjects,
    required this.onContact,
  });

  final VoidCallback onHome;
  final VoidCallback onAbout;
  final VoidCallback onSkills;
  final VoidCallback onExperience;
  final VoidCallback onProjects;
  final VoidCallback onContact;

  static const String email = 'romisaafadel982@gmail.com';
  static const String linkedInUrl = 'https://www.linkedin.com/in/romisaafadel';
  static const String gitHubUrl = 'https://github.com/romisaa5';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = context.isWide;
    final isCompact = context.isCompact;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final currentYear = DateTime.now().year.toString();
    final hPad = isCompact ? 24.0 : (isDesktop ? 64.0 : 40.0);

    final footerBg = isDark
        ? const Color(0xFF140D15) // Deep Plum night
        : const Color(0xFFF4EDF1);

    final borderColor = isDark
        ? AppColors.darkBorder.withValues(alpha: 0.60)
        : AppColors.lightBorder.withValues(alpha: 0.85);

    final primaryTextColor = isDark ? AppColors.ivory : AppColors.deepPlum;
    final bodyTextColor = isDark
        ? AppColors.ivory.withValues(alpha: 0.65)
        : AppColors.deepPlum.withValues(alpha: 0.70);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: footerBg,
        border: Border(
          top: BorderSide(color: borderColor, width: 1.0),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: hPad,
        vertical: isCompact ? 32.0 : 40.0,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1300),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── 1. Top Content Row ───────────────────────────────────────
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left: Brand, Title & Tagline
                    Expanded(
                      flex: 5,
                      child: _buildBrandBlock(
                        l10n,
                        isDark,
                        isArabic,
                        primaryTextColor,
                        bodyTextColor,
                      ),
                    ),

                    const SizedBox(width: 48),

                    // Center: Compact Section Navigation
                    Expanded(
                      flex: 4,
                      child: _buildNavigationBlock(
                        l10n,
                        isDark,
                        isArabic,
                        primaryTextColor,
                        bodyTextColor,
                      ),
                    ),

                    const SizedBox(width: 32),

                    // Right: Social Profiles & Direct Email
                    Expanded(
                      flex: 3,
                      child: _buildSocialsBlock(
                        l10n,
                        isDark,
                        isArabic,
                        primaryTextColor,
                        bodyTextColor,
                      ),
                    ),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: isArabic
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    _buildBrandBlock(
                      l10n,
                      isDark,
                      isArabic,
                      primaryTextColor,
                      bodyTextColor,
                    ),
                    const SizedBox(height: 28),
                    _buildNavigationBlock(
                      l10n,
                      isDark,
                      isArabic,
                      primaryTextColor,
                      bodyTextColor,
                    ),
                    const SizedBox(height: 28),
                    _buildSocialsBlock(
                      l10n,
                      isDark,
                      isArabic,
                      primaryTextColor,
                      bodyTextColor,
                    ),
                  ],
                ),

              const SizedBox(height: 32),

              // ── 2. Subtle Divider ─────────────────────────────────────────
              Divider(
                color: borderColor,
                height: 1,
                thickness: 0.8,
              ),

              const SizedBox(height: 20),

              // ── 3. Bottom Row: Dynamic Copyright + Back to Top ────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Copyright
                  Expanded(
                    child: Text(
                      l10n.footerCopyright(currentYear),
                      textAlign: isArabic ? TextAlign.right : TextAlign.left,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: bodyTextColor,
                      ),
                    ),
                  ),

                  // Back to Top Button
                  InkWell(
                    onTap: onHome,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: isArabic
                            ? [
                                Icon(
                                  Icons.keyboard_arrow_up_rounded,
                                  size: 16,
                                  color: isDark
                                      ? AppColors.dustyRose
                                      : AppColors.mauve,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  l10n.footerBackToTop,
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? AppColors.dustyRose
                                        : AppColors.mauve,
                                  ),
                                ),
                              ]
                            : [
                                Text(
                                  l10n.footerBackToTop,
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? AppColors.dustyRose
                                        : AppColors.mauve,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Icon(
                                  Icons.keyboard_arrow_up_rounded,
                                  size: 16,
                                  color: isDark
                                      ? AppColors.dustyRose
                                      : AppColors.mauve,
                                ),
                              ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Brand Column ───────────────────────────────────────────────────────────

  Widget _buildBrandBlock(
    AppLocalizations l10n,
    bool isDark,
    bool isArabic,
    Color primaryTextColor,
    Color bodyTextColor,
  ) {
    return Column(
      crossAxisAlignment:
          isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        // Monogram + Display Name
        InkWell(
          onTap: onHome,
          borderRadius: BorderRadius.circular(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.dustyRose : AppColors.mauve)
                      .withValues(alpha: isDark ? 0.18 : 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: (isDark ? AppColors.dustyRose : AppColors.mauve)
                        .withValues(alpha: 0.35),
                    width: 0.9,
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 18,
                    height: 18,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => Text(
                      'RF',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.dustyRose : AppColors.mauve,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Romisaa Fadel',
                style: GoogleFonts.outfit(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                  color: primaryTextColor,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Concise Tagline
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Text(
            l10n.footerTagline,
            textAlign: isArabic ? TextAlign.right : TextAlign.left,
            style: GoogleFonts.outfit(
              fontSize: 12.5,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: bodyTextColor,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Flutter Craft Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: (isDark ? AppColors.dustyRose : AppColors.mauve)
                .withValues(alpha: isDark ? 0.10 : 0.06),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.flutter_dash_rounded,
                size: 13,
                color: Color(0xFF02569B),
              ),
              const SizedBox(width: 6),
              Text(
                'Engineered with Flutter Web',
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.dustyRose : AppColors.mauve,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Navigation Column ──────────────────────────────────────────────────────

  Widget _buildNavigationBlock(
    AppLocalizations l10n,
    bool isDark,
    bool isArabic,
    Color primaryTextColor,
    Color bodyTextColor,
  ) {
    final links = [
      (l10n.navHome, onHome),
      (l10n.navAbout, onAbout),
      (l10n.navSkills, onSkills),
      (l10n.navExperience, onExperience),
      (l10n.navProjects, onProjects),
      (l10n.navContact, onContact),
    ];

    return Column(
      crossAxisAlignment:
          isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          l10n.footerQuickLinksTitle,
          style: GoogleFonts.outfit(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: primaryTextColor,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          alignment: isArabic ? WrapAlignment.end : WrapAlignment.start,
          children: links.map((link) {
            return _FooterNavLink(
              label: link.$1,
              onTap: link.$2,
              isDark: isDark,
              bodyTextColor: bodyTextColor,
            );
          }).toList(),
        ),
      ],
    );
  }

  // ── Socials Column ─────────────────────────────────────────────────────────

  Widget _buildSocialsBlock(
    AppLocalizations l10n,
    bool isDark,
    bool isArabic,
    Color primaryTextColor,
    Color bodyTextColor,
  ) {
    return Column(
      crossAxisAlignment:
          isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          l10n.footerSocialsTitle,
          style: GoogleFonts.outfit(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: primaryTextColor,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: isArabic ? WrapAlignment.end : WrapAlignment.start,
          children: [
            // GitHub
            _FooterSocialButton(
              icon: const BrandIcon.github(size: 15),
              tooltip: 'GitHub (romisaa5)',
              onTap: () => WebUrlLauncher.openUrl(gitHubUrl),
              isDark: isDark,
            ),

            // LinkedIn
            _FooterSocialButton(
              icon: const BrandIcon.linkedIn(size: 15),
              tooltip: 'LinkedIn (romisaafadel)',
              onTap: () => WebUrlLauncher.openUrl(linkedInUrl),
              isDark: isDark,
            ),

            // Email
            _FooterSocialButton(
              icon: const Icon(Icons.mail_outline_rounded, size: 15),
              tooltip: 'Email (romisaafadel982@gmail.com)',
              onTap: () => WebUrlLauncher.sendEmail(email),
              isDark: isDark,
            ),
          ],
        ),
      ],
    );
  }
}

class _FooterNavLink extends StatefulWidget {
  const _FooterNavLink({
    required this.label,
    required this.onTap,
    required this.isDark,
    required this.bodyTextColor,
  });

  final String label;
  final VoidCallback onTap;
  final bool isDark;
  final Color bodyTextColor;

  @override
  State<_FooterNavLink> createState() => _FooterNavLinkState();
}

class _FooterNavLinkState extends State<_FooterNavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final activeColor =
        widget.isDark ? AppColors.dustyRose : AppColors.mauve;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: _hovered ? FontWeight.w600 : FontWeight.w400,
            color: _hovered ? activeColor : widget.bodyTextColor,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}

class _FooterSocialButton extends StatefulWidget {
  const _FooterSocialButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    required this.isDark,
  });

  final Widget icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool isDark;

  @override
  State<_FooterSocialButton> createState() => _FooterSocialButtonState();
}

class _FooterSocialButtonState extends State<_FooterSocialButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final activeColor =
        widget.isDark ? AppColors.dustyRose : AppColors.mauve;

    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: widget.isDark
                  ? (_hovered
                      ? AppColors.darkSurface
                      : AppColors.darkSurface.withValues(alpha: 0.55))
                  : (_hovered ? Colors.white : Colors.white.withValues(alpha: 0.70)),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _hovered
                    ? activeColor.withValues(alpha: 0.5)
                    : (widget.isDark
                        ? AppColors.darkBorder.withValues(alpha: 0.7)
                        : AppColors.lightBorder.withValues(alpha: 0.7)),
                width: 0.8,
              ),
            ),
            child: Center(
              child: IconTheme(
                data: IconThemeData(
                  color: _hovered
                      ? activeColor
                      : (widget.isDark
                          ? AppColors.ivory.withValues(alpha: 0.8)
                          : AppColors.deepPlum.withValues(alpha: 0.8)),
                  size: 15,
                ),
                child: widget.icon,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
