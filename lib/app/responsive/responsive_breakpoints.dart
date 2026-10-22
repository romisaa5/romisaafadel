/// Responsive breakpoints based on available width.
///
/// These values distinguish compact (mobile), medium (tablet), and
/// wide (desktop) layouts. All layout decisions must reference these
/// constants rather than hardcoded pixel values.
abstract final class AppBreakpoints {
  /// Widths below this are considered compact (mobile portrait).
  static const double compact = 600;

  /// Widths at or above this but below [wide] are medium (tablet).
  static const double medium = 900;

  /// Widths at or above this are wide (desktop).
  static const double wide = 1200;

  /// Maximum content width to prevent excessively wide text columns.
  static const double maxContentWidth = 1100;

  /// Comfortable reading width for body text and cards.
  static const double readingWidth = 720;
}
