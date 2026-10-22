import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/responsive/responsive_utils.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/url_launcher_web.dart';
import '../../../../core/widgets/brand_icons.dart';
import '../../../../l10n/generated/app_localizations.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Centralized Store Configuration for Sanad Project
// ─────────────────────────────────────────────────────────────────────────────

/// Centralized configuration for Sanad mobile store download links.
///
/// Update these constants with actual store URLs when the application is published:
/// Example:
///   `static const String? playStoreUrl = 'https://play.google.com/store/apps/details?id=...';`
///   `static const String? appStoreUrl = 'https://apps.apple.com/app/...';`
class SanadStoreConfig {
  SanadStoreConfig._();

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

enum ProjectFilterType {
  all,
  ai,
  community,
  platforms,
}

class ProjectData {
  const ProjectData({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.highlights,
    required this.technologies,
    required this.accentColor,
    required this.filterType,
    this.roleContribution,
    this.githubUrl,
    this.isFeatured = false,
    this.isSanad = false,
    this.previewImages = const [],
    this.headerIcon,
  });

  final String id;
  final String title;
  final String category;
  final String? roleContribution;
  final String description;
  final List<String> highlights;
  final List<String> technologies;
  final String? githubUrl;
  final Color accentColor;
  final ProjectFilterType filterType;
  final bool isFeatured;
  final bool isSanad;
  final List<String> previewImages;
  final IconData? headerIcon;
}

// ─────────────────────────────────────────────────────────────────────────────
// Projects Section Main Widget
// ─────────────────────────────────────────────────────────────────────────────

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  ProjectFilterType _activeFilter = ProjectFilterType.all;
  String? _hoveredProjectId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = context.isWide;
    final isCompact = context.isCompact;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final projects = _getProjectDataList(l10n, isDark);
    final filteredProjects = _activeFilter == ProjectFilterType.all
        ? projects
        : projects
            .where((p) => p.filterType == _activeFilter || p.isFeatured)
            .toList();

    final featuredProject =
        filteredProjects.firstWhere((p) => p.isFeatured, orElse: () => projects.first);
    final supportingProjects =
        filteredProjects.where((p) => !p.isFeatured).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── 1. Section Header & Category Filter Tabs ───────────────────
        _buildSectionHeader(l10n, isDark, isDesktop, isCompact, isArabic),

        const SizedBox(height: 36),

        _buildFilterBar(l10n, isDark, isArabic),

        const SizedBox(height: 44),

        // ── 2. Featured Project Showcase (NutriMind) ────────────────────
        _buildFeaturedProjectCard(
          project: featuredProject,
          isDark: isDark,
          isDesktop: isDesktop,
          isCompact: isCompact,
          isArabic: isArabic,
        ),

        const SizedBox(height: 36),

        // ── 3. Supporting Projects Grid (Qoot, Sanad, Rafeeq) ───────────
        if (supportingProjects.isNotEmpty)
          _buildSupportingProjectsGrid(
            projects: supportingProjects,
            isDark: isDark,
            isDesktop: isDesktop,
            isCompact: isCompact,
            isArabic: isArabic,
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
                Icons.folder_special_rounded,
                size: 14,
                color: isDark ? AppColors.dustyRose : AppColors.mauve,
              ),
              const SizedBox(width: 7),
              Text(
                l10n.projectsSectionTag,
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
          l10n.projectsSectionHeading,
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
          constraints: const BoxConstraints(maxWidth: 720),
          child: Text(
            l10n.projectsSectionSubtitle,
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

  // ── Filter Bar ─────────────────────────────────────────────────────────────

  Widget _buildFilterBar(
    AppLocalizations l10n,
    bool isDark,
    bool isArabic,
  ) {
    final filters = [
      (ProjectFilterType.all, l10n.projectsFilterAll, Icons.grid_view_rounded),
      (ProjectFilterType.ai, l10n.projectsFilterAi, Icons.psychology_rounded),
      (ProjectFilterType.community, l10n.projectsFilterCommunity, Icons.volunteer_activism_rounded),
      (ProjectFilterType.platforms, l10n.projectsFilterPlatforms, Icons.rocket_launch_rounded),
    ];

    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkSurface.withValues(alpha: 0.65)
                : Colors.white.withValues(alpha: 0.80),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isDark
                  ? AppColors.darkBorder.withValues(alpha: 0.70)
                  : AppColors.lightBorder.withValues(alpha: 0.75),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: filters.map((f) {
              final (type, label, icon) = f;
              final isSelected = _activeFilter == type;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: InkWell(
                  onTap: () => setState(() => _activeFilter = type),
                  borderRadius: BorderRadius.circular(24),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isDark ? AppColors.ivory : AppColors.deepPlum)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icon,
                          size: 15,
                          color: isSelected
                              ? (isDark ? AppColors.deepPlum : AppColors.ivory)
                              : (isDark ? AppColors.ivory.withValues(alpha: 0.7) : AppColors.deepPlum.withValues(alpha: 0.7)),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          label,
                          style: GoogleFonts.outfit(
                            fontSize: 13.5,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected
                                ? (isDark ? AppColors.deepPlum : AppColors.ivory)
                                : (isDark ? AppColors.ivory.withValues(alpha: 0.75) : AppColors.deepPlum.withValues(alpha: 0.75)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // ── Featured Project Card (NutriMind) ──────────────────────────────────────

  Widget _buildFeaturedProjectCard({
    required ProjectData project,
    required bool isDark,
    required bool isDesktop,
    required bool isCompact,
    required bool isArabic,
  }) {
    final isHovered = _hoveredProjectId == project.id;
    final primaryTextColor = isDark ? AppColors.ivory : AppColors.deepPlum;
    final bodyTextColor = isDark
        ? AppColors.ivory.withValues(alpha: 0.78)
        : AppColors.deepPlum.withValues(alpha: 0.82);

    final cardBg = isDark
        ? AppColors.darkSurface.withValues(alpha: isHovered ? 0.88 : 0.72)
        : Colors.white.withValues(alpha: isHovered ? 0.95 : 0.85);

    final borderColor = isHovered
        ? project.accentColor.withValues(alpha: 0.65)
        : (isDark ? AppColors.darkBorder.withValues(alpha: 0.85) : AppColors.lightBorder.withValues(alpha: 0.85));

    final glowColor = project.accentColor.withValues(alpha: isDark ? 0.16 : 0.08);

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredProjectId = project.id),
      onExit: (_) => setState(() => _hoveredProjectId = null),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, isHovered ? -4.0 : 0.0, 0),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor, width: isHovered ? 1.5 : 1.0),
          boxShadow: [
            BoxShadow(
              color: isHovered ? glowColor : Colors.black.withValues(alpha: isDark ? 0.22 : 0.04),
              blurRadius: isHovered ? 32 : 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: EdgeInsets.all(isCompact ? 22.0 : (isDesktop ? 36.0 : 28.0)),
          child: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column: Editorial Information
                    Expanded(
                      flex: 6,
                      child: _buildFeaturedContent(
                        project: project,
                        isDark: isDark,
                        isCompact: isCompact,
                        isArabic: isArabic,
                        primaryTextColor: primaryTextColor,
                        bodyTextColor: bodyTextColor,
                      ),
                    ),

                    const SizedBox(width: 44),

                    // Right Column: Authentic Mockup Composition
                    Expanded(
                      flex: 5,
                      child: _buildFeaturedVisualShowcase(
                        project: project,
                        isDark: isDark,
                        isArabic: isArabic,
                        isHovered: isHovered,
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Mockup on top for mobile/compact screens
                    _buildFeaturedVisualShowcase(
                      project: project,
                      isDark: isDark,
                      isArabic: isArabic,
                      isHovered: isHovered,
                      height: isCompact ? 280 : 340,
                    ),

                    const SizedBox(height: 28),

                    // Information below
                    _buildFeaturedContent(
                      project: project,
                      isDark: isDark,
                      isCompact: isCompact,
                      isArabic: isArabic,
                      primaryTextColor: primaryTextColor,
                      bodyTextColor: bodyTextColor,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildFeaturedContent({
    required ProjectData project,
    required bool isDark,
    required bool isCompact,
    required bool isArabic,
    required Color primaryTextColor,
    required Color bodyTextColor,
  }) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment:
          isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        // Badges Wrap
        Wrap(
          spacing: 10,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // "FEATURED APPLICATION" Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    project.accentColor.withValues(alpha: 0.95),
                    project.accentColor.withValues(alpha: 0.75),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: project.accentColor.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.auto_awesome_rounded,
                    size: 13,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    l10n.projectFeaturedBadge,
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Category Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: (isDark ? AppColors.ivory : AppColors.deepPlum)
                    .withValues(alpha: isDark ? 0.08 : 0.06),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: (isDark ? AppColors.ivory : AppColors.deepPlum)
                      .withValues(alpha: 0.15),
                  width: 0.8,
                ),
              ),
              child: Text(
                project.category,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.ivory.withValues(alpha: 0.85)
                      : AppColors.deepPlum.withValues(alpha: 0.85),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        // Title
        Text(
          project.title,
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
          style: GoogleFonts.outfit(
            fontSize: isCompact ? 24 : 30,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
            color: primaryTextColor,
            height: 1.25,
          ),
        ),

        const SizedBox(height: 14),

        // Description
        Text(
          project.description,
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
          style: GoogleFonts.outfit(
            fontSize: isCompact ? 14.5 : 15.5,
            fontWeight: FontWeight.w400,
            height: 1.65,
            color: bodyTextColor,
          ),
        ),

        const SizedBox(height: 20),

        // Key Capabilities Bullets
        Column(
          crossAxisAlignment:
              isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: project.highlights.map((h) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 9.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: isArabic
                    ? [
                        Expanded(
                          child: Text(
                            h,
                            textAlign: TextAlign.right,
                            style: GoogleFonts.outfit(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              color: bodyTextColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 9),
                        Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: Icon(
                            Icons.check_circle_rounded,
                            size: 16,
                            color: project.accentColor,
                          ),
                        ),
                      ]
                    : [
                        Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: Icon(
                            Icons.check_circle_rounded,
                            size: 16,
                            color: project.accentColor,
                          ),
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            h,
                            style: GoogleFonts.outfit(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              color: bodyTextColor,
                            ),
                          ),
                        ),
                      ],
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 22),

        // Verified Technology Tags
        Wrap(
          spacing: 7,
          runSpacing: 7,
          alignment: isArabic ? WrapAlignment.end : WrapAlignment.start,
          children: project.technologies.map((t) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
              decoration: BoxDecoration(
                color: project.accentColor.withValues(alpha: isDark ? 0.12 : 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: project.accentColor.withValues(alpha: 0.22),
                  width: 0.8,
                ),
              ),
              child: Text(
                t,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.ivory : AppColors.deepPlum,
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 26),

        // Working GitHub External Action
        if (project.githubUrl != null)
          _ProjectActionButton.github(
            url: project.githubUrl!,
            label: l10n.projectGithubBtn,
            tooltip: l10n.projectSourceCodeTooltip,
            isDark: isDark,
            accentColor: project.accentColor,
            isArabic: isArabic,
          ),
      ],
    );
  }

  Widget _buildFeaturedVisualShowcase({
    required ProjectData project,
    required bool isDark,
    required bool isArabic,
    required bool isHovered,
    double? height,
  }) {
    final preview1 = project.previewImages.isNotEmpty
        ? project.previewImages[0]
        : null;
    final preview2 = project.previewImages.length > 1
        ? project.previewImages[1]
        : null;

    final glowColor = project.accentColor.withValues(alpha: isDark ? 0.25 : 0.14);

    return Container(
      height: height ?? 440,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkBackground.withValues(alpha: 0.7)
            : AppColors.lightBackground.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: project.accentColor.withValues(alpha: 0.25),
          width: 1.0,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background subtle radial gradient glow
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.8,
                  colors: [
                    glowColor,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Composition of Authentic Screenshots
          if (preview1 != null && preview2 != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Phone 1: AI Vision Scanner
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 320),
                      curve: Curves.easeOutCubic,
                      transform: Matrix4.translationValues(
                        0,
                        isHovered ? -8.0 : 0.0,
                        0,
                      ),
                      child: _buildPhoneMockupFrame(
                        imagePath: preview1,
                        isDark: isDark,
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Phone 2: Nutrition Assistant & Tips
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 360),
                      curve: Curves.easeOutCubic,
                      transform: Matrix4.translationValues(
                        0,
                        isHovered ? 8.0 : 0.0,
                        0,
                      ),
                      child: _buildPhoneMockupFrame(
                        imagePath: preview2,
                        isDark: isDark,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else if (preview1 != null)
            _buildPhoneMockupFrame(imagePath: preview1, isDark: isDark)
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildPhoneMockupFrame({
    required String imagePath,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (isDark ? AppColors.ivory : AppColors.deepPlum)
              .withValues(alpha: 0.18),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.30),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => Center(
          child: Icon(
            Icons.mobile_friendly_rounded,
            size: 40,
            color: isDark ? AppColors.dustyRose : AppColors.mauve,
          ),
        ),
      ),
    );
  }

  // ── Supporting Projects Grid (Qoot, Sanad, Rafeeq) ─────────────────────────

  Widget _buildSupportingProjectsGrid({
    required List<ProjectData> projects,
    required bool isDark,
    required bool isDesktop,
    required bool isCompact,
    required bool isArabic,
  }) {
    // 3 cards side-by-side on wide desktop, or stacked on compact/mobile
    if (isDesktop && projects.length == 3) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildSupportingProjectCard(
              project: projects[0],
              isDark: isDark,
              isCompact: isCompact,
              isArabic: isArabic,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: _buildSupportingProjectCard(
              project: projects[1],
              isDark: isDark,
              isCompact: isCompact,
              isArabic: isArabic,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: _buildSupportingProjectCard(
              project: projects[2],
              isDark: isDark,
              isCompact: isCompact,
              isArabic: isArabic,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: projects.map((project) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: _buildSupportingProjectCard(
            project: project,
            isDark: isDark,
            isCompact: isCompact,
            isArabic: isArabic,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSupportingProjectCard({
    required ProjectData project,
    required bool isDark,
    required bool isCompact,
    required bool isArabic,
  }) {
    final l10n = AppLocalizations.of(context);
    final isHovered = _hoveredProjectId == project.id;
    final primaryTextColor = isDark ? AppColors.ivory : AppColors.deepPlum;
    final bodyTextColor = isDark
        ? AppColors.ivory.withValues(alpha: 0.78)
        : AppColors.deepPlum.withValues(alpha: 0.82);

    final cardBg = isDark
        ? AppColors.darkSurface.withValues(alpha: isHovered ? 0.88 : 0.72)
        : Colors.white.withValues(alpha: isHovered ? 0.95 : 0.85);

    final borderColor = isHovered
        ? project.accentColor.withValues(alpha: 0.60)
        : (isDark ? AppColors.darkBorder.withValues(alpha: 0.85) : AppColors.lightBorder.withValues(alpha: 0.85));

    final glowColor = project.accentColor.withValues(alpha: isDark ? 0.14 : 0.06);

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredProjectId = project.id),
      onExit: (_) => setState(() => _hoveredProjectId = null),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, isHovered ? -4.0 : 0.0, 0),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: isHovered ? 1.4 : 1.0),
          boxShadow: [
            BoxShadow(
              color: isHovered ? glowColor : Colors.black.withValues(alpha: isDark ? 0.18 : 0.04),
              blurRadius: isHovered ? 26 : 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
        child: Column(
          crossAxisAlignment:
              isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Row: Category Badge + Header Icon
            Row(
              mainAxisAlignment:
                  isArabic ? MainAxisAlignment.spaceBetween : MainAxisAlignment.spaceBetween,
              children: isArabic
                  ? [
                      if (project.headerIcon != null)
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: project.accentColor.withValues(alpha: isDark ? 0.15 : 0.10),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            project.headerIcon,
                            size: 19,
                            color: project.accentColor,
                          ),
                        ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4.5),
                        decoration: BoxDecoration(
                          color: project.accentColor.withValues(alpha: isDark ? 0.12 : 0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: project.accentColor.withValues(alpha: 0.28),
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          project.category,
                          style: GoogleFonts.outfit(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: project.accentColor,
                          ),
                        ),
                      ),
                    ]
                  : [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4.5),
                        decoration: BoxDecoration(
                          color: project.accentColor.withValues(alpha: isDark ? 0.12 : 0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: project.accentColor.withValues(alpha: 0.28),
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          project.category,
                          style: GoogleFonts.outfit(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: project.accentColor,
                          ),
                        ),
                      ),
                      if (project.headerIcon != null)
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: project.accentColor.withValues(alpha: isDark ? 0.15 : 0.10),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            project.headerIcon,
                            size: 19,
                            color: project.accentColor,
                          ),
                        ),
                    ],
            ),

            const SizedBox(height: 16),

            // Project Title
            Text(
              project.title,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
                color: primaryTextColor,
                height: 1.25,
              ),
            ),

            // Role highlight (e.g. Charity Module Lead)
            if (project.roleContribution != null) ...[
              const SizedBox(height: 7),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: isArabic
                    ? [
                        Text(
                          project.roleContribution!,
                          style: GoogleFonts.outfit(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: project.accentColor,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.verified_user_rounded,
                          size: 14,
                          color: project.accentColor,
                        ),
                      ]
                    : [
                        Icon(
                          Icons.verified_user_rounded,
                          size: 14,
                          color: project.accentColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          project.roleContribution!,
                          style: GoogleFonts.outfit(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: project.accentColor,
                          ),
                        ),
                      ],
              ),
            ],

            const SizedBox(height: 12),

            // Concise Description
            Text(
              project.description,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              style: GoogleFonts.outfit(
                fontSize: 13.5,
                fontWeight: FontWeight.w400,
                height: 1.62,
                color: bodyTextColor,
              ),
            ),

            const SizedBox(height: 16),

            // Key Highlights Bullets
            Column(
              crossAxisAlignment:
                  isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: project.highlights.map((h) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 7.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: isArabic
                        ? [
                            Expanded(
                              child: Text(
                                h,
                                textAlign: TextAlign.right,
                                style: GoogleFonts.outfit(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                  height: 1.48,
                                  color: bodyTextColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Padding(
                              padding: const EdgeInsets.only(top: 2.5),
                              child: Icon(
                                Icons.check_circle_outline_rounded,
                                size: 14,
                                color: project.accentColor,
                              ),
                            ),
                          ]
                        : [
                            Padding(
                              padding: const EdgeInsets.only(top: 2.5),
                              child: Icon(
                                Icons.check_circle_outline_rounded,
                                size: 14,
                                color: project.accentColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                h,
                                style: GoogleFonts.outfit(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                  height: 1.48,
                                  color: bodyTextColor,
                                ),
                              ),
                            ),
                          ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Verified Technologies Chips
            Wrap(
              spacing: 6,
              runSpacing: 6,
              alignment: isArabic ? WrapAlignment.end : WrapAlignment.start,
              children: project.technologies.map((t) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: project.accentColor.withValues(alpha: isDark ? 0.10 : 0.07),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: project.accentColor.withValues(alpha: 0.20),
                      width: 0.7,
                    ),
                  ),
                  child: Text(
                    t,
                    style: GoogleFonts.outfit(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.ivory : AppColors.deepPlum,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 22),

            // Action Buttons:
            // If project is Sanad -> Configurable Store Buttons (Google Play & App Store)
            // If project has GitHub -> Verified GitHub Link
            if (project.isSanad)
              _SanadStoreActionRow(
                isDark: isDark,
                accentColor: project.accentColor,
                isArabic: isArabic,
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
    );
  }

  // ── Project Data Builder ───────────────────────────────────────────────────

  List<ProjectData> _getProjectDataList(AppLocalizations l10n, bool isDark) {
    return [
      // 1. NutriMind (Featured)
      ProjectData(
        id: 'nutrimind',
        title: l10n.projectNutrimindTitle,
        category: l10n.projectNutrimindCategory,
        description: l10n.projectNutrimindDesc,
        highlights: [
          l10n.projectNutrimindFeature1,
          l10n.projectNutrimindFeature2,
          l10n.projectNutrimindFeature3,
          l10n.projectNutrimindFeature4,
        ],
        technologies: const [
          'Flutter & Dart',
          'BLoC / Cubit',
          'Firebase Auth',
          'Cloud Firestore',
          'Groq Vision AI',
          'fl_chart',
          'get_it',
        ],
        githubUrl: 'https://github.com/romisaa5/NutriMind-App',
        accentColor: const Color(0xFF2E7D32), // Emerald / Wellbeing Green
        filterType: ProjectFilterType.ai,
        isFeatured: true,
        previewImages: const [
          'assets/images/projects/nutrimind/nutrimind_3.png',
          'assets/images/projects/nutrimind/nutrimind_dashboard.png',
        ],
      ),

      // 2. Qoot — Food Donation Application
      ProjectData(
        id: 'qoot',
        title: l10n.projectQootTitle,
        category: l10n.projectQootCategory,
        roleContribution: l10n.projectQootRole,
        description: l10n.projectQootDesc,
        highlights: [
          l10n.projectQootFeature1,
          l10n.projectQootFeature2,
          l10n.projectQootFeature3,
        ],
        technologies: const [
          'Flutter & Dart',
          'BLoC / Cubit',
          'Clean Architecture',
          'REST APIs',
          'Dependency Injection',
        ],
        githubUrl: 'https://github.com/theahmedhany/qoot',
        accentColor: const Color(0xFFD97706), // Warm Amber / Food Giving
        filterType: ProjectFilterType.community,
        headerIcon: Icons.volunteer_activism_rounded,
      ),

      // 3. Sanad — Legal Services Platform (Store Buttons Only)
      ProjectData(
        id: 'sanad',
        title: l10n.projectSanadTitle,
        category: l10n.projectSanadCategory,
        description: l10n.projectSanadDesc,
        highlights: [
          l10n.projectSanadFeature1,
          l10n.projectSanadFeature2,
          l10n.projectSanadFeature3,
        ],
        technologies: const [
          'Flutter & Dart',
          'AI Legal Chatbot',
          'REST APIs',
          'Lawyer Profiles',
          'Case Consultation',
        ],
        githubUrl: null, // No GitHub link for Sanad per strict requirement!
        isSanad: true,
        accentColor: isDark ? AppColors.dustyRose : AppColors.mauve,
        filterType: ProjectFilterType.ai,
        headerIcon: Icons.gavel_rounded,
      ),

      // 4. Rafeeq — Founder & Investor Platform
      ProjectData(
        id: 'rafeeq',
        title: l10n.projectRafeeqTitle,
        category: l10n.projectRafeeqCategory,
        description: l10n.projectRafeeqDesc,
        highlights: [
          l10n.projectRafeeqFeature1,
          l10n.projectRafeeqFeature2,
          l10n.projectRafeeqFeature3,
        ],
        technologies: const [
          'Flutter & Dart',
          'BLoC Architecture',
          'REST APIs',
          'Startup Pitch Wizard',
          'Investor Discovery',
        ],
        githubUrl: 'https://github.com/Rafeeq-Software-Project/mobile-app',
        accentColor: const Color(0xFF2563EB), // Startup Royal Blue
        filterType: ProjectFilterType.platforms,
        headerIcon: Icons.rocket_launch_rounded,
      ),
    ];
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable Project Action Button (GitHub & External Links)
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
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: border, width: 1.0),
              boxShadow: [
                BoxShadow(
                  color: _hovered
                      ? widget.accentColor.withValues(alpha: 0.22)
                      : Colors.black.withValues(alpha: widget.isDark ? 0.15 : 0.03),
                  blurRadius: _hovered ? 12 : 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: widget.isArabic
                  ? [
                      AnimatedSlide(
                        duration: const Duration(milliseconds: 200),
                        offset: Offset(_hovered ? -0.15 : 0.0, 0.0),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          size: 14,
                          color: fg,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.label,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: fg,
                        ),
                      ),
                      const SizedBox(width: 10),
                      BrandIcon.github(size: 17, color: fg),
                    ]
                  : [
                      BrandIcon.github(size: 17, color: fg),
                      const SizedBox(width: 10),
                      Text(
                        widget.label,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: fg,
                        ),
                      ),
                      const SizedBox(width: 8),
                      AnimatedSlide(
                        duration: const Duration(milliseconds: 200),
                        offset: Offset(_hovered ? 0.15 : 0.0, 0.0),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          size: 14,
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
// Sanad App Store Action Buttons (Google Play & App Store)
// ─────────────────────────────────────────────────────────────────────────────

class _SanadStoreActionRow extends StatelessWidget {
  const _SanadStoreActionRow({
    required this.isDark,
    required this.accentColor,
    required this.isArabic,
  });

  final bool isDark;
  final Color accentColor;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: [
        // Google Play Button
        _StoreButton(
          label: l10n.projectPlayStoreBtn,
          icon: BrandIcon.googlePlay(
            size: 16,
            color: isDark ? AppColors.ivory : AppColors.deepPlum,
          ),
          url: SanadStoreConfig.playStoreUrl,
          isConfigured: SanadStoreConfig.hasPlayStore,
          comingSoonText: l10n.projectComingSoon,
          tooltip: SanadStoreConfig.hasPlayStore
              ? l10n.projectPlayStoreBtn
              : l10n.projectStoreInactiveTooltip,
          isDark: isDark,
          accentColor: accentColor,
        ),

        // Apple App Store Button
        _StoreButton(
          label: l10n.projectAppStoreBtn,
          icon: BrandIcon.appStore(
            size: 16,
            color: isDark ? AppColors.ivory : AppColors.deepPlum,
          ),
          url: SanadStoreConfig.appStoreUrl,
          isConfigured: SanadStoreConfig.hasAppStore,
          comingSoonText: l10n.projectComingSoon,
          tooltip: SanadStoreConfig.hasAppStore
              ? l10n.projectAppStoreBtn
              : l10n.projectStoreInactiveTooltip,
          isDark: isDark,
          accentColor: accentColor,
        ),
      ],
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
            ? AppColors.darkSurface.withValues(alpha: 0.45)
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
          borderRadius: BorderRadius.circular(10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8.5),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: border, width: 0.9),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.icon,
                const SizedBox(width: 8),
                Text(
                  widget.label,
                  style: GoogleFonts.outfit(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: fg,
                  ),
                ),
                if (!isConfigured) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: widget.accentColor.withValues(alpha: isDark ? 0.18 : 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.comingSoonText,
                      style: GoogleFonts.outfit(
                        fontSize: 10,
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
