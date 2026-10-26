import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/responsive/responsive_utils.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/url_launcher_web.dart';
import '../../../../core/widgets/brand_icons.dart';
import '../../../../l10n/generated/app_localizations.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Contact Section — Modern Editorial Asymmetric Showcase
// ─────────────────────────────────────────────────────────────────────────────

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  static const String fullName = 'Romisaa Mohamed Fadel';
  static const String email = 'romisaafadel982@gmail.com';
  static const String phone = '+201015917674';
  static const String linkedInUrl = 'https://www.linkedin.com/in/romisaafadel';
  static const String gitHubUrl = 'https://github.com/romisaa5';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = context.isWide;
    final isCompact = context.isCompact;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Asymmetric Two-Part Composition on Desktop
        if (isDesktop)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Editorial Intro & Narrative (42% width)
              Expanded(
                flex: 5,
                child: _ContactEditorialIntro(
                  isDark: isDark,
                  isCompact: isCompact,
                  isArabic: isArabic,
                  l10n: l10n,
                ),
              ),

              const SizedBox(width: 44),

              // Right Contact Channels Grid (58% width)
              Expanded(
                flex: 7,
                child: _ContactChannelsGrid(
                  isDark: isDark,
                  isCompact: isCompact,
                  isArabic: isArabic,
                  l10n: l10n,
                ),
              ),
            ],
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ContactEditorialIntro(
                isDark: isDark,
                isCompact: isCompact,
                isArabic: isArabic,
                l10n: l10n,
              ),
              const SizedBox(height: 32),
              _ContactChannelsGrid(
                isDark: isDark,
                isCompact: isCompact,
                isArabic: isArabic,
                l10n: l10n,
              ),
            ],
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Editorial Intro Column (Header, Narrative & Direct Action)
// ─────────────────────────────────────────────────────────────────────────────

class _ContactEditorialIntro extends StatelessWidget {
  const _ContactEditorialIntro({
    required this.isDark,
    required this.isCompact,
    required this.isArabic,
    required this.l10n,
  });

  final bool isDark;
  final bool isCompact;
  final bool isArabic;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final primaryTextColor = isDark ? AppColors.ivory : AppColors.deepPlum;
    final secondaryTextColor = isDark
        ? AppColors.ivory.withValues(alpha: 0.72)
        : AppColors.deepPlum.withValues(alpha: 0.76);

    final crossAlign =
        isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final textAlign = isArabic ? TextAlign.right : TextAlign.left;

    return Column(
      crossAxisAlignment: crossAlign,
      children: [
        // Section Tag Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
          decoration: BoxDecoration(
            color: (isDark ? AppColors.dustyRose : AppColors.mauve)
                .withValues(alpha: isDark ? 0.14 : 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: (isDark ? AppColors.dustyRose : AppColors.mauve)
                  .withValues(alpha: 0.28),
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.alternate_email_rounded,
                size: 13,
                color: isDark ? AppColors.dustyRose : AppColors.mauve,
              ),
              const SizedBox(width: 6),
              Text(
                l10n.contactSectionTag,
                style: GoogleFonts.outfit(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                  color: isDark ? AppColors.dustyRose : AppColors.mauve,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Bold Editorial Heading
        Text(
          l10n.contactSectionHeading,
          textAlign: textAlign,
          style: GoogleFonts.outfit(
            fontSize: isCompact ? 32 : 44,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
            color: primaryTextColor,
            height: 1.12,
          ),
        ),

        const SizedBox(height: 14),

        // Narrative Subtitle
        Text(
          l10n.contactSectionSubtitle,
          textAlign: textAlign,
          style: GoogleFonts.outfit(
            fontSize: isCompact ? 14.0 : 15.5,
            fontWeight: FontWeight.w400,
            height: 1.6,
            color: secondaryTextColor,
          ),
        ),

        const SizedBox(height: 24),

        // Metadata Pills Row: Location & Availability
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: isArabic ? WrapAlignment.end : WrapAlignment.start,
          children: [
            // Location Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurface.withValues(alpha: 0.70)
                    : Colors.white.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? AppColors.darkBorder.withValues(alpha: 0.80)
                      : AppColors.lightBorder.withValues(alpha: 0.85),
                  width: 0.8,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: 14,
                    color: isDark ? AppColors.dustyRose : AppColors.mauve,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    l10n.contactLocation,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.ivory.withValues(alpha: 0.90)
                          : AppColors.deepPlum.withValues(alpha: 0.90),
                    ),
                  ),
                ],
              ),
            ),

            // Availability Badge (Active Green)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF16A34A)
                    .withValues(alpha: isDark ? 0.16 : 0.10),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF16A34A).withValues(alpha: 0.35),
                  width: 0.8,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFF16A34A),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    l10n.contactAvailabilityBadge,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? const Color(0xFF4ADE80)
                          : const Color(0xFF15803D),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 28),

        // Primary Hero Action: Send an Email
        _HeroEmailButton(
          label: l10n.contactSendEmailBtn,
          email: ContactSection.email,
          isDark: isDark,
          isArabic: isArabic,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Primary Hero Button (Send Email directly)
// ─────────────────────────────────────────────────────────────────────────────

class _HeroEmailButton extends StatefulWidget {
  const _HeroEmailButton({
    required this.label,
    required this.email,
    required this.isDark,
    required this.isArabic,
  });

  final String label;
  final String email;
  final bool isDark;
  final bool isArabic;

  @override
  State<_HeroEmailButton> createState() => _HeroEmailButtonState();
}

class _HeroEmailButtonState extends State<_HeroEmailButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final isArabic = widget.isArabic;

    final bg = _hovered
        ? (isDark ? AppColors.dustyRose : AppColors.mauve)
        : (isDark ? AppColors.ivory : AppColors.deepPlum);

    final fg = _hovered
        ? Colors.white
        : (isDark ? AppColors.deepPlum : AppColors.ivory);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        onTap: () {
          final opened = WebUrlLauncher.openGmailCompose(email: widget.email);
          Clipboard.setData(ClipboardData(text: widget.email));
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.mail_outline_rounded,
                      color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      opened
                          ? (isArabic
                              ? 'جاري فتح بريد Gmail (${widget.email})'
                              : 'Opening Gmail compose (${widget.email})')
                          : (isArabic
                              ? 'تم نسخ البريد الإلكتروني (${widget.email})'
                              : 'Email address copied (${widget.email})'),
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.mauve,
              duration: const Duration(seconds: 3),
            ),
          );
        },
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: (isDark ? AppColors.dustyRose : AppColors.deepPlum)
                    .withValues(alpha: _hovered ? 0.35 : 0.16),
                blurRadius: _hovered ? 14 : 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: isArabic
                ? [
                    Icon(Icons.send_rounded, size: 15, color: fg),
                    const SizedBox(width: 8),
                    Text(
                      widget.label,
                      style: GoogleFonts.outfit(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: fg,
                      ),
                    ),
                  ]
                : [
                    Text(
                      widget.label,
                      style: GoogleFonts.outfit(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: fg,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.send_rounded, size: 15, color: fg),
                  ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Contact Channels Grid (Email, Phone, LinkedIn, GitHub)
// ─────────────────────────────────────────────────────────────────────────────

class _ContactChannelsGrid extends StatelessWidget {
  const _ContactChannelsGrid({
    required this.isDark,
    required this.isCompact,
    required this.isArabic,
    required this.l10n,
  });

  final bool isDark;
  final bool isCompact;
  final bool isArabic;
  final AppLocalizations l10n;

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.contactCopiedSnackbar,
          style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.mauve,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final channels = [
      // 1. Email (Exact address: romisaafadel982@gmail.com)
      _ChannelData(
        title: l10n.contactEmailLabel,
        value: ContactSection.email,
        icon: const Icon(Icons.mail_outline_rounded, size: 19),
        actionLabel: l10n.contactSendEmailBtn,
        onAction: () {
          final opened =
              WebUrlLauncher.openGmailCompose(email: ContactSection.email);
          Clipboard.setData(const ClipboardData(text: ContactSection.email));
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.mail_outline_rounded,
                      color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      opened
                          ? (isArabic
                              ? 'جاري فتح بريد Gmail (${ContactSection.email})'
                              : 'Opening Gmail compose (${ContactSection.email})')
                          : (isArabic
                              ? 'تم نسخ البريد الإلكتروني (${ContactSection.email})'
                              : 'Email address copied (${ContactSection.email})'),
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.mauve,
              duration: const Duration(seconds: 3),
            ),
          );
        },
        onCopy: () => _copyToClipboard(context, ContactSection.email),
        accentColor: isDark ? AppColors.dustyRose : AppColors.mauve,
      ),

      // 2. Phone / WhatsApp (+201015917674)
      _ChannelData(
        title: l10n.contactPhoneLabel,
        value: ContactSection.phone,
        icon: const Icon(Icons.phone_outlined, size: 19),
        actionLabel: l10n.contactCallBtn,
        onAction: () => WebUrlLauncher.dialPhone(ContactSection.phone),
        onCopy: () => _copyToClipboard(context, ContactSection.phone),
        accentColor: const Color(0xFF16A34A),
      ),

      // 3. LinkedIn
      _ChannelData(
        title: l10n.contactLinkedInLabel,
        value: 'romisaafadel',
        icon: const BrandIcon.linkedIn(size: 19),
        actionLabel: l10n.contactViewProfileBtn,
        onAction: () => WebUrlLauncher.openUrl(ContactSection.linkedInUrl),
        accentColor: const Color(0xFF0A66C2),
      ),

      // 4. GitHub
      _ChannelData(
        title: l10n.contactGitHubLabel,
        value: 'romisaa5',
        icon: const BrandIcon.github(size: 19),
        actionLabel: l10n.contactViewGithubBtn,
        onAction: () => WebUrlLauncher.openUrl(ContactSection.gitHubUrl),
        accentColor: isDark ? AppColors.ivory : AppColors.deepPlum,
      ),
    ];

    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: channels.map((c) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 14.0),
            child: _ChannelCard(
              channel: c,
              isDark: isDark,
              isArabic: isArabic,
              l10n: l10n,
            ),
          );
        }).toList(),
      );
    }

    // Balanced 2x2 Grid on desktop & tablet
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: _ChannelCard(
                channel: channels[0],
                isDark: isDark,
                isArabic: isArabic,
                l10n: l10n,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _ChannelCard(
                channel: channels[1],
                isDark: isDark,
                isArabic: isArabic,
                l10n: l10n,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _ChannelCard(
                channel: channels[2],
                isDark: isDark,
                isArabic: isArabic,
                l10n: l10n,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _ChannelCard(
                channel: channels[3],
                isDark: isDark,
                isArabic: isArabic,
                l10n: l10n,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ChannelData {
  const _ChannelData({
    required this.title,
    required this.value,
    required this.icon,
    required this.actionLabel,
    required this.onAction,
    this.onCopy,
    required this.accentColor,
  });

  final String title;
  final String value;
  final Widget icon;
  final String actionLabel;
  final VoidCallback onAction;
  final VoidCallback? onCopy;
  final Color accentColor;
}

class _ChannelCard extends StatefulWidget {
  const _ChannelCard({
    required this.channel,
    required this.isDark,
    required this.isArabic,
    required this.l10n,
  });

  final _ChannelData channel;
  final bool isDark;
  final bool isArabic;
  final AppLocalizations l10n;

  @override
  State<_ChannelCard> createState() => _ChannelCardState();
}

class _ChannelCardState extends State<_ChannelCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.channel;
    final isDark = widget.isDark;
    final isArabic = widget.isArabic;
    final l10n = widget.l10n;

    final primaryTextColor = isDark ? AppColors.ivory : AppColors.deepPlum;
    final bodyTextColor = isDark
        ? AppColors.ivory.withValues(alpha: 0.70)
        : AppColors.deepPlum.withValues(alpha: 0.75);

    final cardBg = isDark
        ? AppColors.darkSurface.withValues(alpha: _hovered ? 0.90 : 0.75)
        : Colors.white.withValues(alpha: _hovered ? 0.96 : 0.88);

    final borderColor = _hovered
        ? c.accentColor.withValues(alpha: 0.60)
        : (isDark
            ? AppColors.darkBorder.withValues(alpha: 0.80)
            : AppColors.lightBorder.withValues(alpha: 0.85));

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _hovered ? -2.5 : 0.0, 0),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: _hovered ? 1.2 : 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.16 : 0.03),
              blurRadius: _hovered ? 14 : 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Row: Channel Icon + Quick Copy Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: isArabic
                  ? [
                      if (c.onCopy != null)
                        Tooltip(
                          message: l10n.contactCopyTooltip,
                          child: InkWell(
                            onTap: c.onCopy,
                            borderRadius: BorderRadius.circular(7),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.copy_rounded,
                                size: 15,
                                color: bodyTextColor,
                              ),
                            ),
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: c.accentColor
                              .withValues(alpha: isDark ? 0.15 : 0.10),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: IconTheme(
                            data: IconThemeData(
                              color: c.accentColor,
                              size: 18,
                            ),
                            child: c.icon,
                          ),
                        ),
                      ),
                    ]
                  : [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: c.accentColor
                              .withValues(alpha: isDark ? 0.15 : 0.10),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: IconTheme(
                            data: IconThemeData(
                              color: c.accentColor,
                              size: 18,
                            ),
                            child: c.icon,
                          ),
                        ),
                      ),
                      if (c.onCopy != null)
                        Tooltip(
                          message: l10n.contactCopyTooltip,
                          child: InkWell(
                            onTap: c.onCopy,
                            borderRadius: BorderRadius.circular(7),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.copy_rounded,
                                size: 15,
                                color: bodyTextColor,
                              ),
                            ),
                          ),
                        ),
                    ],
            ),

            const SizedBox(height: 12),

            // Channel Label
            Text(
              c.title,
              style: GoogleFonts.outfit(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: bodyTextColor,
              ),
            ),

            const SizedBox(height: 3),

            // Channel Value
            SelectableText(
              c.value,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              style: GoogleFonts.outfit(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: primaryTextColor,
              ),
            ),

            const SizedBox(height: 12),

            // Direct Action Link
            InkWell(
              onTap: c.onAction,
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: isArabic
                      ? [
                          Icon(
                            Icons.arrow_back_rounded,
                            size: 12,
                            color: c.accentColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            c.actionLabel,
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: c.accentColor,
                            ),
                          ),
                        ]
                      : [
                          Text(
                            c.actionLabel,
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: c.accentColor,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 12,
                            color: c.accentColor,
                          ),
                        ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
