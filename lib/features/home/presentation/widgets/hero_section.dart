import 'package:flutter/material.dart';

import '../../../../app/responsive/responsive_utils.dart';
import '../../../../app/theme/app_colors.dart';
import 'hero_content.dart';
import 'hero_visual.dart';
import 'hero_actions.dart';

/// The complete Hero section — redesigned to match the reference site.
///
/// Features:
///   • Full-viewport FineGridBackground with blueprint lines, dots, and ambient highlights.
///   • Left Column: Editorial italic serif headline, JetBrains Mono descriptor, Outfit copy, actions.
///   • Right Column: Architectural vertical framed portrait with dashed blueprint contour and waving hand.
///   • Multi-layer pointer parallax on desktop.
///   • Responsive layout (horizontal on desktop, centered stacked on tablet & mobile).
///   • Bottom architectural divider line with center intersection dot.
class HeroSection extends StatefulWidget {
  const HeroSection({
    super.key,
    this.onViewWorkTap,
    this.onGetInTouchTap,
  });

  final VoidCallback? onViewWorkTap;
  final VoidCallback? onGetInTouchTap;

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  late final Animation<double> _sectionOpacity;
  late final Animation<double> _nameOpacity;
  late final Animation<Offset> _nameSlide;
  late final Animation<double> _titleOpacity;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _introOpacity;
  late final Animation<Offset> _introSlide;
  late final Animation<double> _visualOpacity;
  late final Animation<double> _visualScale;
  late final Animation<double> _actionsOpacity;
  late final Animation<Offset> _actionsSlide;

  Offset _parallaxOffset = Offset.zero;
  static const double _maxParallax = 12.0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    CurvedAnimation iv(double b, double e, [Curve c = Curves.easeOut]) =>
        CurvedAnimation(
          parent: _ctrl,
          curve: Interval(b, e, curve: c),
        );

    _sectionOpacity = iv(0.0, 0.20);

    _nameOpacity = iv(0.06, 0.38);
    _nameSlide = Tween<Offset>(
      begin: const Offset(0, 24),
      end: Offset.zero,
    ).animate(iv(0.06, 0.38, Curves.easeOutCubic));

    _titleOpacity = iv(0.20, 0.50);
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 16),
      end: Offset.zero,
    ).animate(iv(0.20, 0.50, Curves.easeOutCubic));

    _introOpacity = iv(0.28, 0.58);
    _introSlide = Tween<Offset>(
      begin: const Offset(0, 14),
      end: Offset.zero,
    ).animate(iv(0.28, 0.58, Curves.easeOut));

    _visualOpacity = iv(0.20, 0.56);
    _visualScale = Tween<double>(
      begin: 0.88,
      end: 1.0,
    ).animate(iv(0.20, 0.56, Curves.easeOutCubic));

    _actionsOpacity = iv(0.38, 0.68);
    _actionsSlide = Tween<Offset>(
      begin: const Offset(0, 16),
      end: Offset.zero,
    ).animate(iv(0.38, 0.68, Curves.easeOut));

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onPointerMove(PointerEvent event, BoxConstraints constraints) {
    if (!mounted) return;
    final w = constraints.maxWidth;
    if (w <= 0 || !w.isFinite) return;

    final box = context.findRenderObject() as RenderBox?;
    final h = (box != null && box.attached && box.hasSize && box.size.height > 0)
        ? box.size.height
        : (constraints.hasBoundedHeight && constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : 650.0);

    final cx = w / 2;
    final cy = h / 2;

    final rawDx = cx > 0 ? (event.localPosition.dx - cx) / cx : 0.0;
    final rawDy = cy > 0 ? (event.localPosition.dy - cy) / cy : 0.0;

    final dx = rawDx.isFinite ? rawDx.clamp(-1.0, 1.0) : 0.0;
    final dy = rawDy.isFinite ? rawDy.clamp(-1.0, 1.0) : 0.0;

    final nextOffset = Offset(dx * _maxParallax, dy * _maxParallax);
    if ((nextOffset - _parallaxOffset).distanceSquared > 0.04) {
      setState(() {
        _parallaxOffset = nextOffset;
      });
    }
  }

  void _resetParallax() {
    if (mounted && _parallaxOffset != Offset.zero) {
      setState(() => _parallaxOffset = Offset.zero);
    }
  }

  void _handleViewWork() {
    final ctrl = PrimaryScrollController.maybeOf(context);
    if (ctrl != null && ctrl.hasClients) {
      ctrl.animateTo(
        ctrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = context.isWide;
    final enableParallax = isDesktop;

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) => Opacity(
        opacity: _sectionOpacity.value,
        child: LayoutBuilder(
          builder: (context, constraints) => MouseRegion(
            onExit: enableParallax ? (_) => _resetParallax() : null,
            child: Listener(
              onPointerMove: enableParallax
                  ? (e) => _onPointerMove(e, constraints)
                  : null,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: isDesktop ? 48.0 : 24.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isDesktop)
                      _WideLayout(
                        content: _buildContent(),
                        visual: _buildVisual(isWide: true),
                      )
                    else if (context.isMedium)
                      _TabletLayout(
                        content: _buildContent(),
                        visual: _buildVisual(isWide: false),
                      )
                    else
                      _MobileLayout(
                        heroContent: _buildHeroContent(),
                        visual: _buildVisual(isWide: false, isCompact: true),
                        actions: _buildHeroActions(isMobile: true),
                      ),

                    SizedBox(height: isDesktop ? 56 : 36),

                    // Architectural bottom divider line with center dot
                    _SectionBottomDivider(isDark: isDark),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroContent() => HeroContent(
    nameOpacity: _nameOpacity.value,
    nameSlide: _nameSlide.value,
    titleOpacity: _titleOpacity.value,
    titleSlide: _titleSlide.value,
    introOpacity: _introOpacity.value,
    introSlide: _introSlide.value,
  );

  Widget _buildHeroActions({bool isMobile = false}) => HeroActions(
    opacity: _actionsOpacity.value,
    slideOffset: _actionsSlide.value,
    onViewWorkTap: widget.onViewWorkTap ?? _handleViewWork,
    onGetInTouchTap: widget.onGetInTouchTap,
    isMobile: isMobile,
  );

  Widget _buildContent() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      _buildHeroContent(),
      const SizedBox(height: 38),
      _buildHeroActions(isMobile: false),
    ],
  );

  Widget _buildVisual({required bool isWide, bool isCompact = false}) => HeroVisual(
    opacity: _visualOpacity.value,
    scale: _visualScale.value,
    parallaxOffset: _parallaxOffset,
    isWide: isWide,
    isCompact: isCompact,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Architectural Section Bottom Divider (Horizontal line with center dot)
// ─────────────────────────────────────────────────────────────────────────────

class _SectionBottomDivider extends StatelessWidget {
  const _SectionBottomDivider({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final lineColor = isDark
        ? AppColors.dustyRose.withValues(alpha: 0.14)
        : AppColors.mauve.withValues(alpha: 0.16);

    final dotColor = isDark
        ? AppColors.softBlush.withValues(alpha: 0.55)
        : AppColors.deepPlum.withValues(alpha: 0.50);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: Container(height: 0.8, color: lineColor)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(child: Container(height: 0.8, color: lineColor)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Wide (desktop) layout
// ─────────────────────────────────────────────────────────────────────────────

class _WideLayout extends StatelessWidget {
  const _WideLayout({required this.content, required this.visual});
  final Widget content;
  final Widget visual;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 55, child: content),
        const SizedBox(width: 48),
        Expanded(flex: 45, child: Center(child: visual)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tablet layout (portrait centered stacked above content)
// ─────────────────────────────────────────────────────────────────────────────

class _TabletLayout extends StatelessWidget {
  const _TabletLayout({
    required this.content,
    required this.visual,
  });
  final Widget content;
  final Widget visual;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        visual,
        const SizedBox(height: 40),
        content,
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mobile layout (1. Name/Title + Intro, 2. Centered Profile Image, 3. Actions)
// ─────────────────────────────────────────────────────────────────────────────

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    required this.heroContent,
    required this.visual,
    required this.actions,
  });

  final Widget heroContent;
  final Widget visual;
  final Widget actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. Name & professional title + 2. Short introduction
        heroContent,

        const SizedBox(height: 28),

        // 3. Profile photograph centered horizontally
        Center(child: visual),

        const SizedBox(height: 28),

        // 4. Action buttons positioned directly below the profile photograph
        Center(child: actions),
      ],
    );
  }
}
