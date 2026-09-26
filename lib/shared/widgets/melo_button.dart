import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

import 'package:flutter/services.dart';

enum MeloButtonVariant {
  primary,
  secondary,
  ghost,
}

class MeloButton extends StatefulWidget {
  const MeloButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = MeloButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final MeloButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;

  @override
  State<MeloButton> createState() => _MeloButtonState();
}

class _MeloButtonState extends State<MeloButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    final backgroundColor = isEnabled
        ? switch (widget.variant) {
            MeloButtonVariant.primary =>
              isDark ? AppColors.darkPrimary : AppColors.primary,
            MeloButtonVariant.secondary =>
              isDark ? AppColors.darkSurfaceHighlight : AppColors.secondarySurface,
            MeloButtonVariant.ghost => Colors.transparent,
          }
        : switch (widget.variant) {
            MeloButtonVariant.primary => isDark
                ? AppColors.darkSurfaceHighlight.withOpacity(0.4)
                : const Color(0xFFD6DCD4).withOpacity(0.6),
            MeloButtonVariant.secondary => isDark
                ? AppColors.darkSurface.withOpacity(0.5)
                : AppColors.secondarySurface.withOpacity(0.5),
            MeloButtonVariant.ghost => Colors.transparent,
          };

    final textColor = isEnabled
        ? switch (widget.variant) {
            MeloButtonVariant.primary =>
              isDark ? AppColors.darkBackground : Colors.white,
            MeloButtonVariant.secondary =>
              isDark ? AppColors.darkTextPrimary : AppColors.deepText,
            MeloButtonVariant.ghost =>
              isDark ? AppColors.darkPrimary : AppColors.primary,
          }
        : (isDark
            ? AppColors.darkTextMuted.withOpacity(0.45)
            : AppColors.mutedText.withOpacity(0.5));

    final border = isEnabled
        ? switch (widget.variant) {
            MeloButtonVariant.secondary => BorderSide(
                color: isDark ? AppColors.darkBorder : const Color(0xFFD6DCD4),
                width: 1.0,
              ),
            _ => BorderSide.none,
          }
        : BorderSide.none;

    Widget content = Row(
      mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isLoading) ...[
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(textColor),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ] else if (widget.icon != null) ...[
          Icon(widget.icon, size: 18, color: textColor),
          const SizedBox(width: AppSpacing.xs),
        ],
        Text(
          widget.label,
          style: AppTypography.button.copyWith(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );

    return AnimatedScale(
      scale: (_isPressed && isEnabled) ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOutCubic,
      child: Semantics(
        button: true,
        label: widget.label,
        enabled: isEnabled,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: AppSpacing.minTouchTarget,
          ),
          child: Material(
            color: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: AppSpacing.roundedButton,
              side: border,
            ),
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
              borderRadius: AppSpacing.roundedButton,
              child: Padding(
                padding: AppSpacing.buttonPadding,
                child: Center(child: content),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
