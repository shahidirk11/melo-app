import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

enum MeloBadgeVariant {
  primary,
  accent,
  surface,
  success,
  neutral,
  outline,
}

class MeloBadge extends StatelessWidget {
  const MeloBadge({
    super.key,
    required this.label,
    this.variant = MeloBadgeVariant.primary,
    this.icon,
  });

  final String label;
  final MeloBadgeVariant variant;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final (bgColor, textColor, border) = switch (variant) {
      MeloBadgeVariant.primary => (
          isDark
              ? AppColors.darkPrimary.withOpacity(0.2)
              : AppColors.primaryLight.withOpacity(0.25),
          isDark ? AppColors.darkPrimary : AppColors.primaryDark,
          null,
        ),
      MeloBadgeVariant.accent => (
          isDark
              ? AppColors.darkAccent.withOpacity(0.2)
              : AppColors.softAccent.withOpacity(0.4),
          isDark ? AppColors.darkAccent : const Color(0xFF8C733E),
          null,
        ),
      MeloBadgeVariant.surface => (
          isDark ? AppColors.darkSurfaceHighlight : AppColors.secondarySurface,
          isDark ? AppColors.darkTextMuted : AppColors.mutedText,
          null,
        ),
      MeloBadgeVariant.success => (
          AppColors.success.withOpacity(0.15),
          AppColors.success,
          null,
        ),
      MeloBadgeVariant.neutral => (
          isDark ? AppColors.darkSurfaceHighlight : AppColors.secondarySurface,
          isDark ? AppColors.darkTextMuted : AppColors.mutedText,
          null,
        ),
      MeloBadgeVariant.outline => (
          Colors.transparent,
          isDark ? AppColors.darkTextMuted : AppColors.mutedText,
          Border.all(
            color: isDark ? AppColors.darkBorder : const Color(0xFFD6DCD4),
            width: 1.0,
          ),
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppSpacing.roundedSmall,
        border: border,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
