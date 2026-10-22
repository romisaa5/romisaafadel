import 'package:flutter/material.dart';

/// Centralized brand color palette for Romisaa Fadel's portfolio.
/// All colors are derived from the official brand palette.
/// Never scatter raw color values throughout the application — use this class.
abstract final class AppColors {
  // ── Brand Palette ────────────────────────────────────────────────────────
  static const Color deepPlum = Color(0xFF291C29);
  static const Color mauve = Color(0xFF704C67);
  static const Color dustyRose = Color(0xFFB995AA);
  static const Color softBlush = Color(0xFFE6D7E0);
  static const Color ivory = Color(0xFFF8F4F6);

  // ── Dark Theme Surfaces ───────────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF1A1119);
  static const Color darkSurface = Color(0xFF231821);
  static const Color darkSurfaceVariant = Color(0xFF2E2030);
  static const Color darkBorder = Color(0xFF3D2B3A);

  // ── Light Theme Surfaces ──────────────────────────────────────────────────
  static const Color lightBackground = ivory;
  static const Color lightSurface = Color(0xFFF0E8ED);
  static const Color lightSurfaceVariant = softBlush;
  static const Color lightBorder = Color(0xFFD4BDC9);

  // ── Semantic ──────────────────────────────────────────────────────────────
  static const Color error = Color(0xFFCF6679);
  static const Color onError = Color(0xFF1A0A0D);

  // ── Glow / Ambient ────────────────────────────────────────────────────────
  static const Color glowDark = Color(0x33704C67);   // mauve @ 20%
  static const Color glowLight = Color(0x22B995AA);  // dustyRose @ 13%
}
