import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/responsive/responsive_utils.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/url_launcher_web.dart';
import '../../../../core/widgets/brand_icons.dart';
import '../../../../l10n/generated/app_localizations.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Centralized Asset & Link Configurations
// ─────────────────────────────────────────────────────────────────────────────

/// Centralized image assets for Sanad project (All 5 supplied authentic screenshots).
class SanadImageConfig {
  SanadImageConfig._();

  static const List<String> images = [
    'assets/images/projects/sanad/sanad_1.jpg',
    'assets/images/projects/sanad/sanad_2.jpg',
    'assets/images/projects/sanad/sanad_3.jpg',
    'assets/images/projects/sanad/sanad_4.jpg',
    'assets/images/projects/sanad/sanad_5.jpg',
  ];
}

/// Centralized image assets for Qoot project (All 3 supplied authentic images).
class QootImageConfig {
  QootImageConfig._();

  static const List<String> images = [
    'assets/images/projects/qoot/qoot_1.jpg',
    'assets/images/projects/qoot/qoot_2.jpg',
    'assets/images/projects/qoot/qoot_3.jpg',
  ];
}

/// Centralized image assets for NutriMind project (All 3 supplied authentic images).
class NutrimindImageConfig {
  NutrimindImageConfig._();

  static const List<String> images = [
    'assets/images/projects/nutrimind/nutrimind_1.jpg',
    'assets/images/projects/nutrimind/nutrimind_2.jpg',
    'assets/images/projects/nutrimind/nutrimind_3.jpg',
  ];
}

/// Centralized image assets for Rafeeq project (All 2 supplied authentic images).
class RafeeqImageConfig {
  RafeeqImageConfig._();

  static const List<String> images = [
    'assets/images/projects/rafeeq/rafeeq_1.jpg',
    'assets/images/projects/rafeeq/rafeeq_2.jpg',
  ];
}

/// Centralized URLs and store configuration for Sanad project.
class SanadConfig {
  SanadConfig._();

  static const String officialWebsiteUrl = 'https://sanad-legal.vercel.app/';
  static const String? playStoreUrl = null;
  static const String? appStoreUrl = null;

  static bool get hasPlayStore =>
      playStoreUrl != null && playStoreUrl!.trim().isNotEmpty;
  static bool get hasAppStore =>
      appStoreUrl != null && appStoreUrl!.trim().isNotEmpty;
}

// ─────────────────────────────────────────────────────────────────────────────
// Project Model
// ─────────────────────────────────────────────────────────────────────────────

class ProjectData {
  const ProjectData({
    required this.id,
    required this.milestoneNumber,
    required this.title,
    required this.category,
    required this.description,
    required this.technologies,
    required this.accentColor,
    required this.headerIcon,
    this.roleContribution,
    this.githubUrl,
    this.websiteUrl,
    this.isSanad = false,
    this.coverImages = const [],
  });

  final String id;
  final String milestoneNumber;
  final String title;
  final String category;
  final String? roleContribution;
  final String description;
  final List<String> technologies;
  final String? githubUrl;
  final String? websiteUrl;
  final Color accentColor;
  final IconData headerIcon;
  final bool isSanad;
  final List<String> coverImages;
}

// ─────────────────────────────────────────────────────────────────────────────
// Projects Section Main Widget (Animated Zigzag Journey)
// ─────────────────────────────────────────────────────────────────────────────

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection>
    with SingleTickerProviderStateMixin {
  String? _hoveredProjectId;

  late final AnimationController _timelineAnimController;
  late final Animation<double> _pathDrawAnim;
  late final Animation<double> _pulseLoopAnim;

  final GlobalKey _containerKey = GlobalKey();
  final List<GlobalKey> _nodeKeys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];

  List<Offset> _measuredNodeOffsets = [];

  @override
  void initState() {
    super.initState();
    _timelineAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _pathDrawAnim = CurvedAnimation(
      parent: _timelineAnimController,
      curve: Curves.easeInOutCubic,
    );

    _pulseLoopAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _timelineAnimController,
        curve: Curves.linear,
      ),
    );

    _timelineAnimController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) => _measureNodePositions());
  }

  @override
  void dispose() {
    _timelineAnimController.dispose();
    super.dispose();
  }

  void _measureNodePositions() {
    if (!mounted) return;
    final containerBox =
        _containerKey.currentContext?.findRenderObject() as RenderBox?;
    if (containerBox == null || !containerBox.hasSize) return;

    final List<Offset> offsets = [];
    for (final key in _nodeKeys) {
      final nodeBox = key.currentContext?.findRenderObject() as RenderBox?;
      if (nodeBox != null && nodeBox.hasSize) {
        final localPos =
            nodeBox.localToGlobal(Offset.zero, ancestor: containerBox);
        offsets.add(localPos + Offset(nodeBox.size.width / 2, nodeBox.size.height / 2));
      }
    }

    if (offsets.length == _nodeKeys.length) {
      setState(() {
        _measuredNodeOffsets = offsets;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = context.isWide;
    final isCompact = context.isCompact;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final projects = _getProjectDataList(l10n);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── 1. Section Header ──────────────────────────────────────────
        _buildSectionHeader(l10n, isDark, isDesktop, isCompact),

        const SizedBox(height: 36),

        // ── 2. Animated Zigzag Projects Journey ────────────────────────
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1040),
            child: NotificationListener<SizeChangedLayoutNotification>(
              onNotification: (_) {
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => _measureNodePositions());
                return true;
              },
              child: SizeChangedLayoutNotifier(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    WidgetsBinding.instance
                        .addPostFrameCallback((_) => _measureNodePositions());

                    return Stack(
                      key: _containerKey,
                      children: [
                        // A. Background Animated Zigzag Path
                        if (_measuredNodeOffsets.length >= 2)
                          Positioned.fill(
                            child: AnimatedBuilder(
                              animation: _timelineAnimController,
                              builder: (context, _) {
                                return CustomPaint(
                                  painter: _ZigzagPathPainter(
                                    nodePoints: _measuredNodeOffsets,
                                    drawProgress: _pathDrawAnim.value,
                                    pulseProgress: _pulseLoopAnim.value,
                                    isDark: isDark,
                                  ),
                                );
                              },
                            ),
                          ),

                        // B. Projects Journey Steps (Desktop Alternating or Mobile Stack)
                        if (constraints.maxWidth >= 840)
                          _buildDesktopZigzagJourney(
                            projects,
                            isDark,
                            isArabic,
                            constraints.maxWidth,
                          )
                        else
                          _buildMobileTimelineJourney(
                            projects,
                            isDark,
                            isArabic,
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildSectionHeader(
    AppLocalizations l10n,
    bool isDark,
    bool isDesktop,
    bool isCompact,
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
                Icons.alt_route_rounded,
                size: 13,
                color: isDark ? AppColors.dustyRose : AppColors.mauve,
              ),
              const SizedBox(width: 6),
              Text(
                l10n.projectsSectionTag,
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

        const SizedBox(height: 12),

        // Main Heading
        Text(
          l10n.projectsSectionHeading,
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            fontSize: isCompact ? 28 : (isDesktop ? 38 : 32),
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            color: primaryTextColor,
            height: 1.15,
          ),
        ),

        const SizedBox(height: 10),

        // Subtitle
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Text(
            l10n.projectsSectionSubtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: isCompact ? 13.5 : 15.0,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: subtitleColor,
            ),
          ),
        ),
      ],
    );
  }



  // ── Desktop Connected Zigzag Journey (Alternating Left & Right) ─────────────

  Widget _buildDesktopZigzagJourney(
    List<ProjectData> projects,
    bool isDark,
    bool isArabic,
    double totalWidth,
  ) {
    // Narrow, elegant card width: 350px to 410px
    final double cardWidth =
        ((totalWidth / 2) - 72.0).clamp(320.0, 410.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(projects.length, (index) {
        final project = projects[index];
        // Mandatory Zigzag logic:
        // Even index (0: Sanad, 2: NutriMind) -> Left side of axis (or Right in Arabic)
        // Odd index (1: Qoot, 3: Rafeeq) -> Right side of axis (or Left in Arabic)
        final isStartSide = (index % 2 == 0);
        final isLeftAligned = isArabic ? !isStartSide : isStartSide;

        return Padding(
          padding: EdgeInsets.only(
            bottom: index == projects.length - 1 ? 0.0 : 44.0,
          ),
          child: _DesktopZigzagMilestoneRow(
            key: ValueKey(project.id),
            project: project,
            nodeKey: _nodeKeys[index % _nodeKeys.length],
            cardWidth: cardWidth,
            isLeftAligned: isLeftAligned,
            isDark: isDark,
            isArabic: isArabic,
            totalWidth: totalWidth,
            isHovered: _hoveredProjectId == project.id,
            onHover: (hovered) {
              setState(() {
                _hoveredProjectId = hovered ? project.id : null;
              });
            },
          ),
        );
      }),
    );
  }

  // ── Mobile Single-Sided Timeline Journey ───────────────────────────────────

  Widget _buildMobileTimelineJourney(
    List<ProjectData> projects,
    bool isDark,
    bool isArabic,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(projects.length, (index) {
        final project = projects[index];
        return Padding(
          padding: EdgeInsets.only(
            bottom: index == projects.length - 1 ? 0.0 : 32.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: isArabic
                ? [
                    // Right-to-Left on Mobile
                    Expanded(
                      child: _NarrowProjectCard(
                        project: project,
                        isDark: isDark,
                        isArabic: isArabic,
                        isHovered: _hoveredProjectId == project.id,
                        onHover: (hovered) {
                          setState(() {
                            _hoveredProjectId = hovered ? project.id : null;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 14),
                    _MilestoneNodeBadge(
                      key: _nodeKeys[index % _nodeKeys.length],
                      number: project.milestoneNumber,
                      accentColor: project.accentColor,
                      isDark: isDark,
                      isHighlighted: _hoveredProjectId == project.id,
                    ),
                  ]
                : [
                    // Left-to-Right on Mobile
                    _MilestoneNodeBadge(
                      key: _nodeKeys[index % _nodeKeys.length],
                      number: project.milestoneNumber,
                      accentColor: project.accentColor,
                      isDark: isDark,
                      isHighlighted: _hoveredProjectId == project.id,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _NarrowProjectCard(
                        project: project,
                        isDark: isDark,
                        isArabic: isArabic,
                        isHovered: _hoveredProjectId == project.id,
                        onHover: (hovered) {
                          setState(() {
                            _hoveredProjectId = hovered ? project.id : null;
                          });
                        },
                      ),
                    ),
                  ],
          ),
        );
      }),
    );
  }

  // ── Project Data List (STRICT MANDATORY ORDER) ─────────────────────────────

  List<ProjectData> _getProjectDataList(AppLocalizations l10n) {
    return [
      // 1. Sanad — Legal Services App (Milestone 01)
      ProjectData(
        id: 'sanad',
        milestoneNumber: '01',
        title: l10n.projectSanadTitle,
        category: l10n.projectSanadCategory,
        description: l10n.projectSanadDesc,
        technologies: const [
          'Flutter & Dart',
          'AI Legal Chatbot',
          'REST APIs',
          'Case Booking',
        ],
        githubUrl: null, // Strict rule: No GitHub button for Sanad
        websiteUrl: SanadConfig.officialWebsiteUrl,
        isSanad: true,
        accentColor: const Color(0xFFC2410C), // Legal Terracotta
        headerIcon: Icons.gavel_rounded,
        coverImages: SanadImageConfig.images,
      ),

      // 2. Qoot — Food Donation App (Milestone 02, 3 Authentic Images)
      ProjectData(
        id: 'qoot',
        milestoneNumber: '02',
        title: l10n.projectQootTitle,
        category: l10n.projectQootCategory,
        roleContribution: l10n.projectQootRole,
        description: l10n.projectQootDesc,
        technologies: const [
          'Flutter & Dart',
          'BLoC / Cubit',
          'Clean Architecture',
          'REST APIs',
        ],
        githubUrl: 'https://github.com/theahmedhany/qoot',
        accentColor: const Color(0xFFD97706), // Donation Amber
        headerIcon: Icons.volunteer_activism_rounded,
        coverImages: QootImageConfig.images,
      ),

      // 3. NutriMind — Nutrition & Mental Wellness App (Milestone 03)
      ProjectData(
        id: 'nutrimind',
        milestoneNumber: '03',
        title: l10n.projectNutrimindTitle,
        category: l10n.projectNutrimindCategory,
        description: l10n.projectNutrimindDesc,
        technologies: const [
          'Flutter & Dart',
          'BLoC / Cubit',
          'Firebase',
          'Groq Vision AI',
        ],
        githubUrl: 'https://github.com/romisaa5/NutriMind-App',
        accentColor: const Color(0xFF15803D), // Nutrition Emerald
        headerIcon: Icons.psychology_rounded,
        coverImages: NutrimindImageConfig.images,
      ),

      // 4. Rafeeq — Founder & Investor Platform (Milestone 04)
      ProjectData(
        id: 'rafeeq',
        milestoneNumber: '04',
        title: l10n.projectRafeeqTitle,
        category: l10n.projectRafeeqCategory,
        description: l10n.projectRafeeqDesc,
        technologies: const [
          'Flutter & Dart',
          'BLoC Architecture',
          'REST APIs',
          'Pitch Wizard',
        ],
        githubUrl: 'https://github.com/Rafeeq-Software-Project/mobile-app',
        accentColor: const Color(0xFF2563EB), // Startup Royal Blue
        headerIcon: Icons.rocket_launch_rounded,
        coverImages: RafeeqImageConfig.images,
      ),
    ];
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Desktop Zigzag Row (Card on Left/Right + Centered Connecting Node)
// ─────────────────────────────────────────────────────────────────────────────

class _DesktopZigzagMilestoneRow extends StatelessWidget {
  const _DesktopZigzagMilestoneRow({
    super.key,
    required this.project,
    required this.nodeKey,
    required this.cardWidth,
    required this.isLeftAligned,
    required this.isDark,
    required this.isArabic,
    required this.totalWidth,
    required this.isHovered,
    required this.onHover,
  });

  final ProjectData project;
  final GlobalKey nodeKey;
  final double cardWidth;
  final bool isLeftAligned;
  final bool isDark;
  final bool isArabic;
  final double totalWidth;
  final bool isHovered;
  final ValueChanged<bool> onHover;

  @override
  Widget build(BuildContext context) {
    const double nodeSize = 34.0;
    const double connectorWidth = 16.0;
    const double amplitude = 32.0;

    final double centerX = totalWidth / 2;

    // Node center is offset from the center axis:
    // Left-aligned project node is at centerX - amplitude
    // Right-aligned project node is at centerX + amplitude
    final double nodeCenter = isLeftAligned
        ? (centerX - amplitude)
        : (centerX + amplitude);

    final double nodeLeft = nodeCenter - (nodeSize / 2);

    final cardWidget = SizedBox(
      width: cardWidth,
      child: _NarrowProjectCard(
        project: project,
        isDark: isDark,
        isArabic: isArabic,
        isHovered: isHovered,
        onHover: onHover,
      ),
    );

    final nodeWidget = _MilestoneNodeBadge(
      key: nodeKey,
      number: project.milestoneNumber,
      accentColor: project.accentColor,
      isDark: isDark,
      isHighlighted: isHovered,
    );

    final connector = Container(
      width: connectorWidth,
      height: 2.0,
      decoration: BoxDecoration(
        color: project.accentColor.withValues(alpha: isHovered ? 0.75 : 0.35),
        borderRadius: BorderRadius.circular(1.0),
      ),
    );

    if (isLeftAligned) {
      // Card on Left: [Spacer] [Card] [Connector] [Node] [RightMargin]
      final double rightMargin =
          (totalWidth - (nodeLeft + nodeSize)).clamp(0.0, double.infinity);

      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          cardWidget,
          connector,
          nodeWidget,
          if (rightMargin > 0) SizedBox(width: rightMargin),
        ],
      );
    } else {
      // Card on Right: [LeftMargin] [Node] [Connector] [Card] [Spacer]
      final double leftMargin = nodeLeft.clamp(0.0, double.infinity);

      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leftMargin > 0) SizedBox(width: leftMargin),
          nodeWidget,
          connector,
          cardWidget,
          const Spacer(),
        ],
      );
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Milestone Circular Node Badge
// ─────────────────────────────────────────────────────────────────────────────

class _MilestoneNodeBadge extends StatelessWidget {
  const _MilestoneNodeBadge({
    super.key,
    required this.number,
    required this.accentColor,
    required this.isDark,
    required this.isHighlighted,
  });

  final String number;
  final Color accentColor;
  final bool isDark;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      width: isHighlighted ? 38 : 34,
      height: isHighlighted ? 38 : 34,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F1722) : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: isHighlighted
              ? accentColor
              : accentColor.withValues(alpha: isDark ? 0.60 : 0.45),
          width: isHighlighted ? 2.2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(
                alpha: isHighlighted ? 0.40 : 0.15),
            blurRadius: isHighlighted ? 14 : 6,
            spreadRadius: isHighlighted ? 1 : 0,
          ),
        ],
      ),
      child: Center(
        child: Text(
          number,
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
            color: isHighlighted
                ? accentColor
                : (isDark ? AppColors.ivory : AppColors.deepPlum),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Narrow, Compact, Editorial Project Card
// ─────────────────────────────────────────────────────────────────────────────

class _NarrowProjectCard extends StatelessWidget {
  const _NarrowProjectCard({
    required this.project,
    required this.isDark,
    required this.isArabic,
    required this.isHovered,
    required this.onHover,
  });

  final ProjectData project;
  final bool isDark;
  final bool isArabic;
  final bool isHovered;
  final ValueChanged<bool> onHover;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final primaryTextColor = isDark ? AppColors.ivory : AppColors.deepPlum;
    final bodyTextColor = isDark
        ? AppColors.ivory.withValues(alpha: 0.76)
        : AppColors.deepPlum.withValues(alpha: 0.80);

    final cardBg = isDark
        ? AppColors.darkSurface.withValues(alpha: isHovered ? 0.90 : 0.74)
        : Colors.white.withValues(alpha: isHovered ? 0.96 : 0.88);

    final borderColor = isHovered
        ? project.accentColor.withValues(alpha: 0.65)
        : (isDark
            ? AppColors.darkBorder.withValues(alpha: 0.85)
            : AppColors.lightBorder.withValues(alpha: 0.85));

    final glowColor =
        project.accentColor.withValues(alpha: isDark ? 0.16 : 0.07);

    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, isHovered ? -3.5 : 0.0, 0),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: isHovered ? 1.3 : 1.0),
          boxShadow: [
            BoxShadow(
              color: isHovered
                  ? glowColor
                  : Colors.black.withValues(alpha: isDark ? 0.16 : 0.03),
              blurRadius: isHovered ? 20 : 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── 1. Image Cover Area (Fixed 16:9 Aspect Ratio) ───────────────
            _ProjectCoverMediaArea(
              project: project,
              isDark: isDark,
              isHovered: isHovered,
              isArabic: isArabic,
            ),

            // ── 2. Content Details (Editorial, Clean, Scannable) ───────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              child: Column(
                crossAxisAlignment: isArabic
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Category Pill + Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: isArabic
                        ? [
                            _buildCategoryPill(project, isDark),
                            _buildHeaderIcon(project, isDark),
                          ]
                        : [
                            _buildCategoryPill(project, isDark),
                            _buildHeaderIcon(project, isDark),
                          ],
                  ),

                  const SizedBox(height: 8),

                  // Project Title
                  Text(
                    project.title,
                    textAlign: isArabic ? TextAlign.right : TextAlign.left,
                    style: GoogleFonts.outfit(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                      color: primaryTextColor,
                      height: 1.25,
                    ),
                  ),

                  // Optional Role Highlight (e.g. Qoot Charity Module Lead)
                  if (project.roleContribution != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: isArabic
                          ? [
                              Text(
                                project.roleContribution!,
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: project.accentColor,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.verified_user_rounded,
                                size: 12,
                                color: project.accentColor,
                              ),
                            ]
                          : [
                              Icon(
                                Icons.verified_user_rounded,
                                size: 12,
                                color: project.accentColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                project.roleContribution!,
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: project.accentColor,
                                ),
                              ),
                            ],
                    ),
                  ],

                  const SizedBox(height: 8),

                  // Concise 2–3 Line Summary
                  Text(
                    project.description,
                    textAlign: isArabic ? TextAlign.right : TextAlign.left,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: bodyTextColor,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Compact Technology Tags
                  Wrap(
                    spacing: 4.5,
                    runSpacing: 4.5,
                    alignment:
                        isArabic ? WrapAlignment.end : WrapAlignment.start,
                    children: project.technologies.take(4).map((t) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6.5, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: project.accentColor.withValues(
                              alpha: isDark ? 0.10 : 0.07),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: project.accentColor.withValues(alpha: 0.20),
                            width: 0.6,
                          ),
                        ),
                        child: Text(
                          t,
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.ivory
                                : AppColors.deepPlum,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 14),

                  // Clean Minimal Action Buttons
                  if (project.isSanad)
                    _SanadActionRow(
                      isDark: isDark,
                      accentColor: project.accentColor,
                      isArabic: isArabic,
                      l10n: l10n,
                    )
                  else if (project.githubUrl != null)
                    _ProjectActionButton.github(
                      url: project.githubUrl!,
                      label: l10n.projectGithubBtn,
                      tooltip: l10n.projectSourceCodeTooltip,
                      isDark: isDark,
                      accentColor: project.accentColor,
                      isArabic: isArabic,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPill(ProjectData project, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: project.accentColor.withValues(alpha: isDark ? 0.12 : 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: project.accentColor.withValues(alpha: 0.28),
          width: 0.7,
        ),
      ),
      child: Text(
        project.category,
        style: GoogleFonts.outfit(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
          color: project.accentColor,
        ),
      ),
    );
  }

  Widget _buildHeaderIcon(ProjectData project, bool isDark) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: project.accentColor.withValues(alpha: isDark ? 0.14 : 0.10),
        shape: BoxShape.circle,
      ),
      child: Icon(
        project.headerIcon,
        size: 13,
        color: project.accentColor,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable Fixed 16:9 Image Cover Area with Interactive Gallery
// ─────────────────────────────────────────────────────────────────────────────

class _ProjectCoverMediaArea extends StatefulWidget {
  const _ProjectCoverMediaArea({
    required this.project,
    required this.isDark,
    required this.isHovered,
    required this.isArabic,
  });

  final ProjectData project;
  final bool isDark;
  final bool isHovered;
  final bool isArabic;

  @override
  State<_ProjectCoverMediaArea> createState() => _ProjectCoverMediaAreaState();
}

class _ProjectCoverMediaAreaState extends State<_ProjectCoverMediaArea> {
  int _currentImageIndex = 0;

  void _nextImage(int total) {
    if (total <= 1) return;
    setState(() => _currentImageIndex = (_currentImageIndex + 1) % total);
  }

  void _prevImage(int total) {
    if (total <= 1) return;
    setState(() => _currentImageIndex = (_currentImageIndex - 1 + total) % total);
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final isDark = widget.isDark;
    final isCompact = context.isCompact;
    final images = project.coverImages;
    final hasImages = images.isNotEmpty;

    // Fixed 16:10 Aspect Ratio Container matching card width edge-to-edge
    return AspectRatio(
      aspectRatio: 16 / 10,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1720) : const Color(0xFFF1EAEF),
          border: Border(
            bottom: BorderSide(
              color: (isDark ? AppColors.darkBorder : AppColors.lightBorder)
                  .withValues(alpha: 0.8),
              width: 0.8,
            ),
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Media Render
            if (hasImages)
              _buildImageDisplay(images, isDark)
            else
              _buildBrandFallback(project, isDark),

            // Image Gallery Dots & Chevrons (if multiple images)
            if (hasImages && images.length > 1) ...[
              // Prev Chevron
              Positioned(
                left: 6,
                top: 0,
                bottom: 0,
                child: Center(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 180),
                    opacity: (widget.isHovered || isCompact) ? 1.0 : 0.0,
                    child: _GalleryNavButton(
                      icon: Icons.chevron_left_rounded,
                      onTap: () => _prevImage(images.length),
                      isDark: isDark,
                    ),
                  ),
                ),
              ),

              // Next Chevron
              Positioned(
                right: 6,
                top: 0,
                bottom: 0,
                child: Center(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 180),
                    opacity: (widget.isHovered || isCompact) ? 1.0 : 0.0,
                    child: _GalleryNavButton(
                      icon: Icons.chevron_right_rounded,
                      onTap: () => _nextImage(images.length),
                      isDark: isDark,
                    ),
                  ),
                ),
              ),

              // Pagination Dots
              Positioned(
                bottom: 6,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(images.length, (index) {
                        final isActive = index == _currentImageIndex;
                        return GestureDetector(
                          onTap: () => setState(() => _currentImageIndex = index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            width: isActive ? 12 : 4.5,
                            height: 4.5,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? project.accentColor
                                  : Colors.white.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImageDisplay(List<String> images, bool isDark) {
    final imagePath = images[_currentImageIndex % images.length];

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 240),
      child: Stack(
        key: ValueKey<String>(imagePath),
        fit: StackFit.expand,
        children: [
          // 1. Atmospheric Ambient Background Layer:
          // Subtle blurred expansion of the screenshot so there are no stark, harsh borders,
          // harmonizing the container background with the image's palette.
          Positioned.fill(
            child: ClipRect(
              child: ImageFiltered(
                imageFilter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Transform.scale(
                  scale: 1.20,
                  child: Opacity(
                    opacity: isDark ? 0.35 : 0.22,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      filterQuality: FilterQuality.low,
                      errorBuilder: (_, _, _) => const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 2. Soft theme scrim to maintain optimal contrast in both light and dark themes
          Positioned.fill(
            child: Container(
              color: (isDark ? const Color(0xFF1E1720) : const Color(0xFFF3ECEF))
                  .withValues(alpha: isDark ? 0.65 : 0.75),
            ),
          ),

          // 3. Foreground Complete Uncropped Image:
          // BoxFit.contain ensures 100% of the image (all titles, buttons, screenshots, and logos)
          // is fully visible, preserved in its genuine aspect ratio, with breathing room.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain, // 100% complete, uncropped visibility!
                  filterQuality: FilterQuality.medium,
                  errorBuilder: (_, _, _) =>
                      _buildBrandFallback(widget.project, isDark),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandFallback(ProjectData project, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            project.accentColor.withValues(alpha: isDark ? 0.16 : 0.08),
            isDark ? const Color(0xFF1E1720) : const Color(0xFFF3ECEF),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: project.accentColor.withValues(alpha: isDark ? 0.20 : 0.12),
              shape: BoxShape.circle,
              border: Border.all(
                color: project.accentColor.withValues(alpha: 0.35),
                width: 1.2,
              ),
            ),
            child: Icon(
              project.headerIcon,
              size: 22,
              color: project.accentColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            project.title.split('—').first.trim(),
            style: GoogleFonts.outfit(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
              color: isDark ? AppColors.ivory : AppColors.deepPlum,
            ),
          ),
        ],
      ),
    );
  }
}

class _GalleryNavButton extends StatelessWidget {
  const _GalleryNavButton({
    required this.icon,
    required this.onTap,
    required this.isDark,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.75),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 15,
          color: isDark ? AppColors.ivory : AppColors.deepPlum,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable Minimal Project Action Button
// ─────────────────────────────────────────────────────────────────────────────

class _ProjectActionButton extends StatefulWidget {
  const _ProjectActionButton.github({
    required this.url,
    required this.label,
    required this.tooltip,
    required this.isDark,
    required this.accentColor,
    required this.isArabic,
  });

  final String url;
  final String label;
  final String tooltip;
  final bool isDark;
  final Color accentColor;
  final bool isArabic;

  @override
  State<_ProjectActionButton> createState() => _ProjectActionButtonState();
}

class _ProjectActionButtonState extends State<_ProjectActionButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bg = _hovered
        ? (widget.isDark ? AppColors.ivory : AppColors.deepPlum)
        : (widget.isDark
            ? AppColors.darkSurface.withValues(alpha: 0.90)
            : Colors.white.withValues(alpha: 0.90));

    final fg = _hovered
        ? (widget.isDark ? AppColors.deepPlum : AppColors.ivory)
        : (widget.isDark ? AppColors.ivory : AppColors.deepPlum);

    final border = _hovered
        ? widget.accentColor
        : (widget.isDark
            ? AppColors.darkBorder.withValues(alpha: 0.75)
            : AppColors.lightBorder.withValues(alpha: 0.85));

    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: InkWell(
          onTap: () => WebUrlLauncher.openUrl(widget.url),
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: border, width: 0.9),
              boxShadow: [
                BoxShadow(
                  color: _hovered
                      ? widget.accentColor.withValues(alpha: 0.20)
                      : Colors.black.withValues(
                          alpha: widget.isDark ? 0.15 : 0.03),
                  blurRadius: _hovered ? 7 : 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: widget.isArabic
                  ? [
                      AnimatedSlide(
                        duration: const Duration(milliseconds: 180),
                        offset: Offset(_hovered ? -0.15 : 0.0, 0.0),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          size: 12,
                          color: fg,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        widget.label,
                        style: GoogleFonts.outfit(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: fg,
                        ),
                      ),
                      const SizedBox(width: 6),
                      BrandIcon.github(size: 14, color: fg),
                    ]
                  : [
                      BrandIcon.github(size: 14, color: fg),
                      const SizedBox(width: 6),
                      Text(
                        widget.label,
                        style: GoogleFonts.outfit(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: fg,
                        ),
                      ),
                      const SizedBox(width: 5),
                      AnimatedSlide(
                        duration: const Duration(milliseconds: 180),
                        offset: Offset(_hovered ? 0.15 : 0.0, 0.0),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          size: 12,
                          color: fg,
                        ),
                      ),
                    ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sanad Action Row (Visit Website + Configurable Google Play & App Store)
// ─────────────────────────────────────────────────────────────────────────────

class _SanadActionRow extends StatelessWidget {
  const _SanadActionRow({
    required this.isDark,
    required this.accentColor,
    required this.isArabic,
    required this.l10n,
  });

  final bool isDark;
  final Color accentColor;
  final bool isArabic;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isArabic
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Primary Action: Visit Website
        _SanadWebsiteButton(
          url: SanadConfig.officialWebsiteUrl,
          label: l10n.projectVisitWebsiteBtn,
          tooltip: l10n.projectVisitWebsiteTooltip,
          isDark: isDark,
          accentColor: accentColor,
          isArabic: isArabic,
        ),

        const SizedBox(height: 7),

        // 2. Configurable Store Buttons (Google Play & Apple App Store)
        Wrap(
          spacing: 6,
          runSpacing: 6,
          alignment: isArabic ? WrapAlignment.end : WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _StoreButton(
              label: l10n.projectPlayStoreBtn,
              icon: BrandIcon.googlePlay(
                size: 11.5,
                color: isDark ? AppColors.ivory : AppColors.deepPlum,
              ),
              url: SanadConfig.playStoreUrl,
              isConfigured: SanadConfig.hasPlayStore,
              comingSoonText: l10n.projectComingSoon,
              tooltip: SanadConfig.hasPlayStore
                  ? l10n.projectPlayStoreBtn
                  : l10n.projectStoreInactiveTooltip,
              isDark: isDark,
              accentColor: accentColor,
            ),
            _StoreButton(
              label: l10n.projectAppStoreBtn,
              icon: BrandIcon.appStore(
                size: 11.5,
                color: isDark ? AppColors.ivory : AppColors.deepPlum,
              ),
              url: SanadConfig.appStoreUrl,
              isConfigured: SanadConfig.hasAppStore,
              comingSoonText: l10n.projectComingSoon,
              tooltip: SanadConfig.hasAppStore
                  ? l10n.projectAppStoreBtn
                  : l10n.projectStoreInactiveTooltip,
              isDark: isDark,
              accentColor: accentColor,
            ),
          ],
        ),
      ],
    );
  }
}

class _SanadWebsiteButton extends StatefulWidget {
  const _SanadWebsiteButton({
    required this.url,
    required this.label,
    required this.tooltip,
    required this.isDark,
    required this.accentColor,
    required this.isArabic,
  });

  final String url;
  final String label;
  final String tooltip;
  final bool isDark;
  final Color accentColor;
  final bool isArabic;

  @override
  State<_SanadWebsiteButton> createState() => _SanadWebsiteButtonState();
}

class _SanadWebsiteButtonState extends State<_SanadWebsiteButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bg = _hovered
        ? widget.accentColor
        : (widget.isDark ? AppColors.ivory : AppColors.deepPlum);

    final fg = _hovered
        ? Colors.white
        : (widget.isDark ? AppColors.deepPlum : AppColors.ivory);

    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: InkWell(
          onTap: () => WebUrlLauncher.openUrl(widget.url),
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6.5),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: widget.accentColor.withValues(
                      alpha: _hovered ? 0.32 : 0.12),
                  blurRadius: _hovered ? 7 : 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.language_rounded, size: 13, color: fg),
                const SizedBox(width: 5),
                Text(
                  widget.label,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: fg,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.open_in_new_rounded, size: 10.5, color: fg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StoreButton extends StatefulWidget {
  const _StoreButton({
    required this.label,
    required this.icon,
    required this.url,
    required this.isConfigured,
    required this.comingSoonText,
    required this.tooltip,
    required this.isDark,
    required this.accentColor,
  });

  final String label;
  final Widget icon;
  final String? url;
  final bool isConfigured;
  final String comingSoonText;
  final String tooltip;
  final bool isDark;
  final Color accentColor;

  @override
  State<_StoreButton> createState() => _StoreButtonState();
}

class _StoreButtonState extends State<_StoreButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isConfigured = widget.isConfigured;
    final isDark = widget.isDark;

    final bg = isConfigured
        ? (_hovered
            ? (isDark ? AppColors.ivory : AppColors.deepPlum)
            : (isDark
                ? AppColors.darkSurface.withValues(alpha: 0.90)
                : Colors.white.withValues(alpha: 0.90)))
        : (isDark
            ? AppColors.darkSurface.withValues(alpha: 0.40)
            : Colors.black.withValues(alpha: 0.04));

    final fg = isConfigured
        ? (_hovered
            ? (isDark ? AppColors.deepPlum : AppColors.ivory)
            : (isDark ? AppColors.ivory : AppColors.deepPlum))
        : (isDark
            ? AppColors.ivory.withValues(alpha: 0.45)
            : AppColors.deepPlum.withValues(alpha: 0.45));

    final border = isConfigured
        ? (_hovered
            ? widget.accentColor
            : (isDark
                ? AppColors.darkBorder.withValues(alpha: 0.70)
                : AppColors.lightBorder.withValues(alpha: 0.80)))
        : (isDark
            ? AppColors.darkBorder.withValues(alpha: 0.35)
            : AppColors.lightBorder.withValues(alpha: 0.40));

    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: isConfigured ? (_) => setState(() => _hovered = true) : null,
        onExit: isConfigured ? (_) => setState(() => _hovered = false) : null,
        cursor: isConfigured
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: InkWell(
          onTap: isConfigured && widget.url != null
              ? () => WebUrlLauncher.openUrl(widget.url!)
              : null,
          borderRadius: BorderRadius.circular(7),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5.5),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: border, width: 0.75),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.icon,
                const SizedBox(width: 5),
                Text(
                  widget.label,
                  style: GoogleFonts.outfit(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: fg,
                  ),
                ),
                if (!isConfigured) ...[
                  const SizedBox(width: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.5, vertical: 1),
                    decoration: BoxDecoration(
                      color: widget.accentColor
                          .withValues(alpha: isDark ? 0.18 : 0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.comingSoonText,
                      style: GoogleFonts.outfit(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w700,
                        color: widget.accentColor,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Custom Painter for Continuous Animated Zigzag Connecting Line
// ─────────────────────────────────────────────────────────────────────────────

class _ZigzagPathPainter extends CustomPainter {
  _ZigzagPathPainter({
    required this.nodePoints,
    required this.drawProgress,
    required this.pulseProgress,
    required this.isDark,
  });

  final List<Offset> nodePoints;
  final double drawProgress;
  final double pulseProgress;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    if (nodePoints.length < 2) return;

    // 1. Build the continuous zigzag path through the measured milestone nodes
    final path = Path();
    path.moveTo(nodePoints[0].dx, nodePoints[0].dy);

    for (int i = 1; i < nodePoints.length; i++) {
      final p0 = nodePoints[i - 1];
      final p1 = nodePoints[i];

      // Smooth cubic bezier or direct diagonal line with rounded join
      final midY = (p0.dy + p1.dy) / 2;
      path.cubicTo(
        p0.dx,
        midY,
        p1.dx,
        midY,
        p1.dx,
        p1.dy,
      );
    }

    // 2. Ambient faint background guide line
    final ambientPaint = Paint()
      ..color = (isDark ? AppColors.dustyRose : AppColors.mauve)
          .withValues(alpha: isDark ? 0.15 : 0.10)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, ambientPaint);

    // 3. Progressive animated path reveal
    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return;

    final totalLength = metrics.fold<double>(0.0, (acc, m) => acc + m.length);
    final currentDrawLength = totalLength * drawProgress.clamp(0.0, 1.0);

    final revealedPath = Path();
    double accumulated = 0.0;

    for (final metric in metrics) {
      if (accumulated + metric.length <= currentDrawLength) {
        revealedPath.addPath(metric.extractPath(0, metric.length), Offset.zero);
        accumulated += metric.length;
      } else if (accumulated < currentDrawLength) {
        final remaining = currentDrawLength - accumulated;
        revealedPath.addPath(metric.extractPath(0, remaining), Offset.zero);
        break;
      }
    }

    final gradientPaint = Paint()
      ..shader = ui.Gradient.linear(
        nodePoints.first,
        nodePoints.last,
        [
          isDark ? AppColors.dustyRose : AppColors.mauve,
          const Color(0xFFD97706),
          const Color(0xFF15803D),
          const Color(0xFF2563EB),
        ],
        const [0.0, 0.33, 0.66, 1.0],
      )
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(revealedPath, gradientPaint);

    // 4. Subtle traveling pulse light along the active path
    if (drawProgress > 0.05 && totalLength > 0) {
      final pulseDistance = (totalLength * pulseProgress) % totalLength;
      double metricAccum = 0.0;

      for (final metric in metrics) {
        if (metricAccum + metric.length >= pulseDistance) {
          final tangent =
              metric.getTangentForOffset(pulseDistance - metricAccum);
          if (tangent != null) {
            final pulseCenter = tangent.position;

            // Outer Glow
            final glowPaint = Paint()
              ..color = (isDark ? AppColors.dustyRose : AppColors.mauve)
                  .withValues(alpha: isDark ? 0.40 : 0.25)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
            canvas.drawCircle(pulseCenter, 7.0, glowPaint);

            // Core Light Dot
            final corePaint = Paint()
              ..color = isDark ? Colors.white : AppColors.mauve;
            canvas.drawCircle(pulseCenter, 3.2, corePaint);
          }
          break;
        }
        metricAccum += metric.length;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ZigzagPathPainter oldDelegate) {
    return oldDelegate.drawProgress != drawProgress ||
        oldDelegate.pulseProgress != pulseProgress ||
        oldDelegate.nodePoints != nodePoints ||
        oldDelegate.isDark != isDark;
  }
}
