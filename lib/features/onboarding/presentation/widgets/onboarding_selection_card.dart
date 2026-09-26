import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/widgets/melo_card.dart';

class OnboardingSelectionCard extends StatelessWidget {
  const OnboardingSelectionCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.isSelected = false,
    required this.onTap,
    this.isMultiSelect = false,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isMultiSelect;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final selectedBorder = BorderSide(
      color: isDark ? AppColors.darkPrimary : AppColors.primary,
      width: 1.8,
    );

    final defaultBorder = BorderSide(
      color: isDark ? AppColors.darkSurfaceHighlight : const Color(0xFFE5E9E1),
      width: 1.0,
    );

    final backgroundColor = isSelected
        ? (isDark
            ? AppColors.darkPrimary.withOpacity(0.12)
            : AppColors.primaryLight.withOpacity(0.16))
        : (isDark ? AppColors.darkSurface : AppColors.cardSurface);

    return Material(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.roundedCard,
        side: isSelected ? selectedBorder : defaultBorder,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.roundedCard,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDark
                            ? AppColors.darkPrimary.withOpacity(0.2)
                            : AppColors.primary.withOpacity(0.15))
                        : (isDark
                            ? AppColors.darkSurfaceHighlight
                            : AppColors.secondarySurface),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: isSelected
                        ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                        : (isDark ? AppColors.darkTextMuted : AppColors.mutedText),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AppTypography.heading3.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.deepText,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // Selection Indicator (Checkbox or Radio style)
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: isMultiSelect ? BoxShape.rectangle : BoxShape.circle,
                  borderRadius: isMultiSelect ? BorderRadius.circular(6) : null,
                  color: isSelected
                      ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                        : (isDark ? AppColors.darkTextMuted : const Color(0xFFC7CEC4)),
                    width: 1.5,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        size: 15,
                        color: Colors.white,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
