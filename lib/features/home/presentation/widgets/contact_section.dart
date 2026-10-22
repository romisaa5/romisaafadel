import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/responsive/responsive_utils.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/url_launcher_web.dart';
import '../../../../core/widgets/brand_icons.dart';
import '../../../../l10n/generated/app_localizations.dart';

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
        // ── 1. Section Header ──────────────────────────────────────────
        _buildSectionHeader(l10n, isDark, isDesktop, isCompact, isArabic),

        const SizedBox(height: 44),

        // ── 2. Content Layout: Editorial Profile + Contact Channels ─────
        if (isDesktop)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Invitation & Overview Card
              Expanded(
                flex: 5,
                child: _InvitationCard(
                  isDark: isDark,
                  isCompact: isCompact,
                  isArabic: isArabic,
                  l10n: l10n,
                ),
              ),

              const SizedBox(width: 32),

              // Right: Contact Channels Grid (2x2)
              Expanded(
                flex: 6,
                child: _ChannelsGrid(
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
              _InvitationCard(
                isDark: isDark,
                isCompact: isCompact,
                isArabic: isArabic,
                l10n: l10n,
              ),
              const SizedBox(height: 28),
              _ChannelsGrid(
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

  Widget _buildSectionHeader(
    AppLocalizations l10n,
    bool isDark,
    bool isDesktop,
    bool isCompact,
    bool isArabic,
  ) {
    final primaryTextColor = isDark ? AppColors.ivory : AppColors.deepPlum;
    final subtitleColor = isDark
        ? AppColors.ivory.withValues(alpha: 0.70)
        : AppColors.deepPlum.withValues(alpha: 0.75);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Tag Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
                size: 14,
                color: isDark ? AppColors.dustyRose : AppColors.mauve,
              ),
              const SizedBox(width: 7),
              Text(
                l10n.contactSectionTag,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: isDark ? AppColors.dustyRose : AppColors.mauve,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Main Heading
        Text(
          l10n.contactSectionHeading,
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            fontSize: isCompact ? 32 : (isDesktop ? 44 : 38),
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            color: primaryTextColor,
            height: 1.15,
          ),
        ),

        const SizedBox(height: 14),

        // Subtitle
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Text(
            l10n.contactSectionSubtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: isCompact ? 14.5 : 16.5,
              fontWeight: FontWeight.w400,
              height: 1.6,
              color: subtitleColor,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Invitation Card (Left Column)
// ─────────────────────────────────────────────────────────────────────────────

class _InvitationCard extends StatefulWidget {
  const _InvitationCard({
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
  State<_InvitationCard> createState() => _InvitationCardState();
}

class _InvitationCardState extends State<_InvitationCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final isArabic = widget.isArabic;
    final l10n = widget.l10n;

    final primaryTextColor = isDark ? AppColors.ivory : AppColors.deepPlum;
    final bodyTextColor = isDark
        ? AppColors.ivory.withValues(alpha: 0.75)
        : AppColors.deepPlum.withValues(alpha: 0.80);

    final cardBg = isDark
        ? AppColors.darkSurface.withValues(alpha: _hovered ? 0.88 : 0.72)
        : Colors.white.withValues(alpha: _hovered ? 0.95 : 0.85);

    final borderColor = _hovered
        ? (isDark ? AppColors.dustyRose : AppColors.mauve).withValues(alpha: 0.55)
        : (isDark ? AppColors.darkBorder.withValues(alpha: 0.85) : AppColors.lightBorder.withValues(alpha: 0.85));

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _hovered ? -4.0 : 0.0, 0),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor, width: _hovered ? 1.4 : 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.22 : 0.04),
              blurRadius: _hovered ? 28 : 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: EdgeInsets.all(widget.isCompact ? 24.0 : 32.0),
        child: Column(
          crossAxisAlignment:
              isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Top Row: Avatar Monogram + Location
            Row(
              mainAxisAlignment:
                  isArabic ? MainAxisAlignment.spaceBetween : MainAxisAlignment.spaceBetween,
              children: isArabic
                  ? [
                      _buildLocationPill(l10n, isDark),
                      _buildAvatarMonogram(isDark),
                    ]
                  : [
                      _buildAvatarMonogram(isDark),
                      _buildLocationPill(l10n, isDark),
                    ],
            ),

            const SizedBox(height: 22),

            // Full Name
            Text(
              ContactSection.fullName,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
                color: primaryTextColor,
              ),
            ),

            const SizedBox(height: 6),

            // Professional Title
            Text(
              'Flutter Developer',
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.dustyRose : AppColors.mauve,
              ),
            ),

            const SizedBox(height: 16),

            // Availability Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF16A34A).withValues(alpha: isDark ? 0.16 : 0.10),
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
                  const SizedBox(width: 8),
                  Text(
                    l10n.contactAvailabilityBadge,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark ? const Color(0xFF4ADE80) : const Color(0xFF15803D),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Availability Description
            Text(
              l10n.contactAvailabilityDesc,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              style: GoogleFonts.outfit(
                fontSize: 13.5,
                fontWeight: FontWeight.w400,
                height: 1.6,
                color: bodyTextColor,
              ),
            ),

            const SizedBox(height: 26),

            // Direct Primary Action: Send Email
            _PrimaryContactButton(
              label: l10n.contactSendEmailBtn,
              icon: Icons.send_rounded,
              onTap: () => WebUrlLauncher.sendEmail(
                ContactSection.email,
                subject: 'Connecting via Romisaa Portfolio',
              ),
              isDark: isDark,
              isArabic: isArabic,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarMonogram(bool isDark) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: (isDark ? AppColors.dustyRose : AppColors.mauve)
            .withValues(alpha: isDark ? 0.18 : 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (isDark ? AppColors.dustyRose : AppColors.mauve)
              .withValues(alpha: 0.35),
          width: 1.2,
        ),
      ),
      child: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 28,
          height: 28,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => Text(
            'RF',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.dustyRose : AppColors.mauve,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationPill(AppLocalizations l10n, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: (isDark ? AppColors.ivory : AppColors.deepPlum)
            .withValues(alpha: isDark ? 0.08 : 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (isDark ? AppColors.ivory : AppColors.deepPlum)
              .withValues(alpha: 0.14),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on_rounded,
            size: 13,
            color: isDark ? AppColors.dustyRose : AppColors.mauve,
          ),
          const SizedBox(width: 5),
          Text(
            l10n.contactLocation,
            style: GoogleFonts.outfit(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.ivory.withValues(alpha: 0.85)
                  : AppColors.deepPlum.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Channels Grid (Right Column: Email, Phone, LinkedIn, GitHub)
// ─────────────────────────────────────────────────────────────────────────────

class _ChannelsGrid extends StatelessWidget {
  const _ChannelsGrid({
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
          style: GoogleFonts.outfit(fontSize: 13.5, fontWeight: FontWeight.w600),
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
      // 1. Email
      _ChannelData(
        title: l10n.contactEmailLabel,
        value: ContactSection.email,
        icon: const Icon(Icons.mail_outline_rounded, size: 20),
        actionLabel: l10n.contactSendEmailBtn,
        onAction: () => WebUrlLauncher.sendEmail(ContactSection.email),
        onCopy: () => _copyToClipboard(context, ContactSection.email),
        accentColor: isDark ? AppColors.dustyRose : AppColors.mauve,
      ),

      // 2. Phone / WhatsApp
      _ChannelData(
        title: l10n.contactPhoneLabel,
        value: ContactSection.phone,
        icon: const Icon(Icons.phone_outlined, size: 20),
        actionLabel: l10n.contactCallBtn,
        onAction: () => WebUrlLauncher.dialPhone(ContactSection.phone),
        onCopy: () => _copyToClipboard(context, ContactSection.phone),
        accentColor: const Color(0xFF16A34A),
      ),

      // 3. LinkedIn
      _ChannelData(
        title: l10n.contactLinkedInLabel,
        value: 'romisaafadel',
        icon: const BrandIcon.linkedIn(size: 20),
        actionLabel: l10n.contactViewProfileBtn,
        onAction: () => WebUrlLauncher.openUrl(ContactSection.linkedInUrl),
        accentColor: const Color(0xFF0A66C2),
      ),

      // 4. GitHub
      _ChannelData(
        title: l10n.contactGitHubLabel,
        value: 'romisaa5',
        icon: const BrandIcon.github(size: 20),
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
            padding: const EdgeInsets.only(bottom: 16.0),
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

    // 2x2 Grid on tablet / desktop
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
            const SizedBox(width: 16),
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
        const SizedBox(height: 16),
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
            const SizedBox(width: 16),
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
        ? AppColors.darkSurface.withValues(alpha: _hovered ? 0.88 : 0.72)
        : Colors.white.withValues(alpha: _hovered ? 0.95 : 0.85);

    final borderColor = _hovered
        ? c.accentColor.withValues(alpha: 0.55)
        : (isDark ? AppColors.darkBorder.withValues(alpha: 0.85) : AppColors.lightBorder.withValues(alpha: 0.85));

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _hovered ? -3.0 : 0.0, 0),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor, width: _hovered ? 1.3 : 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.16 : 0.03),
              blurRadius: _hovered ? 18 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Row: Icon + Copy Action (if copyable)
            Row(
              mainAxisAlignment:
                  isArabic ? MainAxisAlignment.spaceBetween : MainAxisAlignment.spaceBetween,
              children: isArabic
                  ? [
                      if (c.onCopy != null)
                        Tooltip(
                          message: l10n.contactCopyTooltip,
                          child: InkWell(
                            onTap: c.onCopy,
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(
                                Icons.copy_rounded,
                                size: 16,
                                color: bodyTextColor,
                              ),
                            ),
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: c.accentColor.withValues(alpha: isDark ? 0.15 : 0.10),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: IconTheme(
                            data: IconThemeData(
                              color: c.accentColor,
                              size: 20,
                            ),
                            child: c.icon,
                          ),
                        ),
                      ),
                    ]
                  : [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: c.accentColor.withValues(alpha: isDark ? 0.15 : 0.10),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: IconTheme(
                            data: IconThemeData(
                              color: c.accentColor,
                              size: 20,
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
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(
                                Icons.copy_rounded,
                                size: 16,
                                color: bodyTextColor,
                              ),
                            ),
                          ),
                        ),
                    ],
            ),

            const SizedBox(height: 14),

            // Channel Title
            Text(
              c.title,
              style: GoogleFonts.outfit(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: bodyTextColor,
              ),
            ),

            const SizedBox(height: 4),

            // Channel Value
            SelectableText(
              c.value,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              style: GoogleFonts.outfit(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: primaryTextColor,
              ),
            ),

            const SizedBox(height: 14),

            // Primary Clickable Action Link
            InkWell(
              onTap: c.onAction,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: isArabic
                      ? [
                          Icon(
                            Icons.arrow_back_rounded,
                            size: 13,
                            color: c.accentColor,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            c.actionLabel,
                            style: GoogleFonts.outfit(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: c.accentColor,
                            ),
                          ),
                        ]
                      : [
                          Text(
                            c.actionLabel,
                            style: GoogleFonts.outfit(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: c.accentColor,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 13,
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

// ─────────────────────────────────────────────────────────────────────────────
// Primary Contact Pill Button
// ─────────────────────────────────────────────────────────────────────────────

class _PrimaryContactButton extends StatefulWidget {
  const _PrimaryContactButton({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.isDark,
    required this.isArabic,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;
  final bool isArabic;

  @override
  State<_PrimaryContactButton> createState() => _PrimaryContactButtonState();
}

class _PrimaryContactButtonState extends State<_PrimaryContactButton> {
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
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: (isDark ? AppColors.dustyRose : AppColors.deepPlum)
                    .withValues(alpha: _hovered ? 0.35 : 0.18),
                blurRadius: _hovered ? 16 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: isArabic
                ? [
                    Icon(widget.icon, size: 16, color: fg),
                    const SizedBox(width: 9),
                    Text(
                      widget.label,
                      style: GoogleFonts.outfit(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: fg,
                      ),
                    ),
                  ]
                : [
                    Text(
                      widget.label,
                      style: GoogleFonts.outfit(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: fg,
                      ),
                    ),
                    const SizedBox(width: 9),
                    Icon(widget.icon, size: 16, color: fg),
                  ],
          ),
        ),
      ),
    );
  }
}
