import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/responsive/responsive_utils.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Experience Category & Milestone Model
// ─────────────────────────────────────────────────────────────────────────────

enum ExperienceCategory {
  professional,
  teaching,
  mentorship,
  leadership,
  training,
  development,
}

class TimelineMilestone {
  const TimelineMilestone({
    required this.id,
    required this.category,
    required this.role,
    required this.organization,
    required this.period,
    required this.descriptionPoints,
    required this.tags,
    this.duration,
    this.isDateNotSpecified = false,
    this.technicalTrackTitle,
    this.technicalTrackDesc,
    this.nonTechnicalTrackTitle,
    this.nonTechnicalTrackDesc,
    this.icon,
  });

  final int id;
  final ExperienceCategory category;
  final String role;
  final String organization;
  final String period;
  final List<String> descriptionPoints;
  final List<String> tags;
  final String? duration;
  final bool isDateNotSpecified;
  final String? technicalTrackTitle;
  final String? technicalTrackDesc;
  final String? nonTechnicalTrackTitle;
  final String? nonTechnicalTrackDesc;
  final IconData? icon;
}

// ─────────────────────────────────────────────────────────────────────────────
// Main Experience & Training Section Widget
// ─────────────────────────────────────────────────────────────────────────────

class ExperienceSection extends StatefulWidget {
  const ExperienceSection({super.key});

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection>
    with TickerProviderStateMixin {
  // Section Header animations
  late final AnimationController _headerCtrl;
  late final Animation<double> _tagFade;
  late final Animation<Offset> _tagSlide;
  late final Animation<double> _headingFade;
  late final Animation<Offset> _headingSlide;
  late final Animation<double> _ruleExpand;
  late final Animation<double> _subtitleFade;

  // Continuous Traveling Light Pulse along the Timeline Spine
  late final AnimationController _spinePulseCtrl;

  // Staggered reveal animations for all 7 milestones
  final List<AnimationController> _milestoneCtrl = [];
  final List<Animation<double>> _milestoneFade = [];
  final List<Animation<Offset>> _milestoneSlide = [];
  final List<Animation<double>> _milestoneScale = [];

  bool _headerVisible = false;
  final List<bool> _milestoneVisible = List.filled(7, false);

  // Filter state: 0 = All (7), 1 = Professional & Leadership, 2 = Teaching & Mentoring, 3 = Technical Training
  int _selectedFilter = 0;

  // Hovered milestone index (-1 if none)
  int _hoveredIndex = -1;

  @override
  void initState() {
    super.initState();

    // 1. Header Animation Controller
    _headerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    );

    _tagFade = CurvedAnimation(
      parent: _headerCtrl,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    );
    _tagSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
      CurvedAnimation(parent: _headerCtrl, curve: const Interval(0.0, 0.35, curve: Curves.easeOutCubic)),
    );

    _headingFade = CurvedAnimation(
      parent: _headerCtrl,
      curve: const Interval(0.2, 0.65, curve: Curves.easeOut),
    );
    _headingSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _headerCtrl, curve: const Interval(0.2, 0.65, curve: Curves.easeOutCubic)),
    );

    _ruleExpand = CurvedAnimation(
      parent: _headerCtrl,
      curve: const Interval(0.4, 0.8, curve: Curves.easeOutCubic),
    );

    _subtitleFade = CurvedAnimation(
      parent: _headerCtrl,
      curve: const Interval(0.55, 1.0, curve: Curves.easeOut),
    );

    // 2. Spine Continuous Traveling Light Pulse (subtle glowing energy traveling down the line)
    _spinePulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    // 3. Staggered reveal for each milestone
    for (int i = 0; i < 7; i++) {
      final ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 750),
      );
      _milestoneCtrl.add(ctrl);

      _milestoneFade.add(CurvedAnimation(
        parent: ctrl,
        curve: const Interval(0.0, 0.75, curve: Curves.easeOut),
      ));

      _milestoneSlide.add(
        Tween<Offset>(begin: const Offset(0, 0.16), end: Offset.zero).animate(
          CurvedAnimation(parent: ctrl, curve: const Interval(0.0, 0.85, curve: Curves.easeOutCubic)),
        ),
      );

      _milestoneScale.add(
        Tween<double>(begin: 0.95, end: 1.0).animate(
          CurvedAnimation(parent: ctrl, curve: Curves.easeOutCubic),
        ),
      );
    }
  }

  @override
  void dispose() {
    _headerCtrl.dispose();
    _spinePulseCtrl.dispose();
    for (final c in _milestoneCtrl) {
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

  void _onMilestoneVisible(int index) {
    if (!_milestoneVisible[index]) {
      _milestoneVisible[index] = true;
      _milestoneCtrl[index].forward();
    }
  }

  bool _isItemHighlighted(ExperienceCategory category) {
    if (_selectedFilter == 0) return true;
    switch (_selectedFilter) {
      case 1: // Professional & Leadership
        return category == ExperienceCategory.professional ||
            category == ExperienceCategory.leadership;
      case 2: // Teaching & Mentoring
        return category == ExperienceCategory.teaching ||
            category == ExperienceCategory.mentorship;
      case 3: // Technical Training
        return category == ExperienceCategory.training ||
            category == ExperienceCategory.development;
      default:
        return true;
    }
  }

  List<TimelineMilestone> _buildMilestones(AppLocalizations l10n, bool isArabic) {
    return [
      // 1. Growfet — Flutter Developer Intern (Professional Experience)
      TimelineMilestone(
        id: 1,
        category: ExperienceCategory.professional,
        role: l10n.expEntry5Role,
        organization: l10n.expEntry5Org,
        period: l10n.expDateNotSpecified,
        isDateNotSpecified: true,
        icon: Icons.business_center_rounded,
        descriptionPoints: isArabic
            ? const [
                'طوّرت وصانت تطبيقات هواتف محمولة باستخدام Flutter وDart.',
                'نفّذت واجهات مستخدم نظيفة وقابلة للتوسع وفق مبادئ التصميم الحديثة.',
                'ربطت واجهات برمجة التطبيقات RESTful وأدارت حالة التطبيق بكفاءة.',
                'استكشفت الأخطاء البرمجية وحسّنت أداء التطبيق لتوفير تجربة مستخدم سلسة.',
                'تعاونت ضمن فريق عمل يتبع أفضل ممارسات هندسة البرمجيات وأنظمة التحكم في الإصدارات.',
              ]
            : const [
                'Developed and maintained mobile applications using Flutter and Dart.',
                'Implemented clean and scalable UI following modern design principles.',
                'Integrated RESTful APIs and managed application state.',
                'Debugged issues and optimized app performance for a better user experience.',
                'Collaborated within a team using best practices and version control.',
              ],
        tags: [l10n.expEntry5Tag1, l10n.expEntry5Tag2, l10n.expEntry5Tag3, l10n.expEntry5Tag4],
      ),

      // 2. CIS Team — Flutter Mentor (Mentoring & Community, 2024–2025)
      TimelineMilestone(
        id: 2,
        category: ExperienceCategory.mentorship,
        role: l10n.expEntry4Role,
        organization: l10n.expEntry4Org,
        period: l10n.expEntry4Period,
        icon: Icons.handshake_rounded,
        descriptionPoints: isArabic
            ? const [
                'دعمت الأعضاء الجدد في استيعاب مفاهيم Flutter وحل المشكلات البرمجية.',
                'ساهمت في تنظيم الجلسات التعليمية وإرشاد الطلاب خلال المشاريع والمهام.',
              ]
            : const [
                'Supported junior members in understanding Flutter concepts and solving coding problems.',
                'Assisted in organizing learning sessions and guiding students through projects and tasks.',
              ],
        tags: [l10n.expEntry4Tag1, l10n.expEntry4Tag2, l10n.expEntry4Tag3],
      ),

      // 3. CIS Team — Flutter Instructor, Technical Gates 5 (Teaching & Mentoring, 2024–2025)
      TimelineMilestone(
        id: 3,
        category: ExperienceCategory.teaching,
        role: l10n.expEntry3Role,
        organization: l10n.expEntry3Org,
        period: l10n.expEntry3Period,
        icon: Icons.school_rounded,
        descriptionPoints: isArabic
            ? const [
                'قدّمت جلسات تعليمية وأرشدت الطلاب في مسار Flutter كجزء من برنامج Technical Gates 5 بتنظيم من فريق CIS.',
                'ساعدت المشاركين على فهم مفاهيم Flutter الأساسية وتطبيقها في مشاريع عملية مصغرة.',
              ]
            : const [
                'Delivered sessions and mentored students in the Flutter track as part of the Technical Gates 5 program organized by the CIS Team.',
                'Helped participants understand core Flutter concepts and apply them in practical mini-projects.',
              ],
        tags: [l10n.expEntry3Tag1, l10n.expEntry3Tag2, l10n.expEntry3Tag3],
      ),

      // 4. ITI — Flutter Trainee, Winter Internship (Technical Training, Jan 2025, 60 Hours)
      TimelineMilestone(
        id: 4,
        category: ExperienceCategory.training,
        role: l10n.expEntry6Role,
        organization: l10n.expEntry6Org,
        period: l10n.expEntry6Period,
        duration: l10n.expEntry6Duration,
        icon: Icons.developer_board_rounded,
        descriptionPoints: isArabic
            ? const [
                'تصميم واجهات المستخدم وبناء الـ Widgets الاحترافية في Flutter.',
                'ربط واجهات برمجة التطبيقات (APIs) ومعالجة البيانات المتدفقة.',
                'تطبيق تقنيات وأساليب إدارة الحالة المتقدمة (State Management).',
                'مقدمة إلى العمل الحر وتخطيط وتنفيذ المشاريع البرمجية الواقعية.',
              ]
            : const [
                'Flutter widgets and UI design.',
                'API integration and data handling.',
                'State management techniques.',
                'Introduction to freelancing and real-world project planning.',
              ],
        tags: [l10n.expEntry6Tag1, l10n.expEntry6Tag2, l10n.expEntry6Tag3, l10n.expEntry6Tag4],
      ),

      // 5. BreakinPoint Team — Flutter Instructor, Flutter Bootcamp (Teaching & Mentoring, 2025)
      TimelineMilestone(
        id: 5,
        category: ExperienceCategory.teaching,
        role: l10n.expEntry2Role,
        organization: l10n.expEntry2Org,
        period: l10n.expEntry2Period,
        icon: Icons.laptop_mac_rounded,
        descriptionPoints: isArabic
            ? const [
                'قادت معسكراً تدريبياً لـ Flutter مدته شهر ونصف، أرشدت فيه المشاركين من الأساسيات حتى تطوير المشروع النهائي.',
                'قدّمت تدريباً عملياً مباشراً ومتابعة مستمرة ودعماً فردياً طوال فترة المعسكر.',
              ]
            : const [
                'Led a 1.5-month Flutter bootcamp, guiding participants from fundamentals to final project development.',
                'Provided hands-on training, follow-up, and individual support throughout the bootcamp.',
              ],
        tags: [l10n.expEntry2Tag1, l10n.expEntry2Tag2, l10n.expEntry2Tag3],
      ),

      // 6. DEPI — Digital Egypt Pioneers Initiative (Technical & Professional Development, June 2025)
      TimelineMilestone(
        id: 6,
        category: ExperienceCategory.development,
        role: l10n.expEntry7Role,
        organization: l10n.expEntry7Org,
        period: l10n.expEntry7Period,
        icon: Icons.rocket_launch_rounded,
        technicalTrackTitle: l10n.expTechTrackTitle,
        technicalTrackDesc: isArabic
            ? 'دراسة مسار التطبيقات متعددة المنصات باستخدام Flutter، مع التركيز على بناء تطبيقات موبايل قابلة للتوسع.'
            : 'Studying the Cross Platform track using Flutter, focusing on building scalable, multi-platform mobile applications.',
        nonTechnicalTrackTitle: l10n.expNonTechTrackTitle,
        nonTechnicalTrackDesc: isArabic
            ? 'المشاركة في جلسات صقل المهارات الشخصية (Soft Skills)، وأساسيات العمل الحر، ومهارات التواصل والتطوير الوظيفي.'
            : 'Participating in sessions on soft skills, freelancing basics, communication, and career development.',
        descriptionPoints: const [],
        tags: [l10n.expEntry7Tag1, l10n.expEntry7Tag2, l10n.expEntry7Tag3, l10n.expEntry7Tag4],
      ),

      // 7. IEEE Mansoura CS Chapter — Head, Flutter Circle (Leadership & Community, 2025–2026)
      TimelineMilestone(
        id: 7,
        category: ExperienceCategory.leadership,
        role: l10n.expEntry1Role,
        organization: l10n.expEntry1Org,
        period: l10n.expEntry1Period,
        icon: Icons.groups_rounded,
        descriptionPoints: isArabic
            ? const [
                'شاركت بفاعلية في قيادة وإدارة دائرة Flutter، مساهمةً في المناقشات والأنشطة والفعاليات المتخصصة في تطوير تطبيقات Flutter.',
              ]
            : const [
                'Actively participated in the Flutter Circle, contributing to discussions, activities, and events related to Flutter development.',
              ],
        tags: [l10n.expEntry1Tag1, l10n.expEntry1Tag2, l10n.expEntry1Tag3],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isDesktop = context.isWide;
    final isCompact = context.isCompact;

    final primaryText = isDark ? AppColors.ivory : AppColors.deepPlum;
    final secondaryText = isDark
        ? AppColors.dustyRose.withValues(alpha: 0.90)
        : AppColors.mauve.withValues(alpha: 0.90);
    final bodyText = isDark
        ? AppColors.ivory.withValues(alpha: 0.78)
        : AppColors.deepPlum.withValues(alpha: 0.76);
    final accentColor = isDark ? AppColors.dustyRose : AppColors.mauve;

    final milestones = _buildMilestones(l10n, isArabic);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── 1. Section Header ──────────────────────────────────────────
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

        const SizedBox(height: 32),

        // ── 2. Interactive Domain Filter Tabs ──────────────────────────
        _buildFilterBar(l10n, isDark, isArabic, accentColor),

        const SizedBox(height: 48),

        // ── 3. Continuous Interconnected Timeline ──────────────────────
        // All milestones form a continuous visual path from entry 0 to entry 6
        ...List.generate(milestones.length, (index) {
          final milestone = milestones[index];
          final isHighlighted = _isItemHighlighted(milestone.category);
          final isHovered = _hoveredIndex == index;
          final isFirst = index == 0;
          final isLast = index == milestones.length - 1;

          return _VisibilityTrigger(
            onVisible: () => _onMilestoneVisible(index),
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _milestoneCtrl[index],
                _spinePulseCtrl,
              ]),
              builder: (ctx, _) {
                return FadeTransition(
                  opacity: _milestoneFade[index],
                  child: SlideTransition(
                    position: _milestoneSlide[index],
                    child: ScaleTransition(
                      scale: _milestoneScale[index],
                      alignment: isDesktop
                          ? (index.isEven ? Alignment.centerRight : Alignment.centerLeft)
                          : Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 0),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 320),
                          opacity: isHighlighted ? 1.0 : 0.35,
                          child: isDesktop
                              ? _buildDesktopMilestoneRow(
                                  milestone: milestone,
                                  index: index,
                                  isFirst: isFirst,
                                  isLast: isLast,
                                  isHovered: isHovered,
                                  isDark: isDark,
                                  isArabic: isArabic,
                                  primaryText: primaryText,
                                  secondaryText: secondaryText,
                                  bodyText: bodyText,
                                  accentColor: accentColor,
                                  pulseProgress: _spinePulseCtrl.value,
                                )
                              : _buildMobileMilestoneRow(
                                  milestone: milestone,
                                  index: index,
                                  isFirst: isFirst,
                                  isLast: isLast,
                                  isHovered: isHovered,
                                  isDark: isDark,
                                  isCompact: isCompact,
                                  isArabic: isArabic,
                                  primaryText: primaryText,
                                  secondaryText: secondaryText,
                                  bodyText: bodyText,
                                  accentColor: accentColor,
                                  pulseProgress: _spinePulseCtrl.value,
                                ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }),

        const SizedBox(height: 48),

        // ── 4. Architectural Bottom Divider ────────────────────────────
        _SectionBottomDivider(isDark: isDark),
      ],
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Section Header
  // ───────────────────────────────────────────────────────────────────────────

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
            fontSize: isDesktop ? 44 : 32,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
            height: 1.25,
            color: primaryText,
          )
        : GoogleFonts.dmSerifDisplay(
            fontSize: isDesktop ? 46 : 32,
            fontStyle: FontStyle.italic,
            height: 1.15,
            letterSpacing: -0.3,
            color: primaryText,
          );

    return Column(
      crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        // Category Tag
        FadeTransition(
          opacity: _tagFade,
          child: SlideTransition(
            position: _tagSlide,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                border: Border.all(color: accentColor.withValues(alpha: 0.40), width: 1.0),
                borderRadius: BorderRadius.circular(6),
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

        const SizedBox(height: 16),

        // Main Title
        FadeTransition(
          opacity: _headingFade,
          child: SlideTransition(
            position: _headingSlide,
            child: Text(
              l10n.expSectionHeading,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              style: headingStyle,
            ),
          ),
        ),

        // Animated underline accent rule
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = (constraints.maxWidth * 0.45).clamp(120.0, 480.0);
              return Align(
                alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  height: 2.0,
                  width: _ruleExpand.value * maxWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1.0),
                    gradient: LinearGradient(
                      colors: isArabic
                          ? [Colors.transparent, accentColor]
                          : [accentColor, Colors.transparent],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Subtitle Narrative
        FadeTransition(
          opacity: _subtitleFade,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Text(
              l10n.expSectionSubtitle,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              style: GoogleFonts.outfit(
                fontSize: 15.5,
                height: 1.72,
                color: bodyText,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Filter Tabs Bar
  // ───────────────────────────────────────────────────────────────────────────

  Widget _buildFilterBar(
    AppLocalizations l10n,
    bool isDark,
    bool isArabic,
    Color accentColor,
  ) {
    final filters = [
      (0, l10n.expFilterAll),
      (1, l10n.expFilterProfessional),
      (2, l10n.expFilterTeaching),
      (3, l10n.expFilterTraining),
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: isArabic ? WrapAlignment.end : WrapAlignment.start,
      children: filters.map((item) {
        final (index, label) = item;
        final selected = _selectedFilter == index;

        return InkWell(
          onTap: () => setState(() => _selectedFilter = index),
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: selected
                  ? accentColor.withValues(alpha: isDark ? 0.28 : 0.20)
                  : (isDark
                      ? AppColors.darkSurface.withValues(alpha: 0.60)
                      : AppColors.lightSurface.withValues(alpha: 0.70)),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected
                    ? accentColor
                    : (isDark
                        ? AppColors.darkBorder.withValues(alpha: 0.55)
                        : AppColors.lightBorder.withValues(alpha: 0.65)),
                width: selected ? 1.4 : 0.9,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.18),
                        blurRadius: 12,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selected) ...[
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    color: selected
                        ? (isDark ? AppColors.ivory : AppColors.deepPlum)
                        : (isDark
                            ? AppColors.ivory.withValues(alpha: 0.65)
                            : AppColors.deepPlum.withValues(alpha: 0.65)),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Desktop Alternating Milestone Row
  // ───────────────────────────────────────────────────────────────────────────

  Widget _buildDesktopMilestoneRow({
    required TimelineMilestone milestone,
    required int index,
    required bool isFirst,
    required bool isLast,
    required bool isHovered,
    required bool isDark,
    required bool isArabic,
    required Color primaryText,
    required Color secondaryText,
    required Color bodyText,
    required Color accentColor,
    required double pulseProgress,
  }) {
    final categoryAccent = _getCategoryAccent(milestone.category, isDark);
    final cardIsOnLeft = index.isEven;

    final cardWidget = MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = -1),
      child: _MilestoneCard(
        milestone: milestone,
        isDark: isDark,
        isArabic: isArabic,
        isHovered: isHovered,
        primaryText: primaryText,
        secondaryText: secondaryText,
        bodyText: bodyText,
        categoryAccent: categoryAccent,
      ),
    );

    final dateWidget = MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = -1),
      child: _OppositeDateBadge(
        period: milestone.period,
        duration: milestone.duration,
        isDateNotSpecified: milestone.isDateNotSpecified,
        alignLeft: !cardIsOnLeft,
        categoryAccent: categoryAccent,
        isDark: isDark,
        isArabic: isArabic,
        isHovered: isHovered,
      ),
    );

    final spineNode = _TimelineSpineNode(
      milestone: milestone,
      isFirst: isFirst,
      isLast: isLast,
      isHovered: isHovered,
      isDark: isDark,
      isArabic: isArabic,
      categoryAccent: categoryAccent,
      pulseProgress: pulseProgress,
      cardIsOnLeft: cardIsOnLeft,
      isMobile: false,
      nodeYOffset: 34.0,
      onHover: (hovered) => setState(() => _hoveredIndex = hovered ? index : -1),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final halfWidth = (constraints.maxWidth - 72.0) / 2.0;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // 1. Primary Height-Determining Child: The Milestone Card
            // The card lays out with finite width = halfWidth and unconstrained height.
            // Stack adopts this exact height naturally.
            Padding(
              padding: EdgeInsets.only(
                left: cardIsOnLeft ? 0.0 : (halfWidth + 72.0),
                right: cardIsOnLeft ? (halfWidth + 72.0) : 0.0,
                bottom: 32.0,
              ),
              child: Align(
                alignment: cardIsOnLeft ? Alignment.topRight : Alignment.topLeft,
                child: cardWidget,
              ),
            ),

            // 2. Central Continuous Spine (Positioned from top to bottom of card + 32px margin)
            Positioned(
              top: 0,
              bottom: 0,
              left: halfWidth,
              width: 72.0,
              child: spineNode,
            ),

            // 3. Opposite Date Badge (Positioned at top of opposite column)
            Positioned(
              top: 0,
              bottom: 32.0,
              left: cardIsOnLeft ? (halfWidth + 72.0) : 0.0,
              width: halfWidth,
              child: Align(
                alignment: cardIsOnLeft ? Alignment.topLeft : Alignment.topRight,
                child: dateWidget,
              ),
            ),
          ],
        );
      },
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Mobile / Tablet Single-Sided Milestone Row
  // ───────────────────────────────────────────────────────────────────────────

  Widget _buildMobileMilestoneRow({
    required TimelineMilestone milestone,
    required int index,
    required bool isFirst,
    required bool isLast,
    required bool isHovered,
    required bool isDark,
    required bool isCompact,
    required bool isArabic,
    required Color primaryText,
    required Color secondaryText,
    required Color bodyText,
    required Color accentColor,
    required double pulseProgress,
  }) {
    final categoryAccent = _getCategoryAccent(milestone.category, isDark);

    final spineNode = _TimelineSpineNode(
      milestone: milestone,
      isFirst: isFirst,
      isLast: isLast,
      isHovered: isHovered,
      isDark: isDark,
      isArabic: isArabic,
      categoryAccent: categoryAccent,
      pulseProgress: pulseProgress,
      cardIsOnLeft: false, // in single-sided layout, card is always to the trailing side
      isMobile: true,
      nodeYOffset: 28.0,
      onHover: (hovered) => setState(() => _hoveredIndex = hovered ? index : -1),
    );

    final cardWidget = MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = -1),
      child: _MilestoneCard(
        milestone: milestone,
        isDark: isDark,
        isArabic: isArabic,
        isHovered: isHovered,
        primaryText: primaryText,
        secondaryText: secondaryText,
        bodyText: bodyText,
        categoryAccent: categoryAccent,
      ),
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 1. Primary Height-Determining Child: The Milestone Card
        Padding(
          padding: EdgeInsets.only(
            left: isArabic ? 0.0 : 48.0,
            right: isArabic ? 48.0 : 0.0,
            bottom: 28.0,
          ),
          child: cardWidget,
        ),

        // 2. Spine Column (Positioned to match card height + 28px bottom margin)
        Positioned(
          top: 0,
          bottom: 0,
          left: isArabic ? null : 0.0,
          right: isArabic ? 0.0 : null,
          width: 48.0,
          child: spineNode,
        ),
      ],
    );
  }

  Color _getCategoryAccent(ExperienceCategory category, bool isDark) {
    switch (category) {
      case ExperienceCategory.professional:
        return const Color(0xFF8B5E83); // Mauve Plum
      case ExperienceCategory.teaching:
        return const Color(0xFF6B8FB2); // Slate Azure
      case ExperienceCategory.mentorship:
        return const Color(0xFF6A9984); // Sage Rose
      case ExperienceCategory.leadership:
        return const Color(0xFF9E6B8E); // Radiant Orchid Plum
      case ExperienceCategory.training:
        return const Color(0xFFB8860B).withValues(alpha: isDark ? 0.90 : 1.0); // Amber Ochre
      case ExperienceCategory.development:
        return const Color(0xFF8A6EA8); // Deep Lavender Plum
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Timeline Spine Node & Continuous Connecting Line Custom Painter
// ─────────────────────────────────────────────────────────────────────────────

class _TimelineSpineNode extends StatelessWidget {
  const _TimelineSpineNode({
    required this.milestone,
    required this.isFirst,
    required this.isLast,
    required this.isHovered,
    required this.isDark,
    required this.isArabic,
    required this.categoryAccent,
    required this.pulseProgress,
    required this.cardIsOnLeft,
    required this.isMobile,
    required this.nodeYOffset,
    required this.onHover,
  });

  final TimelineMilestone milestone;
  final bool isFirst;
  final bool isLast;
  final bool isHovered;
  final bool isDark;
  final bool isArabic;
  final Color categoryAccent;
  final double pulseProgress;
  final bool cardIsOnLeft;
  final bool isMobile;
  final double nodeYOffset;
  final ValueChanged<bool> onHover;

  @override
  Widget build(BuildContext context) {
    final columnWidth = isMobile ? 48.0 : 72.0;
    final centerX = columnWidth / 2;
    final nodeRadius = isMobile ? 14.0 : 18.0;

    return RepaintBoundary(
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: _SpineConnectingLinePainter(
              centerX: centerX,
              nodeY: nodeYOffset,
              nodeRadius: nodeRadius,
              isFirst: isFirst,
              isLast: isLast,
              isHovered: isHovered,
              cardIsOnLeft: cardIsOnLeft,
              isMobile: isMobile,
              isArabic: isArabic,
              categoryAccent: categoryAccent,
              isDark: isDark,
              pulseProgress: pulseProgress,
              itemIndex: milestone.id,
            ),
          ),
          Positioned(
            top: nodeYOffset - nodeRadius,
            left: centerX - nodeRadius,
            width: nodeRadius * 2,
            height: nodeRadius * 2,
            child: MouseRegion(
              onEnter: (_) => onHover(true),
              onExit: (_) => onHover(false),
              cursor: SystemMouseCursors.click,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: nodeRadius * 2,
                height: nodeRadius * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? AppColors.darkSurfaceVariant : Colors.white,
                  border: Border.all(
                    color: isHovered
                        ? categoryAccent
                        : categoryAccent.withValues(alpha: isDark ? 0.65 : 0.50),
                    width: isHovered ? 2.2 : 1.6,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: categoryAccent.withValues(alpha: isHovered ? 0.45 : 0.20),
                      blurRadius: isHovered ? 16 : 8,
                      spreadRadius: isHovered ? 2 : 0,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    milestone.icon ?? Icons.circle_rounded,
                    size: isMobile ? 14 : 17,
                    color: isHovered ? categoryAccent : categoryAccent.withValues(alpha: 0.90),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Spine Connecting Line Custom Painter (Continuous, Seamless, and Pulsing)
// ─────────────────────────────────────────────────────────────────────────────

class _SpineConnectingLinePainter extends CustomPainter {
  _SpineConnectingLinePainter({
    required this.centerX,
    required this.nodeY,
    required this.nodeRadius,
    required this.isFirst,
    required this.isLast,
    required this.isHovered,
    required this.cardIsOnLeft,
    required this.isMobile,
    required this.isArabic,
    required this.categoryAccent,
    required this.isDark,
    required this.pulseProgress,
    required this.itemIndex,
  });

  final double centerX;
  final double nodeY;
  final double nodeRadius;
  final bool isFirst;
  final bool isLast;
  final bool isHovered;
  final bool cardIsOnLeft;
  final bool isMobile;
  final bool isArabic;
  final Color categoryAccent;
  final bool isDark;
  final double pulseProgress;
  final int itemIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final baseLineColor = isDark
        ? AppColors.darkBorder.withValues(alpha: 0.70)
        : AppColors.lightBorder.withValues(alpha: 0.85);

    final spinePaint = Paint()
      ..color = baseLineColor
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // 1. Draw Vertical Spine Line Segment
    // For middle items: line goes from top (y=0) to bottom (y=height), passing through the node.
    // For the first item: line starts at node center and extends down to bottom.
    // For the last item: line starts at top and ends at node center.
    final startY = isFirst ? nodeY : 0.0;
    final endY = isLast ? nodeY : size.height;

    canvas.drawLine(
      Offset(centerX, startY),
      Offset(centerX, endY),
      spinePaint,
    );

    // 2. Traveling Light Pulse along this vertical segment
    // Calculate fractional progression for this item (itemIndex 1..7 maps to 0.0 .. 1.0)
    final itemFraction = (itemIndex - 1) / 7.0;
    final pulseDistance = (pulseProgress - itemFraction).abs();

    if (pulseDistance < 0.22) {
      final pulseAlpha = (1.0 - (pulseDistance / 0.22)) * (isDark ? 0.85 : 0.70);
      final pulsePaint = Paint()
        ..color = categoryAccent.withValues(alpha: pulseAlpha)
        ..strokeWidth = 2.8
        ..strokeCap = StrokeCap.round;

      final pStart = (startY + (nodeY - startY) * 0.2).clamp(startY, endY);
      final pEnd = (nodeY + (endY - nodeY) * 0.8).clamp(startY, endY);

      canvas.drawLine(
        Offset(centerX, pStart),
        Offset(centerX, pEnd),
        pulsePaint,
      );
    }

    // 3. Horizontal Connecting Branch to the Milestone Card
    final branchPaint = Paint()
      ..color = isHovered
          ? categoryAccent.withValues(alpha: 0.90)
          : categoryAccent.withValues(alpha: isDark ? 0.35 : 0.30)
      ..strokeWidth = isHovered ? 1.8 : 1.2
      ..strokeCap = StrokeCap.round;

    if (isMobile) {
      if (isArabic) {
        // In Arabic RTL mobile: spine is on the right, card is on the left
        final branchStartX = centerX - nodeRadius;
        const branchEndX = 0.0;
        canvas.drawLine(
          Offset(branchStartX, nodeY),
          Offset(branchEndX, nodeY),
          branchPaint,
        );

        canvas.drawCircle(
          Offset(branchEndX, nodeY),
          isHovered ? 2.5 : 1.8,
          branchPaint..style = PaintingStyle.fill,
        );
      } else {
        // In English LTR mobile: spine is on the left, card is on the right
        final branchStartX = centerX + nodeRadius;
        final branchEndX = size.width;
        canvas.drawLine(
          Offset(branchStartX, nodeY),
          Offset(branchEndX, nodeY),
          branchPaint,
        );

        // Terminal micro-anchor dot at branch connection
        canvas.drawCircle(
          Offset(branchEndX, nodeY),
          isHovered ? 2.5 : 1.8,
          branchPaint..style = PaintingStyle.fill,
        );
      }
    } else {
      // In desktop alternating mode:
      if (cardIsOnLeft) {
        // Card is to the left of the spine
        final branchStartX = centerX - nodeRadius;
        const branchEndX = 0.0;
        canvas.drawLine(
          Offset(branchStartX, nodeY),
          Offset(branchEndX, nodeY),
          branchPaint,
        );

        canvas.drawCircle(
          Offset(branchEndX, nodeY),
          isHovered ? 2.8 : 2.0,
          branchPaint..style = PaintingStyle.fill,
        );
      } else {
        // Card is to the right of the spine
        final branchStartX = centerX + nodeRadius;
        final branchEndX = size.width;
        canvas.drawLine(
          Offset(branchStartX, nodeY),
          Offset(branchEndX, nodeY),
          branchPaint,
        );

        canvas.drawCircle(
          Offset(branchEndX, nodeY),
          isHovered ? 2.8 : 2.0,
          branchPaint..style = PaintingStyle.fill,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SpineConnectingLinePainter oldDelegate) {
    return oldDelegate.pulseProgress != pulseProgress ||
        oldDelegate.isHovered != isHovered ||
        oldDelegate.isDark != isDark ||
        oldDelegate.isArabic != isArabic;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Milestone Card (Rich, Interactive, Structured, Fully Visible)
// ─────────────────────────────────────────────────────────────────────────────

class _MilestoneCard extends StatelessWidget {
  const _MilestoneCard({
    required this.milestone,
    required this.isDark,
    required this.isArabic,
    required this.isHovered,
    required this.primaryText,
    required this.secondaryText,
    required this.bodyText,
    required this.categoryAccent,
  });

  final TimelineMilestone milestone;
  final bool isDark;
  final bool isArabic;
  final bool isHovered;
  final Color primaryText;
  final Color secondaryText;
  final Color bodyText;
  final Color categoryAccent;

  String _getCategoryLabel(AppLocalizations l10n, ExperienceCategory cat) {
    switch (cat) {
      case ExperienceCategory.professional:
        return l10n.expTypeInternship;
      case ExperienceCategory.teaching:
        return l10n.expTypeInstruction;
      case ExperienceCategory.mentorship:
        return l10n.expTypeMentorship;
      case ExperienceCategory.leadership:
        return l10n.expTypeLeadership;
      case ExperienceCategory.training:
        return l10n.expTypeTraining;
      case ExperienceCategory.development:
        return l10n.expTypeInitiative;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final categoryLabel = _getCategoryLabel(l10n, milestone.category);

    final cardBg = isDark
        ? (isHovered ? AppColors.darkSurfaceVariant : AppColors.darkSurface)
        : (isHovered ? const Color(0xFFF3EBF0) : AppColors.lightSurface);

    final borderColor = isHovered
        ? categoryAccent.withValues(alpha: 0.65)
        : (isDark
            ? AppColors.darkBorder.withValues(alpha: 0.60)
            : AppColors.lightBorder.withValues(alpha: 0.70));

    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      transform: Matrix4.translationValues(0, isHovered ? -4.0 : 0.0, 0),
      constraints: const BoxConstraints(maxWidth: 580),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: isHovered ? 1.4 : 1.0),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : AppColors.deepPlum)
                .withValues(alpha: isHovered ? 0.22 : 0.06),
            blurRadius: isHovered ? 26 : 10,
            offset: Offset(0, isHovered ? 8 : 3),
          ),
          if (isHovered)
            BoxShadow(
              color: categoryAccent.withValues(alpha: 0.14),
              blurRadius: 32,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Row 1: Category Badge + Date Badge (if mobile) ──────────
          Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: isArabic ? WrapAlignment.end : WrapAlignment.start,
            children: [
              _CategoryBadge(
                label: categoryLabel,
                color: categoryAccent,
                icon: milestone.icon,
              ),
              if (milestone.period.isNotEmpty)
                _PeriodBadge(
                  period: milestone.period,
                  isDateNotSpecified: milestone.isDateNotSpecified,
                  color: secondaryText,
                  accentColor: categoryAccent,
                  isDark: isDark,
                ),
              if (milestone.duration != null)
                _DurationBadge(
                  duration: milestone.duration!,
                  color: categoryAccent,
                ),
            ],
          ),

          const SizedBox(height: 14),

          // ── Row 2: Role Title ────────────────────────────────────────
          Text(
            milestone.role,
            textAlign: isArabic ? TextAlign.right : TextAlign.left,
            style: isArabic
                ? GoogleFonts.amiri(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: primaryText,
                    height: 1.3,
                  )
                : GoogleFonts.outfit(
                    fontSize: 18.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                    color: primaryText,
                    height: 1.25,
                  ),
          ),

          const SizedBox(height: 6),

          // ── Row 3: Organization ──────────────────────────────────────
          Row(
            mainAxisSize: MainAxisSize.min,
            children: isArabic
                ? [
                    Flexible(
                      child: Text(
                        milestone.organization,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.outfit(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: categoryAccent,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(Icons.apartment_rounded, size: 14, color: categoryAccent),
                  ]
                : [
                    Icon(Icons.apartment_rounded, size: 14, color: categoryAccent),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        milestone.organization,
                        style: GoogleFonts.outfit(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: categoryAccent,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
          ),

          const SizedBox(height: 14),

          // ── Row 4: Description (Structured Tracks or Bullet Points) ──
          if (milestone.technicalTrackDesc != null && milestone.nonTechnicalTrackDesc != null)
            _buildStructuredTracksBlock(milestone, isDark, isArabic, primaryText, bodyText, categoryAccent)
          else
            _buildBulletPointsBlock(milestone.descriptionPoints, isArabic, bodyText, categoryAccent),

          const SizedBox(height: 16),

          // ── Row 5: Skill & Topic Chips ───────────────────────────────
          Wrap(
            spacing: 8,
            runSpacing: 7,
            alignment: isArabic ? WrapAlignment.end : WrapAlignment.start,
            children: milestone.tags.map((tag) {
              return _SkillChip(
                label: tag,
                isDark: isDark,
                accentColor: categoryAccent,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPointsBlock(
    List<String> points,
    bool isArabic,
    Color bodyText,
    Color accentColor,
  ) {
    return Column(
      crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: points.map((point) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 7.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: isArabic
                ? [
                    Expanded(
                      child: Text(
                        point,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          height: 1.62,
                          color: bodyText,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.85),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ]
                : [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.85),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        point,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          height: 1.62,
                          color: bodyText,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStructuredTracksBlock(
    TimelineMilestone milestone,
    bool isDark,
    bool isArabic,
    Color primaryText,
    Color bodyText,
    Color categoryAccent,
  ) {
    return Column(
      crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        // Technical Track Block
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: categoryAccent.withValues(alpha: isDark ? 0.08 : 0.06),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: categoryAccent.withValues(alpha: 0.22),
              width: 0.9,
            ),
          ),
          child: Column(
            crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: isArabic
                    ? [
                        Text(
                          milestone.technicalTrackTitle ?? '',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: categoryAccent,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(Icons.code_rounded, size: 14, color: categoryAccent),
                      ]
                    : [
                        Icon(Icons.code_rounded, size: 14, color: categoryAccent),
                        const SizedBox(width: 6),
                        Text(
                          milestone.technicalTrackTitle ?? '',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: categoryAccent,
                          ),
                        ),
                      ],
              ),
              const SizedBox(height: 5),
              Text(
                milestone.technicalTrackDesc ?? '',
                textAlign: isArabic ? TextAlign.right : TextAlign.left,
                style: GoogleFonts.outfit(
                  fontSize: 13.5,
                  height: 1.58,
                  color: bodyText,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Non-Technical Track Block
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: categoryAccent.withValues(alpha: isDark ? 0.05 : 0.04),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: categoryAccent.withValues(alpha: 0.16),
              width: 0.8,
            ),
          ),
          child: Column(
            crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: isArabic
                    ? [
                        Text(
                          milestone.nonTechnicalTrackTitle ?? '',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: categoryAccent,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(Icons.psychology_rounded, size: 14, color: categoryAccent),
                      ]
                    : [
                        Icon(Icons.psychology_rounded, size: 14, color: categoryAccent),
                        const SizedBox(width: 6),
                        Text(
                          milestone.nonTechnicalTrackTitle ?? '',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: categoryAccent,
                          ),
                        ),
                      ],
              ),
              const SizedBox(height: 5),
              Text(
                milestone.nonTechnicalTrackDesc ?? '',
                textAlign: isArabic ? TextAlign.right : TextAlign.left,
                style: GoogleFonts.outfit(
                  fontSize: 13.5,
                  height: 1.58,
                  color: bodyText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Desktop Opposite Date & Period Badge (Balanced Column)
// ─────────────────────────────────────────────────────────────────────────────

class _OppositeDateBadge extends StatelessWidget {
  const _OppositeDateBadge({
    required this.period,
    required this.duration,
    required this.isDateNotSpecified,
    required this.alignLeft,
    required this.categoryAccent,
    required this.isDark,
    required this.isArabic,
    required this.isHovered,
  });

  final String period;
  final String? duration;
  final bool isDateNotSpecified;
  final bool alignLeft;
  final Color categoryAccent;
  final bool isDark;
  final bool isArabic;
  final bool isHovered;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        crossAxisAlignment: alignLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: isHovered
                  ? categoryAccent.withValues(alpha: isDark ? 0.22 : 0.16)
                  : (isDark
                      ? AppColors.darkSurface.withValues(alpha: 0.70)
                      : AppColors.lightSurface.withValues(alpha: 0.85)),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isHovered
                    ? categoryAccent.withValues(alpha: 0.65)
                    : (isDark
                        ? AppColors.darkBorder.withValues(alpha: 0.60)
                        : AppColors.lightBorder.withValues(alpha: 0.65)),
                width: 1.0,
              ),
              boxShadow: isHovered
                  ? [
                      BoxShadow(
                        color: categoryAccent.withValues(alpha: 0.16),
                        blurRadius: 14,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isDateNotSpecified ? Icons.history_edu_rounded : Icons.calendar_today_rounded,
                  size: 13,
                  color: categoryAccent,
                ),
                const SizedBox(width: 8),
                Text(
                  period,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                    color: isDark ? AppColors.ivory : AppColors.deepPlum,
                  ),
                ),
              ],
            ),
          ),
          if (duration != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: categoryAccent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: categoryAccent.withValues(alpha: 0.35), width: 0.8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.schedule_rounded, size: 12, color: categoryAccent),
                  const SizedBox(width: 6),
                  Text(
                    duration!,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: categoryAccent,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Badges & Micro-Widgets
// ─────────────────────────────────────────────────────────────────────────────

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({
    required this.label,
    required this.color,
    this.icon,
  });

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodBadge extends StatelessWidget {
  const _PeriodBadge({
    required this.period,
    required this.isDateNotSpecified,
    required this.color,
    required this.accentColor,
    required this.isDark,
  });

  final String period;
  final bool isDateNotSpecified;
  final Color color;
  final Color accentColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceVariant.withValues(alpha: 0.65)
            : AppColors.lightSurfaceVariant.withValues(alpha: 0.70),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorder.withValues(alpha: 0.55)
              : AppColors.lightBorder.withValues(alpha: 0.60),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isDateNotSpecified ? Icons.history_edu_rounded : Icons.calendar_today_rounded,
            size: 11,
            color: color,
          ),
          const SizedBox(width: 5),
          Text(
            period,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              color: color,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _DurationBadge extends StatelessWidget {
  const _DurationBadge({required this.duration, required this.color});
  final String duration;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.32), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.schedule_rounded, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            duration,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  const _SkillChip({
    required this.label,
    required this.isDark,
    required this.accentColor,
  });

  final String label;
  final bool isDark;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceVariant.withValues(alpha: 0.70)
            : AppColors.lightSurfaceVariant.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorder.withValues(alpha: 0.55)
              : AppColors.lightBorder.withValues(alpha: 0.60),
          width: 0.8,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isDark
              ? AppColors.ivory.withValues(alpha: 0.82)
              : AppColors.deepPlum.withValues(alpha: 0.80),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Architectural Section Bottom Divider
// ─────────────────────────────────────────────────────────────────────────────

class _SectionBottomDivider extends StatelessWidget {
  const _SectionBottomDivider({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final c = isDark
        ? AppColors.darkBorder.withValues(alpha: 0.50)
        : AppColors.lightBorder.withValues(alpha: 0.60);

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 1.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                c,
                c,
                Colors.transparent,
              ],
              stops: const [0.0, 0.2, 0.8, 1.0],
            ),
          ),
        ),
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: isDark ? AppColors.dustyRose : AppColors.mauve,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: (isDark ? AppColors.dustyRose : AppColors.mauve).withValues(alpha: 0.4),
                blurRadius: 6,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Viewport Visibility Trigger (Reliable, one-shot scroll activation)
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
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
  }

  void _checkVisibility() {
    if (_fired || !mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached || !box.hasSize) return;

    try {
      final pos = box.localToGlobal(Offset.zero);
      final screenH = MediaQuery.sizeOf(context).height;

      // Trigger reveal as soon as element nears the bottom of the viewport
      if (pos.dy < screenH + 180) {
        _fired = true;
        widget.onVisible();
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (!_fired) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
    }
    return widget.child;
  }
}
