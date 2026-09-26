import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

class MeloChip extends StatelessWidget {
  const MeloChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.icon,
    this.selectedColor,
  });

  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final dynamic icon;
  final Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseSelectedColor = selectedColor ??
        (isDark ? AppColors.darkPrimary.withOpacity(0.25) : AppColors.primaryLight.withOpacity(0.25));

    final backgroundColor = isSelected
        ? baseSelectedColor
        : (isDark ? AppColors.darkSurfaceHighlight : AppColors.secondarySurface);

    final textColor = isSelected
        ? (isDark ? AppColors.darkPrimary : AppColors.primaryDark)
        : (isDark ? AppColors.darkTextPrimary : AppColors.deepText);

    final border = isSelected
        ? BorderSide(
            color: isDark ? AppColors.darkPrimary : AppColors.primary,
            width: 1.2,
          )
        : BorderSide.none;

    Widget? leadingIcon;
    if (icon != null) {
      if (icon is IconData) {
        leadingIcon = Icon(icon as IconData, size: 16, color: textColor);
      } else if (icon is Widget) {
        leadingIcon = icon as Widget;
      }
    }

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 44.0,
        ),
        child: Material(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.roundedSmall,
            side: border,
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: AppSpacing.roundedSmall,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
              child: Center(
                widthFactor: 1.0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (leadingIcon != null) ...[
                      leadingIcon,
                      const SizedBox(width: AppSpacing.xs),
                    ],
                    Text(
                      label,
                      style: AppTypography.bodySmall.copyWith(
                        color: textColor,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
