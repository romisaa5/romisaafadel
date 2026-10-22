import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/responsive/responsive_utils.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/url_launcher_web.dart';
import '../../../../core/widgets/brand_icons.dart';
import '../../../../l10n/generated/app_localizations.dart';

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
        ? AppColors.darkBackground.withValues(alpha: 0.95)
        : const Color(0xFFF3ECEF);

    final borderColor = isDark
        ? AppColors.darkBorder.withValues(alpha: 0.70)
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
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: isCompact ? 36.0 : 48.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── 1. Top Row: Brand & Quick Navigation ──────────────────
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Brand & Description
                    Expanded(
                      flex: 4,
                      child: _buildBrandBlock(
                        l10n,
                        isDark,
                        isArabic,
                        primaryTextColor,
                        bodyTextColor,
                      ),
                    ),

                    const SizedBox(width: 48),

                    // Quick Navigation
                    Expanded(
                      flex: 4,
                      child: _buildQuickLinksBlock(
                        l10n,
                        isDark,
                        isArabic,
                        primaryTextColor,
                        bodyTextColor,
                      ),
                    ),

                    const SizedBox(width: 32),

                    // Connect & Socials
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
                  crossAxisAlignment:
                      isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    _buildBrandBlock(
                      l10n,
                      isDark,
                      isArabic,
                      primaryTextColor,
                      bodyTextColor,
                    ),
                    const SizedBox(height: 32),
                    _buildQuickLinksBlock(
                      l10n,
                      isDark,
                      isArabic,
                      primaryTextColor,
                      bodyTextColor,
                    ),
                    const SizedBox(height: 32),
                    _buildSocialsBlock(
                      l10n,
                      isDark,
                      isArabic,
                      primaryTextColor,
                      bodyTextColor,
                    ),
                  ],
                ),

              const SizedBox(height: 40),

              // ── 2. Subtle Divider ─────────────────────────────────────
              Divider(
                color: borderColor,
                height: 1,
                thickness: 0.8,
              ),

              const SizedBox(height: 24),

              // ── 3. Bottom Row: Copyright + Back to Top ────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Copyright
                  Expanded(
                    child: Text(
                      l10n.footerCopyright(currentYear),
                      textAlign: isArabic ? TextAlign.right : TextAlign.left,
                      style: GoogleFonts.outfit(
                        fontSize: 12.5,
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.footerBackToTop,
                            style: GoogleFonts.outfit(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.dustyRose : AppColors.mauve,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.keyboard_arrow_up_rounded,
                            size: 16,
                            color: isDark ? AppColors.dustyRose : AppColors.mauve,
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
        // Logo + Name
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
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => Text(
                      'RF',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.dustyRose : AppColors.mauve,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                l10n.displayName,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                  color: primaryTextColor,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Tagline
        Text(
          l10n.footerTagline,
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
          style: GoogleFonts.outfit(
            fontSize: 13.5,
            fontWeight: FontWeight.w400,
            height: 1.55,
            color: bodyTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickLinksBlock(
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
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: primaryTextColor,
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 16,
          runSpacing: 10,
          alignment: isArabic ? WrapAlignment.end : WrapAlignment.start,
          children: links.map((link) {
            final (title, onTap) = link;
            return _FooterLinkText(
              title: title,
              onTap: onTap,
              isDark: isDark,
            );
          }).toList(),
        ),
      ],
    );
  }

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
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: primaryTextColor,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // GitHub
            _SocialIconButton(
              icon: const BrandIcon.github(size: 18),
              tooltip: 'GitHub — @romisaa5',
              onTap: () => WebUrlLauncher.openUrl(gitHubUrl),
              isDark: isDark,
            ),
            const SizedBox(width: 10),

            // LinkedIn
            _SocialIconButton(
              icon: const BrandIcon.linkedIn(size: 18),
              tooltip: 'LinkedIn — Romisaa Fadel',
              onTap: () => WebUrlLauncher.openUrl(linkedInUrl),
              isDark: isDark,
            ),
            const SizedBox(width: 10),

            // Email
            _SocialIconButton(
              icon: const Icon(Icons.mail_outline_rounded, size: 18),
              tooltip: email,
              onTap: () => WebUrlLauncher.sendEmail(email),
              isDark: isDark,
            ),
          ],
        ),
      ],
    );
  }
}

class _FooterLinkText extends StatefulWidget {
  const _FooterLinkText({
    required this.title,
    required this.onTap,
    required this.isDark,
  });

  final String title;
  final VoidCallback onTap;
  final bool isDark;

  @override
  State<_FooterLinkText> createState() => _FooterLinkTextState();
}

class _FooterLinkTextState extends State<_FooterLinkText> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final color = _hovered
        ? (isDark ? AppColors.dustyRose : AppColors.mauve)
        : (isDark
            ? AppColors.ivory.withValues(alpha: 0.70)
            : AppColors.deepPlum.withValues(alpha: 0.70));

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 180),
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: _hovered ? FontWeight.w600 : FontWeight.w400,
            color: color,
          ),
          child: Text(widget.title),
        ),
      ),
    );
  }
}

class _SocialIconButton extends StatefulWidget {
  const _SocialIconButton({
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
  State<_SocialIconButton> createState() => _SocialIconButtonState();
}

class _SocialIconButtonState extends State<_SocialIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final bg = _hovered
        ? (isDark ? AppColors.dustyRose : AppColors.mauve)
        : (isDark
            ? AppColors.darkSurface.withValues(alpha: 0.8)
            : Colors.white.withValues(alpha: 0.85));

    final fg = _hovered
        ? Colors.white
        : (isDark ? AppColors.ivory : AppColors.deepPlum);

    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: (isDark ? AppColors.darkBorder : AppColors.lightBorder)
                    .withValues(alpha: 0.7),
                width: 0.8,
              ),
            ),
            child: Center(
              child: IconTheme(
                data: IconThemeData(color: fg, size: 18),
                child: widget.icon,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
