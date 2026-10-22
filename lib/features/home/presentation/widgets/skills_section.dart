import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Technical Expertise & Skills Section — Chapter 02.
///
/// Features:
///   • Editorial Section Header with monospaced tag and full-width accent rule.
///   • Interactive Domain Filter Tabs (All, Core & Mobile, Architecture, Cloud & Data, UI & Tools).
///   • Six deeply detailed engineering domain modules.
///   • Responsive 3-column / 2-column / 1-column layout.
///   • Interactive skill badges with hover micro-animations.
class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  int _selectedFilter = 0; // 0 = All, 1 = Core, 2 = Architecture, 3 = Networking/Cloud, 4 = Data, 5 = UI/Tools

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final primaryTextColor = isDark ? AppColors.ivory : AppColors.deepPlum;

    // Filter categories
    final filterTabs = [
      l10n.skillsFilterAll,
      l10n.skillsFilterCore,
      l10n.skillsFilterArch,
      l10n.skillsFilterCloud,
      isArabic ? 'حفظ البيانات' : 'Data & Storage',
      l10n.skillsFilterTools,
    ];

    // All 6 Domain Modules
    final allModules = [
      _SkillModuleData(
        id: 1,
        categoryIndex: 1, // Core & Mobile
        number: '01',
        title: l10n.skillsModule1Title,
        description: l10n.skillsModule1Desc,
        icon: Icons.terminal_rounded,
        tags: const [
          'Dart',
          'Flutter SDK',
          'C++',
          'OOP',
          'Data Structures',
          'Algorithms',
          'Async / Streams',
          'Problem Solving',
        ],
      ),
      _SkillModuleData(
        id: 2,
        categoryIndex: 2, // Architecture & State
        number: '02',
        title: l10n.skillsModule2Title,
        description: l10n.skillsModule2Desc,
        icon: Icons.account_tree_outlined,
        tags: const [
          'BLoC Pattern',
          'Cubit',
          'Provider',
          'Clean Architecture',
          'MVVM',
          'SOLID Principles',
          'Repository Pattern',
          'Dependency Injection',
        ],
      ),
      _SkillModuleData(
        id: 3,
        categoryIndex: 3, // Networking & Cloud
        number: '03',
        title: l10n.skillsModule3Title,
        description: l10n.skillsModule3Desc,
        icon: Icons.cloud_sync_outlined,
        tags: const [
          'RESTful APIs',
          'Dio Client',
          'Retrofit',
          'JSON Serialization',
          'Interceptors',
          'WebSockets',
          'Postman',
          'Error Handling',
        ],
      ),
      _SkillModuleData(
        id: 4,
        categoryIndex: 4, // Data & Storage
        number: '04',
        title: l10n.skillsModule4Title,
        description: l10n.skillsModule4Desc,
        icon: Icons.storage_rounded,
        tags: const [
          'SQLite / sqflite',
          'Hive NoSQL',
          'SharedPreferences',
          'Secure Storage',
          'Offline Caching',
          'Token Encryption',
          'Data Hydration',
        ],
      ),
      _SkillModuleData(
        id: 5,
        categoryIndex: 3, // Cloud & Backend Integrations
        number: '05',
        title: l10n.skillsModule5Title,
        description: l10n.skillsModule5Desc,
        icon: Icons.hub_outlined,
        tags: const [
          'Firebase Auth',
          'Cloud Firestore',
          'Cloud Messaging (FCM)',
          'Firebase Storage',
          'Push Notifications',
          'Realtime Streams',
        ],
      ),
      _SkillModuleData(
        id: 6,
        categoryIndex: 5, // UI & Tools
        number: '06',
        title: l10n.skillsModule6Title,
        description: l10n.skillsModule6Desc,
        icon: Icons.palette_outlined,
        tags: const [
          'Material Design 3',
          'Custom Painters',
          'Fluid Micro-animations',
          'Responsive & Adaptive',
          'Figma-to-Flutter',
          'Git & GitHub',
          'DevTools Profiling',
        ],
      ),
    ];

    // Filtered list
    final displayedModules = _selectedFilter == 0
        ? allModules
        : allModules.where((m) => m.categoryIndex == _selectedFilter).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── 1. Section Header ──────────────────────────────────────────
        _SkillsSectionHeader(
          number: l10n.skillsSectionNumber,
          tag: l10n.skillsSectionTag,
          headline: l10n.skillsHeadline,
          subtitle: l10n.skillsSubtitle,
          isDark: isDark,
          isArabic: isArabic,
          primaryTextColor: primaryTextColor,
        ),

        const SizedBox(height: 36),

        // ── 2. Interactive Domain Filter Tabs ──────────────────────────
        _FilterTabsBar(
          tabs: filterTabs,
          selectedIndex: _selectedFilter,
          isDark: isDark,
          onTabSelected: (index) => setState(() => _selectedFilter = index),
        ),

        const SizedBox(height: 40),

        // ── 3. Skill Module Cards Grid ─────────────────────────────────
        LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final int crossAxisCount = w >= 1100 ? 3 : (w >= 700 ? 2 : 1);

            return _ResponsiveSkillGrid(
              modules: displayedModules,
              crossAxisCount: crossAxisCount,
              isDark: isDark,
            );
          },
        ),

        const SizedBox(height: 64),

        // ── Section Divider ────────────────────────────────────────────
        _SkillsSectionDivider(isDark: isDark),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Skills Section Header
// ─────────────────────────────────────────────────────────────────────────────

class _SkillsSectionHeader extends StatelessWidget {
  const _SkillsSectionHeader({
    required this.number,
    required this.tag,
    required this.headline,
    required this.subtitle,
    required this.isDark,
    required this.isArabic,
    required this.primaryTextColor,
  });

  final String number;
  final String tag;
  final String headline;
  final String subtitle;
  final bool isDark;
  final bool isArabic;
  final Color primaryTextColor;

  @override
  Widget build(BuildContext context) {
    final accentColor = isDark ? AppColors.dustyRose : AppColors.mauve;
    final subColor = isDark
        ? AppColors.ivory.withValues(alpha: 0.72)
        : AppColors.deepPlum.withValues(alpha: 0.72);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tag badge
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

        const SizedBox(height: 18),

        // Headline with extending rule
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

        const SizedBox(height: 14),

        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Text(
            subtitle,
            style: GoogleFonts.outfit(
              fontSize: 15.5,
              fontWeight: FontWeight.w400,
              color: subColor,
              height: 1.65,
              letterSpacing: 0.15,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Filter Tabs Bar
// ─────────────────────────────────────────────────────────────────────────────

class _FilterTabsBar extends StatelessWidget {
  const _FilterTabsBar({
    required this.tabs,
    required this.selectedIndex,
    required this.isDark,
    required this.onTabSelected,
  });

  final List<String> tabs;
  final int selectedIndex;
  final bool isDark;
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = selectedIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: _FilterPill(
              label: tabs[index],
              isSelected: isSelected,
              isDark: isDark,
              onTap: () => onTabSelected(index),
            ),
          );
        }),
      ),
    );
  }
}

class _FilterPill extends StatefulWidget {
  const _FilterPill({
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  State<_FilterPill> createState() => _FilterPillState();
}

class _FilterPillState extends State<_FilterPill> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final isSelected = widget.isSelected;

    final activeBg = isDark ? AppColors.ivory : AppColors.deepPlum;
    final activeFg = isDark ? AppColors.deepPlum : AppColors.ivory;

    final inactiveHoverBg = isDark
        ? AppColors.mauve.withValues(alpha: 0.22)
        : AppColors.softBlush.withValues(alpha: 0.45);

    final inactiveFg = _hovered
        ? (isDark ? AppColors.ivory : AppColors.deepPlum)
        : (isDark
            ? AppColors.ivory.withValues(alpha: 0.65)
            : AppColors.deepPlum.withValues(alpha: 0.65));

    final borderColor = isSelected
        ? Colors.transparent
        : (_hovered
            ? (isDark ? AppColors.dustyRose : AppColors.mauve)
            : (isDark
                ? AppColors.darkBorder
                : AppColors.lightBorder.withValues(alpha: 0.70)));

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? activeBg
                : (_hovered ? inactiveHoverBg : Colors.transparent),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: borderColor, width: 1.0),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: (isDark ? Colors.black : AppColors.deepPlum)
                          .withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 13.0,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? activeFg : inactiveFg,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Responsive Skill Cards Grid
// ─────────────────────────────────────────────────────────────────────────────

class _ResponsiveSkillGrid extends StatelessWidget {
  const _ResponsiveSkillGrid({
    required this.modules,
    required this.crossAxisCount,
    required this.isDark,
  });

  final List<_SkillModuleData> modules;
  final int crossAxisCount;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    if (crossAxisCount == 1) {
      return Column(
        children: modules
            .map((m) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _SkillModuleCard(data: m, isDark: isDark),
                ))
            .toList(),
      );
    }

    final rows = <Widget>[];
    for (int i = 0; i < modules.length; i += crossAxisCount) {
      final rowModules = modules.skip(i).take(crossAxisCount).toList();
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 22),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(crossAxisCount, (colIndex) {
              if (colIndex < rowModules.length) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: colIndex < crossAxisCount - 1 ? 20 : 0,
                    ),
                    child: _SkillModuleCard(
                      data: rowModules[colIndex],
                      isDark: isDark,
                    ),
                  ),
                );
              } else {
                return const Expanded(child: SizedBox());
              }
            }),
          ),
        ),
      );
    }

    return Column(children: rows);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Skill Module Card
// ─────────────────────────────────────────────────────────────────────────────

class _SkillModuleCard extends StatefulWidget {
  const _SkillModuleCard({required this.data, required this.isDark});
  final _SkillModuleData data;
  final bool isDark;

  @override
  State<_SkillModuleCard> createState() => _SkillModuleCardState();
}

class _SkillModuleCardState extends State<_SkillModuleCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final d = widget.data;

    final bgColor = isDark
        ? AppColors.darkSurface.withValues(alpha: 0.75)
        : Colors.white.withValues(alpha: 0.82);

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
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0.0, _hovered ? -4.0 : 0.0, 0.0),
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: borderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: (isDark ? Colors.black : AppColors.deepPlum).withValues(
                alpha: _hovered ? (isDark ? 0.38 : 0.09) : (isDark ? 0.16 : 0.03),
              ),
              blurRadius: _hovered ? 24 : 12,
              offset: Offset(0, _hovered ? 8 : 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Row: Icon + Module Number
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder.withValues(alpha: 0.6),
                      width: 0.8,
                    ),
                  ),
                  child: Icon(
                    d.icon,
                    size: 22,
                    color: isDark ? AppColors.dustyRose : AppColors.mauve,
                  ),
                ),
                Text(
                  d.number,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                    color: isDark
                        ? AppColors.dustyRose.withValues(alpha: 0.50)
                        : AppColors.mauve.withValues(alpha: 0.50),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Module Title
            Text(
              d.title,
              style: GoogleFonts.outfit(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.ivory : AppColors.deepPlum,
                letterSpacing: -0.2,
                height: 1.25,
              ),
            ),

            const SizedBox(height: 10),

            // Module Description
            Text(
              d.description,
              style: GoogleFonts.outfit(
                fontSize: 13.5,
                fontWeight: FontWeight.w400,
                color: isDark
                    ? AppColors.ivory.withValues(alpha: 0.70)
                    : AppColors.deepPlum.withValues(alpha: 0.70),
                height: 1.60,
              ),
            ),

            const SizedBox(height: 22),

            // Interactive Skill Tags
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: d.tags.map((tag) => _SkillTagChip(tag: tag, isDark: isDark)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillTagChip extends StatefulWidget {
  const _SkillTagChip({required this.tag, required this.isDark});
  final String tag;
  final bool isDark;

  @override
  State<_SkillTagChip> createState() => _SkillTagChipState();
}

class _SkillTagChipState extends State<_SkillTagChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;

    final chipBg = isDark
        ? (_hovered
            ? AppColors.mauve.withValues(alpha: 0.35)
            : AppColors.darkSurfaceVariant.withValues(alpha: 0.50))
        : (_hovered
            ? AppColors.mauve.withValues(alpha: 0.12)
            : AppColors.softBlush.withValues(alpha: 0.35));

    final chipBorder = _hovered
        ? (isDark ? AppColors.dustyRose : AppColors.mauve)
        : (isDark
            ? AppColors.darkBorder
            : AppColors.lightBorder.withValues(alpha: 0.60));

    final chipText = isDark
        ? (_hovered ? AppColors.ivory : AppColors.ivory.withValues(alpha: 0.85))
        : (_hovered ? AppColors.deepPlum : AppColors.deepPlum.withValues(alpha: 0.85));

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: chipBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: chipBorder, width: 0.8),
        ),
        child: Text(
          widget.tag,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
            color: chipText,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Architectural Section Divider
// ─────────────────────────────────────────────────────────────────────────────

class _SkillsSectionDivider extends StatelessWidget {
  const _SkillsSectionDivider({required this.isDark});
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

class _SkillModuleData {
  const _SkillModuleData({
    required this.id,
    required this.categoryIndex,
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
    required this.tags,
  });

  final int id;
  final int categoryIndex;
  final String number;
  final String title;
  final String description;
  final IconData icon;
  final List<String> tags;
}
