import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/theme_cubit.dart';
import '../../../../app/localization/locale_cubit.dart';
import '../../../../app/localization/locale_state.dart';
import '../../../../app/responsive/responsive_utils.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../widgets/fine_grid_background.dart';
import '../widgets/hero_section.dart';
import '../widgets/about_section.dart';
import '../widgets/skills_section.dart';
import '../widgets/experience_section.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Section scroll keys
// ─────────────────────────────────────────────────────────────────────────────
final GlobalKey heroSectionKey = GlobalKey();
final GlobalKey aboutSectionKey = GlobalKey();
final GlobalKey skillsSectionKey = GlobalKey();
final GlobalKey workSectionKey = GlobalKey();
final GlobalKey experienceSectionKey = GlobalKey();
final GlobalKey educationSectionKey = GlobalKey();
final GlobalKey contactSectionKey = GlobalKey();

/// Home screen — Phase 03: Full-Width Layout + About Me & Skills Sections.
///
/// Features:
///   • Full-viewport continuous FineGridBackground extending edge-to-edge.
///   • Seamless full-width editorial flow: Hero → About Me → Technical Skills.
///   • Dynamic floating capsule navbar tracking the active section.
///   • Consistent, expansive horizontal gutters (1400px max-width).
///   • Responsive mobile drawer with RTL/LTR support.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final _scrollCtrl = ScrollController();
  double _scrollOffset = 0;
  int _activeSectionIndex = 0; // 0 = Home, 1 = About, 2 = Skills
  bool _mobileMenuOpen = false;

  late final AnimationController _navCtrl;
  late final Animation<double> _navFade;
  late final Animation<Offset> _navSlide;

  @override
  void initState() {
    super.initState();

    _scrollCtrl.addListener(_onScroll);

    _navCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _navFade = CurvedAnimation(parent: _navCtrl, curve: Curves.easeOut);
    _navSlide = Tween<Offset>(
      begin: const Offset(0, -18),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _navCtrl, curve: Curves.easeOutCubic));

    _navCtrl.forward();
  }

  void _onScroll() {
    if (!mounted) return;
    _scrollOffset = _scrollCtrl.offset;

    int newIndex = 0;
    try {
      // Check from last section backward for efficiency
      final expBox =
          experienceSectionKey.currentContext?.findRenderObject() as RenderBox?;
      if (expBox != null && expBox.localToGlobal(Offset.zero).dy <= 260) {
        newIndex = 3; // Experience
      }

      if (newIndex == 0) {
        final skillsBox =
            skillsSectionKey.currentContext?.findRenderObject() as RenderBox?;
        if (skillsBox != null && skillsBox.localToGlobal(Offset.zero).dy <= 260) {
          newIndex = 2; // Skills
        }
      }

      if (newIndex == 0) {
        final aboutBox =
            aboutSectionKey.currentContext?.findRenderObject() as RenderBox?;
        if (aboutBox != null && aboutBox.localToGlobal(Offset.zero).dy <= 260) {
          newIndex = 1; // About
        }
      }
    } catch (_) {}

    if (newIndex != _activeSectionIndex) {
      setState(() => _activeSectionIndex = newIndex);
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_onScroll);
    _scrollCtrl.dispose();
    _navCtrl.dispose();
    super.dispose();
  }

  void _scrollToKey(GlobalKey key) {
    setState(() => _mobileMenuOpen = false);
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
      alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
    );
  }

  void _scrollToTop() {
    setState(() => _mobileMenuOpen = false);
    _scrollCtrl.animateTo(
      0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = context.isWide;
    final isCompact = context.isCompact;
    final scrolled = _scrollOffset > 15;

    // Responsive horizontal gutter padding
    final double hPad = isCompact ? 24.0 : (isDesktop ? 64.0 : 40.0);

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Stack(
        children: [
          // ── 1. Full-Viewport Continuous Fine Grid Canvas ──────────────
          Positioned.fill(
            child: FineGridBackground(
              isDark: isDark,
            ),
          ),

          // ── 2. Scrollable Page Content ─────────────────────────────────
          SingleChildScrollView(
            controller: _scrollCtrl,
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header clearance
                const SizedBox(height: 84),

                // Hero Section
                _SectionContainer(
                  key: heroSectionKey,
                  hPad: hPad,
                  vPad: isCompact ? 16.0 : 32.0,
                  child: const HeroSection(),
                ),

                // Chapter 01: About Me Section
                _SectionContainer(
                  key: aboutSectionKey,
                  hPad: hPad,
                  vPad: isCompact ? 36.0 : 54.0,
                  child: const AboutSection(),
                ),

                // Chapter 02: Skills Section
                _SectionContainer(
                  key: skillsSectionKey,
                  hPad: hPad,
                  vPad: isCompact ? 36.0 : 54.0,
                  child: const SkillsSection(),
                ),

                // Chapter 03: Experience & Journey Section
                _SectionContainer(
                  key: experienceSectionKey,
                  hPad: hPad,
                  vPad: isCompact ? 36.0 : 54.0,
                  child: const ExperienceSection(),
                ),

                // Footer clearance
                const SizedBox(height: 80),
              ],
            ),
          ),

          // ── 3. Floating Navigation Header ──────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _navFade,
              builder: (context, child) => Opacity(
                opacity: _navFade.value,
                child: Transform.translate(
                  offset: _navSlide.value,
                  child: child,
                ),
              ),
              child: _AppNavBar(
                isDark: isDark,
                scrolled: scrolled,
                isDesktop: isDesktop,
                activeSectionIndex: _activeSectionIndex,
                mobileMenuOpen: _mobileMenuOpen,
                onMenuToggle: () =>
                    setState(() => _mobileMenuOpen = !_mobileMenuOpen),
                onHome: _scrollToTop,
                onAbout: () => _scrollToKey(aboutSectionKey),
                onSkills: () => _scrollToKey(skillsSectionKey),
                onWork: () => _scrollToKey(workSectionKey),
                onExperience: () => _scrollToKey(experienceSectionKey),
                onEducation: () => _scrollToKey(educationSectionKey),
                onContact: () => _scrollToKey(contactSectionKey),
              ),
            ),
          ),

          // ── 4. Mobile Slide-in Menu Drawer ─────────────────────────────
          if (!isDesktop)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              top: _mobileMenuOpen ? 80 : -420,
              left: 0,
              right: 0,
              child: _MobileMenuPanel(
                isDark: isDark,
                activeSectionIndex: _activeSectionIndex,
                onHome: _scrollToTop,
                onAbout: () => _scrollToKey(aboutSectionKey),
                onSkills: () => _scrollToKey(skillsSectionKey),
                onWork: () => _scrollToKey(workSectionKey),
                onExperience: () => _scrollToKey(experienceSectionKey),
                onEducation: () => _scrollToKey(educationSectionKey),
                onContact: () => _scrollToKey(contactSectionKey),
              ),
            ),

          // Scrim behind mobile menu
          if (!isDesktop && _mobileMenuOpen)
            Positioned.fill(
              top: 80,
              child: GestureDetector(
                onTap: () => setState(() => _mobileMenuOpen = false),
                child: AnimatedOpacity(
                  opacity: _mobileMenuOpen ? 1 : 0,
                  duration: const Duration(milliseconds: 280),
                  child: ColoredBox(
                    color: Colors.black.withValues(alpha: 0.35),
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
// Full-width Responsive Section Container
// ─────────────────────────────────────────────────────────────────────────────

class _SectionContainer extends StatelessWidget {
  const _SectionContainer({
    super.key,
    required this.hPad,
    required this.vPad,
    required this.child,
  });

  final double hPad;
  final double vPad;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: child,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// App navigation bar
// ─────────────────────────────────────────────────────────────────────────────

class _AppNavBar extends StatelessWidget {
  const _AppNavBar({
    required this.isDark,
    required this.scrolled,
    required this.isDesktop,
    required this.activeSectionIndex,
    required this.mobileMenuOpen,
    required this.onMenuToggle,
    required this.onHome,
    required this.onAbout,
    required this.onSkills,
    required this.onWork,
    required this.onExperience,
    required this.onEducation,
    required this.onContact,
  });

  final bool isDark;
  final bool scrolled;
  final bool isDesktop;
  final int activeSectionIndex;
  final bool mobileMenuOpen;
  final VoidCallback onMenuToggle;
  final VoidCallback onHome;
  final VoidCallback onAbout;
  final VoidCallback onSkills;
  final VoidCallback onWork;
  final VoidCallback onExperience;
  final VoidCallback onEducation;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isCompact = context.isCompact;
    final hPad = isCompact ? 20.0 : (isDesktop ? 64.0 : 36.0);

    final navBg = scrolled
        ? (isDark
            ? AppColors.darkBackground.withValues(alpha: 0.88)
            : AppColors.lightBackground.withValues(alpha: 0.90))
        : Colors.transparent;

    final navBorder = scrolled
        ? (isDark
            ? AppColors.darkBorder.withValues(alpha: 0.55)
            : AppColors.lightBorder.withValues(alpha: 0.65))
        : Colors.transparent;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 76,
      decoration: BoxDecoration(
        color: navBg,
        border: Border(
          bottom: BorderSide(color: navBorder, width: 1.0),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: scrolled
              ? ImageFilter.blur(sigmaX: 18, sigmaY: 18)
              : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── 1. Left: RF Logo + Brand Name ──────────────────────────────
                _Brand(isDark: isDark, l10n: l10n, onTap: onHome),

                // ── 2. Center: Centered Elongated Floating Pill Capsule ─────────
                if (isDesktop)
                  Expanded(
                    child: Center(
                      child: _DesktopCapsuleNav(
                        l10n: l10n,
                        isDark: isDark,
                        activeIndex: activeSectionIndex,
                        onHome: onHome,
                        onAbout: onAbout,
                        onSkills: onSkills,
                        onWork: onWork,
                        onExperience: onExperience,
                        onContact: onContact,
                      ),
                    ),
                  )
                else
                  const Spacer(),

                // ── 3. Right: Compact Rounded Control Capsule ───────────────────
                _NavControlsCapsule(isDark: isDark, l10n: l10n),

                // ── Mobile Hamburger ───────────────────────────────────────────
                if (!isDesktop) ...[
                  const SizedBox(width: 8),
                  _HamburgerButton(
                    isDark: isDark,
                    isOpen: mobileMenuOpen,
                    tooltip: mobileMenuOpen
                        ? l10n.navMenuClose
                        : l10n.navMenuOpen,
                    onTap: onMenuToggle,
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
// Brand — RF Logo + Name with smooth hover effect
// ─────────────────────────────────────────────────────────────────────────────

class _Brand extends StatefulWidget {
  const _Brand({
    required this.isDark,
    required this.l10n,
    required this.onTap,
  });
  final bool isDark;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  @override
  State<_Brand> createState() => _BrandState();
}

class _BrandState extends State<_Brand> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: _hovered
                    ? [
                        BoxShadow(
                          color: AppColors.mauve.withValues(alpha: 0.35),
                          blurRadius: 14,
                        ),
                      ]
                    : [],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: widget.isDark
                        ? const Color(0xFF2E2030)
                        : const Color(0xFFF0E8ED),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: widget.isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder.withValues(alpha: 0.7),
                      width: 1.0,
                    ),
                  ),
                  padding: const EdgeInsets.all(5),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => Center(
                      child: Text(
                        'RF',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: widget.isDark
                              ? AppColors.dustyRose
                              : AppColors.mauve,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
                color: _hovered
                    ? AppColors.mauve
                    : (widget.isDark ? AppColors.ivory : AppColors.deepPlum),
              ),
              child: Text(widget.l10n.displayName),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Desktop Center Floating Capsule Navigation (with dynamic active indicator)
// ─────────────────────────────────────────────────────────────────────────────

class _DesktopCapsuleNav extends StatelessWidget {
  const _DesktopCapsuleNav({
    required this.l10n,
    required this.isDark,
    required this.activeIndex,
    required this.onHome,
    required this.onAbout,
    required this.onSkills,
    required this.onWork,
    required this.onExperience,
    required this.onContact,
  });

  final AppLocalizations l10n;
  final bool isDark;
  final int activeIndex;
  final VoidCallback onHome;
  final VoidCallback onAbout;
  final VoidCallback onSkills;
  final VoidCallback onWork;
  final VoidCallback onExperience;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final navItems = [
      (l10n.navHome, onHome, activeIndex == 0, Icons.home_rounded),
      (l10n.navAbout, onAbout, activeIndex == 1, Icons.person_outline_rounded),
      (l10n.navSkills, onSkills, activeIndex == 2, Icons.code_rounded),
      (l10n.navExperience, onExperience, activeIndex == 3, null),
      (l10n.navProjects, onWork, false, null),
      (l10n.navContact, onContact, false, null),
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkSurface.withValues(alpha: 0.72)
                : Colors.white.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: isDark
                  ? AppColors.darkBorder.withValues(alpha: 0.8)
                  : AppColors.lightBorder.withValues(alpha: 0.65),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.30 : 0.05),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: navItems.map((item) {
              final (label, onTap, active, icon) = item;
              return _CapsuleNavItem(
                label: label,
                isDark: isDark,
                active: active,
                icon: icon,
                onTap: onTap,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _CapsuleNavItem extends StatefulWidget {
  const _CapsuleNavItem({
    required this.label,
    required this.isDark,
    required this.active,
    this.icon,
    required this.onTap,
  });

  final String label;
  final bool isDark;
  final bool active;
  final IconData? icon;
  final VoidCallback onTap;

  @override
  State<_CapsuleNavItem> createState() => _CapsuleNavItemState();
}

class _CapsuleNavItemState extends State<_CapsuleNavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final active = widget.active;

    final activeBg = isDark ? AppColors.ivory : AppColors.deepPlum;
    final activeFg = isDark ? AppColors.deepPlum : AppColors.ivory;

    final inactiveHoverBg = isDark
        ? AppColors.mauve.withValues(alpha: 0.22)
        : AppColors.softBlush.withValues(alpha: 0.50);

    final inactiveFg = _hovered
        ? (isDark ? AppColors.ivory : AppColors.deepPlum)
        : (isDark
            ? AppColors.ivory.withValues(alpha: 0.68)
            : AppColors.deepPlum.withValues(alpha: 0.65));

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(
            horizontal: active ? 16 : 14,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: active
                ? activeBg
                : (_hovered ? inactiveHoverBg : Colors.transparent),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (active && widget.icon != null) ...[
                Icon(
                  widget.icon,
                  size: 15,
                  color: activeFg,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 13.5,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                  color: active ? activeFg : inactiveFg,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Right-side controls — compact unified capsule container
// ─────────────────────────────────────────────────────────────────────────────

class _NavControlsCapsule extends StatelessWidget {
  const _NavControlsCapsule({required this.isDark, required this.l10n});
  final bool isDark;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkSurface.withValues(alpha: 0.72)
                : Colors.white.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isDark
                  ? AppColors.darkBorder.withValues(alpha: 0.8)
                  : AppColors.lightBorder.withValues(alpha: 0.65),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Theme Toggle Icon
              Tooltip(
                message: isDark
                    ? 'Switch to light mode'
                    : 'Switch to dark mode',
                child: IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(6),
                  constraints: const BoxConstraints(),
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, anim) => RotationTransition(
                      turns: Tween(begin: 0.75, end: 1.0).animate(anim),
                      child: FadeTransition(opacity: anim, child: child),
                    ),
                    child: Icon(
                      isDark
                          ? Icons.light_mode_outlined
                          : Icons.dark_mode_outlined,
                      key: ValueKey(isDark),
                      color: isDark ? AppColors.dustyRose : AppColors.mauve,
                      size: 18,
                    ),
                  ),
                  onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                ),
              ),

              // Vertical subtle divider line
              Container(
                width: 1,
                height: 16,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                color: isDark
                    ? AppColors.darkBorder
                    : AppColors.lightBorder.withValues(alpha: 0.8),
              ),

              // Language Toggle Button
              BlocBuilder<LocaleCubit, LocaleState>(
                builder: (context, localeState) {
                  final nextLang = localeState.isArabic
                      ? l10n.languageEnglish
                      : l10n.languageArabic;
                  return Tooltip(
                    message: localeState.isArabic
                        ? 'Switch to English'
                        : 'التبديل إلى العربية',
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => context.read<LocaleCubit>().toggleLocale(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        child: Text(
                          nextLang,
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.dustyRose
                                : AppColors.mauve,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hamburger button (mobile)
// ─────────────────────────────────────────────────────────────────────────────

class _HamburgerButton extends StatelessWidget {
  const _HamburgerButton({
    required this.isDark,
    required this.isOpen,
    required this.tooltip,
    required this.onTap,
  });
  final bool isDark;
  final bool isOpen;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isDark ? AppColors.dustyRose : AppColors.mauve;
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurface.withValues(alpha: 0.72)
            : Colors.white.withValues(alpha: 0.75),
        shape: BoxShape.circle,
        border: Border.all(
          color: isDark
              ? AppColors.darkBorder.withValues(alpha: 0.8)
              : AppColors.lightBorder.withValues(alpha: 0.65),
          width: 1.0,
        ),
      ),
      child: Tooltip(
        message: tooltip,
        child: IconButton(
          visualDensity: VisualDensity.compact,
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, anim) => RotationTransition(
              turns: Tween(begin: 0.875, end: 1.0).animate(anim),
              child: FadeTransition(opacity: anim, child: child),
            ),
            child: Icon(
              isOpen ? Icons.close_rounded : Icons.menu_rounded,
              key: ValueKey(isOpen),
              color: color,
              size: 20,
            ),
          ),
          onPressed: onTap,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mobile slide-in menu panel
// ─────────────────────────────────────────────────────────────────────────────

class _MobileMenuPanel extends StatelessWidget {
  const _MobileMenuPanel({
    required this.isDark,
    required this.activeSectionIndex,
    required this.onHome,
    required this.onAbout,
    required this.onSkills,
    required this.onWork,
    required this.onExperience,
    required this.onEducation,
    required this.onContact,
  });

  final bool isDark;
  final int activeSectionIndex;
  final VoidCallback onHome;
  final VoidCallback onAbout;
  final VoidCallback onSkills;
  final VoidCallback onWork;
  final VoidCallback onExperience;
  final VoidCallback onEducation;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bgColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final items = [
      (l10n.navHome, onHome, activeSectionIndex == 0),
      (l10n.navAbout, onAbout, activeSectionIndex == 1),
      (l10n.navSkills, onSkills, activeSectionIndex == 2),
      (l10n.navExperience, onExperience, activeSectionIndex == 3),
      (l10n.navProjects, onWork, false),
      (l10n.navContact, onContact, false),
    ];

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: bgColor.withValues(alpha: 0.95),
            border: Border(
              bottom: BorderSide(color: borderColor, width: 0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.10),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: items.map((item) {
              final (label, onTap, active) = item;
              return _MobileNavItem(
                label: label,
                isDark: isDark,
                active: active,
                onTap: onTap,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _MobileNavItem extends StatefulWidget {
  const _MobileNavItem({
    required this.label,
    required this.isDark,
    required this.active,
    required this.onTap,
  });
  final String label;
  final bool isDark;
  final bool active;
  final VoidCallback onTap;

  @override
  State<_MobileNavItem> createState() => _MobileNavItemState();
}

class _MobileNavItemState extends State<_MobileNavItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.active
        ? (widget.isDark ? AppColors.mauve.withValues(alpha: 0.25) : AppColors.softBlush.withValues(alpha: 0.5))
        : (_pressed ? AppColors.mauve.withValues(alpha: 0.10) : Colors.transparent);

    final textColor = widget.active
        ? (widget.isDark ? AppColors.ivory : AppColors.deepPlum)
        : (widget.isDark ? AppColors.ivory.withValues(alpha: 0.85) : AppColors.deepPlum.withValues(alpha: 0.85));

    final borderColor =
        widget.isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        color: bgColor,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: borderColor, width: 0.4),
            ),
          ),
          child: Row(
            children: [
              if (widget.active) ...[
                Container(
                  width: 4,
                  height: 16,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: widget.isDark ? AppColors.dustyRose : AppColors.mauve,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 15,
                  fontWeight: widget.active ? FontWeight.w600 : FontWeight.w500,
                  color: textColor,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
