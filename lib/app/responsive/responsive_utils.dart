import 'package:flutter/material.dart';
import 'responsive_breakpoints.dart';

/// Layout tier based on available width.
enum LayoutTier { compact, medium, wide }

/// Extension on [BuildContext] for ergonomic responsive queries.
extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  LayoutTier get layoutTier {
    final w = screenWidth;
    if (w < AppBreakpoints.compact) return LayoutTier.compact;
    if (w < AppBreakpoints.medium) return LayoutTier.medium;
    return LayoutTier.wide;
  }

  bool get isCompact => layoutTier == LayoutTier.compact;
  bool get isMedium => layoutTier == LayoutTier.medium;
  bool get isWide => layoutTier == LayoutTier.wide;

  /// True on compact or medium (i.e., not a full desktop viewport).
  bool get isMobile => !isWide;

  /// Horizontal page padding that scales with viewport width.
  EdgeInsets get pagePadding {
    return switch (layoutTier) {
      LayoutTier.compact => const EdgeInsets.symmetric(horizontal: 20),
      LayoutTier.medium => const EdgeInsets.symmetric(horizontal: 40),
      LayoutTier.wide => const EdgeInsets.symmetric(horizontal: 80),
    };
  }

  /// Responsive logo diameter for the splash screen.
  double get splashLogoDiameter {
    return switch (layoutTier) {
      LayoutTier.compact => 120,
      LayoutTier.medium => 160,
      LayoutTier.wide => 200,
    };
  }
}

/// A widget that constrains its child to [AppBreakpoints.maxContentWidth]
/// and centers it horizontally.
class MaxWidthBox extends StatelessWidget {
  const MaxWidthBox({
    super.key,
    required this.child,
    this.maxWidth = AppBreakpoints.maxContentWidth,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
