import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/responsive/responsive_utils.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/cv_downloader_web.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Hero action buttons inspired directly by the reference website.
///
/// Composition:
///   1. Primary Action: "Get in touch" (Filled dark plum pill/rounded button).
///   2. Secondary Action: "View My Work" (Delicate outlined button with downward arrow).
///   3. Functional CV Action: "Download CV" (Delicate outlined button with download icon).
class HeroActions extends StatefulWidget {
  const HeroActions({
    super.key,
    required this.opacity,
    required this.slideOffset,
    required this.onViewWorkTap,
    this.onGetInTouchTap,
  });

  final double opacity;
  final Offset slideOffset;
  final VoidCallback onViewWorkTap;
  final VoidCallback? onGetInTouchTap;

  @override
  State<HeroActions> createState() => _HeroActionsState();
}

class _HeroActionsState extends State<HeroActions> {
  bool _downloading = false;

  static const String _cvAssetPath = 'assets/documents/romisaa_fadel_cv.pdf';
  static const String _cvDownloadName = 'Romisaa_Fadel_CV.pdf';

  Future<void> _handleDownload(AppLocalizations l10n) async {
    if (_downloading) return;
    setState(() => _downloading = true);

    try {
      await rootBundle.load(_cvAssetPath);
      await downloadAsset(
        assetPath: _cvAssetPath,
        downloadFilename: _cvDownloadName,
      );
    } on FlutterError {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.heroCvMissing),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.mauve,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  void _handleDefaultGetInTouch(BuildContext context, AppLocalizations l10n) {
    if (widget.onGetInTouchTap != null) {
      widget.onGetInTouchTap!();
      return;
    }

    // Friendly non-broken feedback with direct contact email
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.mail_outline_rounded, color: AppColors.ivory, size: 18),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Romisaa Fadel · romisaa.fadel@example.com',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.deepPlum,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCompact = context.isCompact;

    return Opacity(
      opacity: widget.opacity,
      child: Transform.translate(
        offset: widget.slideOffset,
        child: Wrap(
          alignment: isCompact ? WrapAlignment.center : WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 14,
          runSpacing: 12,
          children: [
            // ── 1. Primary Filled Button: Get in touch ────────────────────
            _PrimaryButton(
              label: l10n.heroGetInTouch,
              tooltip: l10n.heroGetInTouchTooltip,
              isDark: isDark,
              onTap: () => _handleDefaultGetInTouch(context, l10n),
            ),

            // ── 2. Secondary Outlined Button: View My Work ────────────────
            _OutlinedActionButton(
              label: l10n.heroViewWork,
              tooltip: l10n.heroViewWorkTooltip,
              icon: Icons.arrow_downward_rounded,
              isDark: isDark,
              onTap: widget.onViewWorkTap,
            ),

            // ── 3. Functional Action Button: Download CV ──────────────────
            _OutlinedActionButton(
              label: l10n.heroCvDownload,
              tooltip: l10n.heroCvDownloadTooltip,
              icon: Icons.download_rounded,
              loading: _downloading,
              isDark: isDark,
              onTap: () => _handleDownload(l10n),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Primary filled button (Dark plum in light mode, Ivory in dark mode)
// ─────────────────────────────────────────────────────────────────────────────

class _PrimaryButton extends StatefulWidget {
  const _PrimaryButton({
    required this.label,
    required this.tooltip,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final String tooltip;
  final bool isDark;
  final VoidCallback onTap;

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;

    final bgColor = isDark
        ? (_hovered ? AppColors.softBlush : AppColors.ivory)
        : (_hovered ? AppColors.mauve : AppColors.deepPlum);

    final fgColor = isDark ? AppColors.deepPlum : AppColors.ivory;

    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: _pressed ? 0.97 : (_hovered ? 1.02 : 1.0),
            duration: const Duration(milliseconds: 150),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(
                horizontal: 26,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: (isDark ? Colors.black : AppColors.deepPlum)
                        .withValues(alpha: _hovered ? 0.30 : 0.14),
                    blurRadius: _hovered ? 16 : 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                widget.label,
                style: TextStyle(
                  color: fgColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.5,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Secondary delicate outlined action button
// ─────────────────────────────────────────────────────────────────────────────

class _OutlinedActionButton extends StatefulWidget {
  const _OutlinedActionButton({
    required this.label,
    required this.tooltip,
    required this.isDark,
    required this.onTap,
    this.icon,
    this.loading = false,
  });

  final String label;
  final String tooltip;
  final bool isDark;
  final VoidCallback onTap;
  final IconData? icon;
  final bool loading;

  @override
  State<_OutlinedActionButton> createState() => _OutlinedActionButtonState();
}

class _OutlinedActionButtonState extends State<_OutlinedActionButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;

    final borderColor = _hovered
        ? (isDark ? AppColors.dustyRose : AppColors.mauve)
        : (isDark
            ? AppColors.darkBorder
            : AppColors.lightBorder.withValues(alpha: 0.85));

    final hoverBg = isDark
        ? AppColors.mauve.withValues(alpha: 0.16)
        : AppColors.softBlush.withValues(alpha: 0.35);

    final fgColor = isDark
        ? (_hovered ? AppColors.ivory : AppColors.ivory.withValues(alpha: 0.85))
        : (_hovered ? AppColors.deepPlum : AppColors.deepPlum.withValues(alpha: 0.85));

    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: widget.loading ? null : widget.onTap,
          child: AnimatedScale(
            scale: _pressed ? 0.97 : (_hovered ? 1.02 : 1.0),
            duration: const Duration(milliseconds: 150),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 13,
              ),
              decoration: BoxDecoration(
                color: _hovered ? hoverBg : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor, width: 1.2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: fgColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.5,
                      letterSpacing: 0.2,
                    ),
                  ),
                  if (widget.loading) ...[
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: fgColor,
                      ),
                    ),
                  ] else if (widget.icon != null) ...[
                    const SizedBox(width: 8),
                    AnimatedSlide(
                      offset: _hovered
                          ? (widget.icon == Icons.arrow_downward_rounded
                              ? const Offset(0, 0.15)
                              : const Offset(0, 0.12))
                          : Offset.zero,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        widget.icon,
                        color: fgColor,
                        size: 15,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
