import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import 'melo_button.dart';

class MeloDialog extends StatelessWidget {
  const MeloDialog({
    super.key,
    required this.title,
    required this.content,
    this.primaryActionLabel = 'Confirm',
    this.secondaryActionLabel = 'Cancel',
    this.onPrimaryAction,
    this.onSecondaryAction,
    this.isDestructive = false,
  });

  final String title;
  final String content;
  final String primaryActionLabel;
  final String? secondaryActionLabel;
  final VoidCallback? onPrimaryAction;
  final VoidCallback? onSecondaryAction;
  final bool isDestructive;

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String content,
    String primaryActionLabel = 'Confirm',
    String? secondaryActionLabel = 'Cancel',
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => MeloDialog(
        title: title,
        content: content,
        primaryActionLabel: primaryActionLabel,
        secondaryActionLabel: secondaryActionLabel,
        isDestructive: isDestructive,
        onPrimaryAction: () => Navigator.of(ctx).pop(true),
        onSecondaryAction: () => Navigator.of(ctx).pop(false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.cardSurface,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.roundedCard,
        side: BorderSide(
          color: isDark ? AppColors.darkSurfaceHighlight : const Color(0xFFE5E9E1),
        ),
      ),
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: AppTypography.heading2.copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.deepText,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              content,
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (secondaryActionLabel != null)
                  TextButton(
                    onPressed: onSecondaryAction ?? () => Navigator.of(context).pop(false),
                    child: Text(
                      secondaryActionLabel!,
                      style: AppTypography.button.copyWith(
                        color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
                      ),
                    ),
                  ),
                const SizedBox(width: AppSpacing.sm),
                MeloButton(
                  label: primaryActionLabel,
                  variant: isDestructive
                      ? MeloButtonVariant.secondary
                      : MeloButtonVariant.primary,
                  onPressed: onPrimaryAction ?? () => Navigator.of(context).pop(true),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
