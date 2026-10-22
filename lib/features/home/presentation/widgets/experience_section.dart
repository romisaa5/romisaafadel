import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/responsive/responsive_utils.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Experience Entry Data Model
// ─────────────────────────────────────────────────────────────────────────────

enum ExperienceType { leadership, instruction, mentorship, internship, training, initiative }

class ExperienceEntry {
  const ExperienceEntry({
    required this.type,
    required this.role,
    required this.organization,
    required this.period,
    required this.description,
    required this.tags,
    this.duration,
    this.icon,
  });

  final ExperienceType type;
  final String role;
  final String organization;
  final String period;
  final String description;
  final List<String> tags;
  final String? duration;
  final IconData? icon;
}

// ─────────────────────────────────────────────────────────────────────────────
// Main Experience Section Widget
// ─────────────────────────────────────────────────────────────────────────────

class ExperienceSection extends StatefulWidget {
  const ExperienceSection({super.key});

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection>
    with TickerProviderStateMixin {

  late final AnimationController _headerCtrl;
  late final Animation<double> _tagFade;
  late final Animation<Offset> _tagSlide;
  late final Animation<double> _headingFade;
  late final Animation<Offset> _headingSlide;
  late final Animation<double> _subtitleFade;

  final List<AnimationController> _entryCtrl = [];
  final List<Animation<double>> _entryFade = [];
  final List<Animation<Offset>> _entrySlide = [];
  final List<Animation<double>> _entryScale = [];

  late final AnimationController _chapterBCtrl;
  late final Animation<double> _chapterBFade;

  bool _headerVisible = false;
  final List<bool> _entryVisible = List.filled(7, false);
  bool _chapterBVisible = false;

  @override
  void initState() {
    super.initState();

    _headerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _tagFade = CurvedAnimation(
      parent: _headerCtrl,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    );
    _tagSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _headerCtrl, curve: const Interval(0.0, 0.35, curve: Curves.easeOut)),
    );
    _headingFade = CurvedAnimation(
      parent: _headerCtrl,
      curve: const Interval(0.2, 0.65, curve: Curves.easeOut),
    );
    _headingSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _headerCtrl, curve: const Interval(0.2, 0.65, curve: Curves.easeOut)),
    );
    _subtitleFade = CurvedAnimation(
      parent: _headerCtrl,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    );

    _chapterBCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _chapterBFade = CurvedAnimation(parent: _chapterBCtrl, curve: Curves.easeOut);

    for (int i = 0; i < 7; i++) {
      final ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
      _entryCtrl.add(ctrl);
      _entryFade.add(CurvedAnimation(
        parent: ctrl,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ));
      _entrySlide.add(
        Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(
          CurvedAnimation(parent: ctrl, curve: const Interval(0.0, 0.8, curve: Curves.easeOut)),
        ),
      );
      _entryScale.add(
        Tween<double>(begin: 0.94, end: 1.0).animate(
          CurvedAnimation(parent: ctrl, curve: Curves.easeOut),
        ),
      );
    }
  }

  @override
  void dispose() {
    _headerCtrl.dispose();
    _chapterBCtrl.dispose();
    for (final c in _entryCtrl) {
      c.dispose();
    }
    super.dispose();
  }

  void _onHeaderVisible() {
    if (!_headerVisible) {
      _headerVisible = true;
      _headerCtrl.forward();
    }
  }

  void _onEntryVisible(int index) {
    if (!_entryVisible[index]) {
      _entryVisible[index] = true;
      _entryCtrl[index].forward();
      if (index == 4 && !_chapterBVisible) {
        _chapterBVisible = true;
        _chapterBCtrl.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isDesktop = context.isWide;
    final isCompact = context.isCompact;
    final accentColor = isDark ? AppColors.dustyRose : AppColors.mauve;
    final primaryText = isDark ? AppColors.ivory : AppColors.deepPlum;
    final secondaryText = isDark
        ? AppColors.dustyRose.withValues(alpha: 0.85)
        : AppColors.mauve.withValues(alpha: 0.88);
    final bodyText = isDark
        ? AppColors.ivory.withValues(alpha: 0.76)
        : AppColors.deepPlum.withValues(alpha: 0.74);

    final chapterAEntries = [
      ExperienceEntry(
        type: ExperienceType.leadership,
        role: l10n.expEntry1Role,
        organization: l10n.expEntry1Org,
        period: l10n.expEntry1Period,
        description: l10n.expEntry1Desc,
        tags: [l10n.expEntry1Tag1, l10n.expEntry1Tag2, l10n.expEntry1Tag3],
        icon: Icons.groups_rounded,
      ),
      ExperienceEntry(
        type: ExperienceType.instruction,
        role: l10n.expEntry2Role,
        organization: l10n.expEntry2Org,
        period: l10n.expEntry2Period,
        description: l10n.expEntry2Desc,
        tags: [l10n.expEntry2Tag1, l10n.expEntry2Tag2, l10n.expEntry2Tag3],
        icon: Icons.school_rounded,
      ),
      ExperienceEntry(
        type: ExperienceType.instruction,
        role: l10n.expEntry3Role,
        organization: l10n.expEntry3Org,
        period: l10n.expEntry3Period,
        description: l10n.expEntry3Desc,
        tags: [l10n.expEntry3Tag1, l10n.expEntry3Tag2, l10n.expEntry3Tag3],
        icon: Icons.laptop_mac_rounded,
      ),
      ExperienceEntry(
        type: ExperienceType.mentorship,
        role: l10n.expEntry4Role,
        organization: l10n.expEntry4Org,
        period: l10n.expEntry4Period,
        description: l10n.expEntry4Desc,
        tags: [l10n.expEntry4Tag1, l10n.expEntry4Tag2, l10n.expEntry4Tag3],
        icon: Icons.handshake_rounded,
      ),
    ];

    final chapterBEntries = [
      ExperienceEntry(
        type: ExperienceType.internship,
        role: l10n.expEntry5Role,
        organization: l10n.expEntry5Org,
        period: l10n.expEntry5Period,
        description: l10n.expEntry5Desc,
        tags: [l10n.expEntry5Tag1, l10n.expEntry5Tag2, l10n.expEntry5Tag3, l10n.expEntry5Tag4],
        icon: Icons.business_center_rounded,
      ),
      ExperienceEntry(
        type: ExperienceType.training,
        role: l10n.expEntry6Role,
        organization: l10n.expEntry6Org,
        period: l10n.expEntry6Period,
        description: l10n.expEntry6Desc,
        tags: [l10n.expEntry6Tag1, l10n.expEntry6Tag2, l10n.expEntry6Tag3],
        duration: l10n.expEntry6Duration,
        icon: Icons.developer_board_rounded,
      ),
      ExperienceEntry(
        type: ExperienceType.initiative,
        role: l10n.expEntry7Role,
        organization: l10n.expEntry7Org,
        period: l10n.expEntry7Period,
        description: l10n.expEntry7Desc,
        tags: [l10n.expEntry7Tag1, l10n.expEntry7Tag2, l10n.expEntry7Tag3],
        icon: Icons.rocket_launch_rounded,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Section Header ────────────────────────────────────────────────────
        _VisibilityTrigger(
          onVisible: _onHeaderVisible,
          child: AnimatedBuilder(
            animation: _headerCtrl,
            builder: (context, _) => _buildHeader(
              l10n: l10n,
              isArabic: isArabic,
              isDesktop: isDesktop,
              primaryText: primaryText,
              bodyText: bodyText,
              accentColor: accentColor,
            ),
          ),
        ),

        const SizedBox(height: 56),

        // ── Chapter A ─────────────────────────────────────────────────────────
        _ChapterDivider(
          tag: l10n.expChapterATag,
          title: l10n.expChapterATitle,
          isDark: isDark,
          isArabic: isArabic,
          accentColor: const Color(0xFF704C67),
        ),

        const SizedBox(height: 32),

        ...List.generate(chapterAEntries.length, (i) {
          return _VisibilityTrigger(
            onVisible: () => _onEntryVisible(i),
            child: AnimatedBuilder(
              animation: _entryCtrl[i],
              builder: (ctx, _) => Padding(
                padding: EdgeInsets.only(bottom: isCompact ? 24.0 : 32.0),
                child: FadeTransition(
                  opacity: _entryFade[i],
                  child: SlideTransition(
                    position: _entrySlide[i],
                    child: ScaleTransition(
                      scale: _entryScale[i],
                      alignment: Alignment.topCenter,
                      child: _ExperienceCard(
                        entry: chapterAEntries[i],
                        isDark: isDark,
                        isArabic: isArabic,
                        isDesktop: isDesktop,
                        isCompact: isCompact,
                        primaryText: primaryText,
                        secondaryText: secondaryText,
                        bodyText: bodyText,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),

        const SizedBox(height: 16),

        // ── Chapter B Divider ─────────────────────────────────────────────────
        FadeTransition(
          opacity: _chapterBFade,
          child: _ChapterDivider(
            tag: l10n.expChapterBTag,
            title: l10n.expChapterBTitle,
            isDark: isDark,
            isArabic: isArabic,
            accentColor: const Color(0xFF8B6A7F),
          ),
        ),

        const SizedBox(height: 32),

        ...List.generate(chapterBEntries.length, (i) {
          final gi = i + 4;
          return _VisibilityTrigger(
            onVisible: () => _onEntryVisible(gi),
            child: AnimatedBuilder(
              animation: _entryCtrl[gi],
              builder: (ctx, _) => Padding(
                padding: EdgeInsets.only(bottom: isCompact ? 24.0 : 32.0),
                child: FadeTransition(
                  opacity: _entryFade[gi],
                  child: SlideTransition(
                    position: _entrySlide[gi],
                    child: ScaleTransition(
                      scale: _entryScale[gi],
                      alignment: Alignment.topCenter,
                      child: _ExperienceCard(
                        entry: chapterBEntries[i],
                        isDark: isDark,
                        isArabic: isArabic,
                        isDesktop: isDesktop,
                        isCompact: isCompact,
                        primaryText: primaryText,
                        secondaryText: secondaryText,
                        bodyText: bodyText,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),

        const SizedBox(height: 24),
        _SectionBottomDivider(isDark: isDark),
      ],
    );
  }

  Widget _buildHeader({
    required AppLocalizations l10n,
    required bool isArabic,
    required bool isDesktop,
    required Color primaryText,
    required Color bodyText,
    required Color accentColor,
  }) {
    final headingStyle = isArabic
        ? GoogleFonts.amiri(
            fontSize: isDesktop ? 50 : 34,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
            height: 1.15,
            color: primaryText,
          )
        : GoogleFonts.dmSerifDisplay(
            fontSize: isDesktop ? 50 : 34,
            fontStyle: FontStyle.italic,
            height: 1.15,
            color: primaryText,
          );

    return Column(
      crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        FadeTransition(
          opacity: _tagFade,
          child: SlideTransition(
            position: _tagSlide,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(color: accentColor.withValues(alpha: 0.45), width: 1.0),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                l10n.expSectionTag,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.8,
                  color: accentColor,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 18),

        FadeTransition(
          opacity: _headingFade,
          child: SlideTransition(
            position: _headingSlide,
            child: Text(l10n.expSectionHeading, style: headingStyle),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: AnimatedBuilder(
            animation: _headingFade,
            builder: (context, _) {
              final w = MediaQuery.sizeOf(context).width;
              return Align(
                alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  height: 1.5,
                  width: _headingFade.value * (w * 0.38).clamp(0, 520),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [accentColor, accentColor.withValues(alpha: 0)],
                      begin: isArabic ? Alignment.centerRight : Alignment.centerLeft,
                      end: isArabic ? Alignment.centerLeft : Alignment.centerRight,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        FadeTransition(
          opacity: _subtitleFade,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Text(
              l10n.expSectionSubtitle,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              style: GoogleFonts.outfit(
                fontSize: 15.5,
                height: 1.75,
                color: bodyText,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Chapter Divider
// ─────────────────────────────────────────────────────────────────────────────

class _ChapterDivider extends StatelessWidget {
  const _ChapterDivider({
    required this.tag,
    required this.title,
    required this.isDark,
    required this.isArabic,
    required this.accentColor,
  });

  final String tag;
  final String title;
  final bool isDark;
  final bool isArabic;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final lineColor = isDark
        ? AppColors.darkBorder.withValues(alpha: 0.55)
        : AppColors.lightBorder.withValues(alpha: 0.65);

    final labelColumn = Column(
      crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          tag,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.0,
            color: accentColor.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
            color: isDark
                ? AppColors.ivory.withValues(alpha: 0.5)
                : AppColors.deepPlum.withValues(alpha: 0.5),
          ),
        ),
      ],
    );

    final line = Expanded(
      child: Container(
        height: 1.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isArabic
                ? [Colors.transparent, lineColor]
                : [lineColor, Colors.transparent],
          ),
        ),
      ),
    );

    return Row(
      children: isArabic
          ? [line, const SizedBox(width: 20), labelColumn]
          : [labelColumn, const SizedBox(width: 20), line],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Experience Card
// ─────────────────────────────────────────────────────────────────────────────

class _ExperienceCard extends StatefulWidget {
  const _ExperienceCard({
    required this.entry,
    required this.isDark,
    required this.isArabic,
    required this.isDesktop,
    required this.isCompact,
    required this.primaryText,
    required this.secondaryText,
    required this.bodyText,
  });

  final ExperienceEntry entry;
  final bool isDark;
  final bool isArabic;
  final bool isDesktop;
  final bool isCompact;
  final Color primaryText;
  final Color secondaryText;
  final Color bodyText;

  @override
  State<_ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard> {
  bool _hovered = false;

  Color get _typeAccent => switch (widget.entry.type) {
        ExperienceType.leadership => const Color(0xFF8B6A9B),
        ExperienceType.instruction => const Color(0xFF5B7FA0),
        ExperienceType.mentorship => const Color(0xFF5B8A70),
        ExperienceType.internship => const Color(0xFF704C67),
        ExperienceType.training => const Color(0xFF8B7A5A),
        ExperienceType.initiative => const Color(0xFF6B5B9A),
      };

  String _typeLabel(AppLocalizations l10n) => switch (widget.entry.type) {
        ExperienceType.leadership => l10n.expTypeLeadership,
        ExperienceType.instruction => l10n.expTypeInstruction,
        ExperienceType.mentorship => l10n.expTypeMentorship,
        ExperienceType.internship => l10n.expTypeInternship,
        ExperienceType.training => l10n.expTypeTraining,
        ExperienceType.initiative => l10n.expTypeInitiative,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ta = _typeAccent;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _hovered ? -4.0 : 0.0, 0),
        decoration: BoxDecoration(
          color: widget.isDark
              ? (_hovered ? AppColors.darkSurfaceVariant : AppColors.darkSurface)
              : (_hovered ? const Color(0xFFEAE0E7) : AppColors.lightSurface),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered
                ? ta.withValues(alpha: 0.5)
                : (widget.isDark
                    ? AppColors.darkBorder.withValues(alpha: 0.65)
                    : AppColors.lightBorder.withValues(alpha: 0.70)),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: (widget.isDark ? Colors.black : AppColors.deepPlum)
                  .withValues(alpha: _hovered ? 0.22 : 0.06),
              blurRadius: _hovered ? 28 : 10,
              offset: Offset(0, _hovered ? 10 : 3),
            ),
            if (_hovered)
              BoxShadow(
                color: ta.withValues(alpha: 0.12),
                blurRadius: 40,
                offset: const Offset(0, 8),
              ),
          ],
        ),
        child: widget.isDesktop
            ? _buildDesktopLayout(l10n, ta)
            : _buildMobileLayout(l10n, ta),
      ),
    );
  }

  Widget _buildDesktopLayout(AppLocalizations l10n, Color ta) {
    final strip = AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 3.5,
      decoration: BoxDecoration(
        color: _hovered ? ta : ta.withValues(alpha: 0.4),
        borderRadius: BorderRadius.only(
          topLeft: widget.isArabic ? Radius.zero : const Radius.circular(20),
          bottomLeft: widget.isArabic ? Radius.zero : const Radius.circular(20),
          topRight: widget.isArabic ? const Radius.circular(20) : Radius.zero,
          bottomRight: widget.isArabic ? const Radius.circular(20) : Radius.zero,
        ),
      ),
    );

    final metaWidth = 185.0;
    final divider = Container(
      width: 1.0,
      color: widget.isDark
          ? AppColors.darkBorder.withValues(alpha: 0.45)
          : AppColors.lightBorder.withValues(alpha: 0.55),
    );

    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.isArabic
              ? [
                  Expanded(child: _ContentPanel(entry: widget.entry, isDark: widget.isDark, isArabic: widget.isArabic, typeAccent: ta, primaryText: widget.primaryText, bodyText: widget.bodyText)),
                  const SizedBox(width: 22),
                  divider,
                  const SizedBox(width: 22),
                  SizedBox(width: metaWidth, child: _MetaPanel(entry: widget.entry, isDark: widget.isDark, isArabic: widget.isArabic, typeAccent: ta, typeLabel: _typeLabel(l10n), secondaryText: widget.secondaryText)),
                ]
              : [
                  SizedBox(width: metaWidth, child: _MetaPanel(entry: widget.entry, isDark: widget.isDark, isArabic: widget.isArabic, typeAccent: ta, typeLabel: _typeLabel(l10n), secondaryText: widget.secondaryText)),
                  const SizedBox(width: 22),
                  divider,
                  const SizedBox(width: 26),
                  Expanded(child: _ContentPanel(entry: widget.entry, isDark: widget.isDark, isArabic: widget.isArabic, typeAccent: ta, primaryText: widget.primaryText, bodyText: widget.bodyText)),
                ],
        ),
      ),
    );

    return IntrinsicHeight(
      child: widget.isArabic
          ? Row(children: [content, strip])
          : Row(children: [strip, content]),
    );
  }

  Widget _buildMobileLayout(AppLocalizations l10n, Color ta) {
    return Padding(
      padding: EdgeInsets.all(widget.isCompact ? 18.0 : 22.0),
      child: Column(
        crossAxisAlignment: widget.isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: widget.isArabic ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!widget.isArabic && widget.entry.icon != null) ...[
                Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(color: ta.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                  child: Icon(widget.entry.icon, size: 17, color: ta),
                ),
                const SizedBox(width: 10),
              ],
              _TypeBadge(label: _typeLabel(l10n), color: ta),
              if (widget.isArabic && widget.entry.icon != null) ...[
                const SizedBox(width: 10),
                Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(color: ta.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                  child: Icon(widget.entry.icon, size: 17, color: ta),
                ),
              ],
            ],
          ),
          const SizedBox(height: 14),
          _ContentPanel(
            entry: widget.entry,
            isDark: widget.isDark,
            isArabic: widget.isArabic,
            typeAccent: ta,
            primaryText: widget.primaryText,
            bodyText: widget.bodyText,
          ),
          if (widget.entry.period.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              widget.entry.period,
              style: GoogleFonts.jetBrainsMono(fontSize: 11, color: widget.secondaryText, letterSpacing: 0.8),
            ),
          ],
          if (widget.entry.duration != null) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: ta.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(4)),
              child: Text(
                widget.entry.duration!,
                style: GoogleFonts.jetBrainsMono(fontSize: 10, fontWeight: FontWeight.w600, color: ta),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Meta Panel
// ─────────────────────────────────────────────────────────────────────────────

class _MetaPanel extends StatelessWidget {
  const _MetaPanel({
    required this.entry,
    required this.isDark,
    required this.isArabic,
    required this.typeAccent,
    required this.typeLabel,
    required this.secondaryText,
  });

  final ExperienceEntry entry;
  final bool isDark;
  final bool isArabic;
  final Color typeAccent;
  final String typeLabel;
  final Color secondaryText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (entry.icon != null) ...[
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: typeAccent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(entry.icon, size: 20, color: typeAccent),
          ),
          const SizedBox(height: 12),
        ],
        _TypeBadge(label: typeLabel, color: typeAccent),
        const SizedBox(height: 12),
        if (entry.period.isNotEmpty)
          Text(
            entry.period,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 11.5,
              color: secondaryText,
              letterSpacing: 0.8,
              height: 1.4,
            ),
          ),
        if (entry.duration != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: typeAccent.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              entry.duration!,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: typeAccent,
                letterSpacing: 0.6,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Content Panel
// ─────────────────────────────────────────────────────────────────────────────

class _ContentPanel extends StatelessWidget {
  const _ContentPanel({
    required this.entry,
    required this.isDark,
    required this.isArabic,
    required this.typeAccent,
    required this.primaryText,
    required this.bodyText,
  });

  final ExperienceEntry entry;
  final bool isDark;
  final bool isArabic;
  final Color typeAccent;
  final Color primaryText;
  final Color bodyText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          entry.role,
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
          style: GoogleFonts.outfit(
            fontSize: 17.5,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
            height: 1.25,
            color: primaryText,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          entry.organization,
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
            color: typeAccent,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          entry.description,
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
          style: GoogleFonts.outfit(
            fontSize: 14.5,
            height: 1.72,
            color: bodyText,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: isArabic ? WrapAlignment.end : WrapAlignment.start,
          children: entry.tags.map((tag) => _SkillChip(label: tag, isDark: isDark)).toList(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Type Badge
// ─────────────────────────────────────────────────────────────────────────────

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.30), width: 0.8),
      ),
      child: Text(
        label,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 1.4,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Skill Chip
// ─────────────────────────────────────────────────────────────────────────────

class _SkillChip extends StatelessWidget {
  const _SkillChip({required this.label, required this.isDark});
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceVariant.withValues(alpha: 0.75)
            : AppColors.lightSurfaceVariant.withValues(alpha: 0.80),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorder.withValues(alpha: 0.60)
              : AppColors.lightBorder.withValues(alpha: 0.65),
          width: 0.8,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isDark
              ? AppColors.ivory.withValues(alpha: 0.78)
              : AppColors.deepPlum.withValues(alpha: 0.76),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section Bottom Divider
// ─────────────────────────────────────────────────────────────────────────────

class _SectionBottomDivider extends StatelessWidget {
  const _SectionBottomDivider({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final c = isDark
        ? AppColors.darkBorder.withValues(alpha: 0.40)
        : AppColors.lightBorder.withValues(alpha: 0.50);
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(height: 1.0, color: c),
        Container(width: 6, height: 6, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Visibility Trigger — fires once when widget enters viewport (reliable)
// ─────────────────────────────────────────────────────────────────────────────

class _VisibilityTrigger extends StatefulWidget {
  const _VisibilityTrigger({required this.child, required this.onVisible});
  final Widget child;
  final VoidCallback onVisible;

  @override
  State<_VisibilityTrigger> createState() => _VisibilityTriggerState();
}

class _VisibilityTriggerState extends State<_VisibilityTrigger> {
  bool _fired = false;

  @override
  void initState() {
    super.initState();
    // Check after first frame is laid out
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  void _check() {
    if (_fired || !mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final pos = box.localToGlobal(Offset.zero);
    final screenH = MediaQuery.sizeOf(context).height;
    if (pos.dy < screenH + 200) {
      _fired = true;
      widget.onVisible();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Schedule check every time the widget rebuilds (e.g., due to scroll)
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
    return widget.child;
  }
}
