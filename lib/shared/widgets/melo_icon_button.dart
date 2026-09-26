import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

import 'package:flutter/services.dart';

enum MeloIconButtonVariant {
  standard,
  surface,
  filled,
}

class MeloIconButton extends StatefulWidget {
  const MeloIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.variant = MeloIconButtonVariant.surface,
    this.size = AppSpacing.iconButtonSize,
    this.iconSize = 22.0,
    this.color,
    this.showBadge = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final MeloIconButtonVariant variant;
  final double size;
  final double iconSize;
  final Color? color;
  final bool showBadge;

  @override
  State<MeloIconButton> createState() => _MeloIconButtonState();
}

class _MeloIconButtonState extends State<MeloIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEnabled = widget.onPressed != null;

    final defaultIconColor = widget.color ??
        (isDark ? AppColors.darkTextPrimary : AppColors.deepText);

    final backgroundColor = isEnabled
        ? switch (widget.variant) {
            MeloIconButtonVariant.standard => Colors.transparent,
            MeloIconButtonVariant.surface =>
              isDark ? AppColors.darkSurfaceHighlight : AppColors.secondarySurface,
            MeloIconButtonVariant.filled =>
              isDark ? AppColors.darkPrimary : AppColors.primary,
          }
        : switch (widget.variant) {
            MeloIconButtonVariant.standard => Colors.transparent,
            MeloIconButtonVariant.surface =>
              (isDark ? AppColors.darkSurfaceHighlight : AppColors.secondarySurface)
                  .withOpacity(0.5),
            MeloIconButtonVariant.filled =>
              (isDark ? AppColors.darkPrimary : AppColors.primary).withOpacity(0.4),
          };

    final resolvedIconColor = !isEnabled
        ? (isDark
            ? AppColors.darkTextMuted.withOpacity(0.4)
            : AppColors.mutedText.withOpacity(0.4))
        : (widget.variant == MeloIconButtonVariant.filled
            ? (isDark ? AppColors.darkBackground : Colors.white)
            : defaultIconColor);

    Widget button = AnimatedScale(
      scale: (_isPressed && isEnabled) ? 0.92 : 1.0,
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOutCubic,
      child: Material(
        color: backgroundColor,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isEnabled
              ? () {
                  HapticFeedback.selectionClick();
                  widget.onPressed!();
                }
              : null,
          onHighlightChanged: isEnabled
              ? (pressed) {
                  setState(() => _isPressed = pressed);
                }
              : null,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  widget.icon,
                  size: widget.iconSize,
                  color: resolvedIconColor,
                ),
                if (widget.showBadge)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkPrimary : AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    // Ensure accessible tap target of at least minTouchTarget (48x48)
    if (widget.size < AppSpacing.minTouchTarget) {
      button = ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: AppSpacing.minTouchTarget,
          minHeight: AppSpacing.minTouchTarget,
        ),
        child: Center(child: button),
      );
    }

    button = Semantics(
      button: true,
      label: widget.tooltip ?? 'button',
      enabled: isEnabled,
      child: button,
    );

    if (widget.tooltip != null) {
      return Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }

    return button;
  }
}
