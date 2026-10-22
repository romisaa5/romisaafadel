import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routing/routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/theme_cubit.dart';
import '../../../../app/localization/locale_cubit.dart';
import '../../../../app/localization/locale_state.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../cubit/splash_cubit.dart';
import '../cubit/splash_state.dart';
import '../widgets/ambient_background.dart';
import '../widgets/animated_brand_logo.dart';
import '../widgets/loading_indicator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _master;

  // Stage A — Background
  late Animation<double> _bgOpacity;

  // Stage B — Logo
  late Animation<double> _logoOpacity;
  late Animation<double> _logoScale;
  late Animation<Offset> _logoSlide;
  late Animation<double> _logoGlow;

  // Stage C — Typography
  late Animation<double> _nameOpacity;
  late Animation<Offset> _nameSlide;
  late Animation<double> _titleOpacity;
  late Animation<Offset> _titleSlide;

  // Stage D — Loading indicator
  late Animation<double> _loadingOpacity;

  bool _navigated = false;

  static const Duration _totalDuration = Duration(milliseconds: 3200);

  @override
  void initState() {
    super.initState();

    _master = AnimationController(vsync: this, duration: _totalDuration);

    // ── Stage A: Background (0 → 600ms) ───────────────────────────────────
    _bgOpacity = CurvedAnimation(
      parent: _master,
      curve: const Interval(0.0, 0.19, curve: Curves.easeOut),
    );

    // ── Stage B: Logo (400 → 1400ms) ──────────────────────────────────────
    final logoInterval = CurvedAnimation(
      parent: _master,
      curve: const Interval(0.125, 0.44, curve: Curves.easeOut),
    );
    _logoOpacity = logoInterval;
    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _master,
        curve: const Interval(0.125, 0.44, curve: Curves.elasticOut),
      ),
    );
    _logoSlide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _master,
            curve: const Interval(0.125, 0.44, curve: Curves.easeOut),
          ),
        );
    _logoGlow = CurvedAnimation(
      parent: _master,
      curve: const Interval(0.38, 0.75, curve: Curves.easeInOut),
    );

    // ── Stage C: Name (1200 → 1700ms) ─────────────────────────────────────
    _nameOpacity = CurvedAnimation(
      parent: _master,
      curve: const Interval(0.375, 0.53, curve: Curves.easeOut),
    );
    _nameSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _master,
            curve: const Interval(0.375, 0.53, curve: Curves.easeOut),
          ),
        );

    // Professional title (1600 → 2200ms)
    _titleOpacity = CurvedAnimation(
      parent: _master,
      curve: const Interval(0.5, 0.69, curve: Curves.easeOut),
    );
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _master,
            curve: const Interval(0.5, 0.69, curve: Curves.easeOut),
          ),
        );

    // ── Stage D: Loading indicator (2000 → 2600ms) ────────────────────────
    _loadingOpacity = CurvedAnimation(
      parent: _master,
      curve: const Interval(0.625, 0.81, curve: Curves.easeOut),
    );

    // Start the animation immediately.
    _master.forward();

    // Kick off the SplashCubit sequence.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SplashCubit>().start(
          onInitializationComplete: () async {
            // Load saved preferences while the animation is playing.
            await Future.wait([
              context.read<ThemeCubit>().loadSavedTheme(),
              context.read<LocaleCubit>().loadSavedLocale(),
            ]);
          },
        );
      }
    });
  }

  @override
  void dispose() {
    _master.dispose();
    super.dispose();
  }

  void _navigateHome() {
    if (_navigated || !mounted) return;
    _navigated = true;
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashComplete) {
          _navigateHome();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AnimatedBuilder(
          animation: _master,
          builder: (context, _) {
            return Stack(
              fit: StackFit.expand,
              children: [
                // ── Layer 0: Ambient Background ──────────────────────────
                AmbientBackground(opacity: _bgOpacity),

                // ── Layer 1: Central Content ─────────────────────────────
                _CentralContent(
                  logoOpacity: _logoOpacity,
                  logoScale: _logoScale,
                  logoSlide: _logoSlide,
                  logoGlow: _logoGlow,
                  nameOpacity: _nameOpacity,
                  nameSlide: _nameSlide,
                  titleOpacity: _titleOpacity,
                  titleSlide: _titleSlide,
                  loadingOpacity: _loadingOpacity,
                ),

                // ── Layer 2: Controls ─────────────────────────────────────
                Positioned(
                  top: 24,
                  right: 24,
                  child: FadeTransition(
                    opacity: _loadingOpacity,
                    child: const _QuickControls(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Central content column
// ─────────────────────────────────────────────────────────────────────────────

class _CentralContent extends StatelessWidget {
  const _CentralContent({
    required this.logoOpacity,
    required this.logoScale,
    required this.logoSlide,
    required this.logoGlow,
    required this.nameOpacity,
    required this.nameSlide,
    required this.titleOpacity,
    required this.titleSlide,
    required this.loadingOpacity,
  });

  final Animation<double> logoOpacity;
  final Animation<double> logoScale;
  final Animation<Offset> logoSlide;
  final Animation<double> logoGlow;
  final Animation<double> nameOpacity;
  final Animation<Offset> nameSlide;
  final Animation<double> titleOpacity;
  final Animation<Offset> titleSlide;
  final Animation<double> loadingOpacity;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Stage B — Logo
                    AnimatedBrandLogo(
                      scaleAnimation: logoScale,
                      opacityAnimation: logoOpacity,
                      slideAnimation: logoSlide,
                      glowAnimation: logoGlow,
                    ),

                    const SizedBox(height: 40),

                    // Stage C — Name
                    FadeTransition(
                      opacity: nameOpacity,
                      child: SlideTransition(
                        position: nameSlide,
                        child: Text(
                          l10n.displayName,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: isDark
                                ? AppColors.ivory
                                : AppColors.deepPlum,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Stage C — Professional title
                    FadeTransition(
                      opacity: titleOpacity,
                      child: SlideTransition(
                        position: titleSlide,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 28,
                              height: 1.5,
                              color: AppColors.dustyRose,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              l10n.professionalTitle,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: AppColors.dustyRose,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 3.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 28,
                              height: 1.5,
                              color: AppColors.dustyRose,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 56),

                    // Stage D — Loading indicator + message
                    FadeTransition(
                      opacity: loadingOpacity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const LoadingIndicator(size: 28, strokeWidth: 2.0),
                          const SizedBox(height: 20),
                          Text(
                            l10n.loadingMessage,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? AppColors.dustyRose.withValues(alpha: 0.7)
                                  : AppColors.mauve.withValues(alpha: 0.8),
                              letterSpacing: 2.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Quick Controls (theme + language switcher)
// ─────────────────────────────────────────────────────────────────────────────

class _QuickControls extends StatelessWidget {
  const _QuickControls();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final iconColor = isDark ? AppColors.dustyRose : AppColors.mauve;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurface.withValues(alpha: 0.85)
            : AppColors.lightSurface.withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Theme toggle
          _ControlButton(
            tooltip: isDark ? 'Switch to light theme' : 'Switch to dark theme',
            icon: isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            color: iconColor,
            onTap: () => context.read<ThemeCubit>().toggleTheme(),
          ),

          Container(
            width: 1,
            height: 18,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: borderColor,
          ),

          // Language toggle
          BlocBuilder<LocaleCubit, LocaleState>(
            builder: (context, localeState) {
              return _ControlButton(
                tooltip: localeState.isArabic
                    ? 'Switch to English'
                    : 'التبديل إلى العربية',
                icon: Icons.language_outlined,
                color: iconColor,
                onTap: () => context.read<LocaleCubit>().toggleLocale(),
                label: localeState.isArabic ? 'EN' : 'AR',
                labelColor: iconColor,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatefulWidget {
  const _ControlButton({
    required this.tooltip,
    required this.icon,
    required this.color,
    required this.onTap,
    this.label,
    this.labelColor,
  });

  final String tooltip;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String? label;
  final Color? labelColor;

  @override
  State<_ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<_ControlButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _hovered
                  ? AppColors.mauve.withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, size: 18, color: widget.color),
                if (widget.label != null) ...[
                  const SizedBox(width: 4),
                  Text(
                    widget.label!,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: widget.labelColor ?? widget.color,
                      letterSpacing: 0.5,
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
