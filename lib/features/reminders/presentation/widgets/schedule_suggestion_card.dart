import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/widgets/melo_button.dart';
import '../../../../shared/widgets/melo_card.dart';
import '../../domain/schedule_suggestion_service.dart';

class ScheduleSuggestionCard extends StatelessWidget {
  const ScheduleSuggestionCard({
    super.key,
    required this.suggestion,
    required this.onAccept,
    required this.onDismiss,
  });

  final ScheduleAdjustmentSuggestion suggestion;
  final VoidCallback onAccept;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MeloCard(
      style: MeloCardStyle.hero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkPrimary.withOpacity(0.25)
                      : AppColors.primaryLight.withOpacity(0.35),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('🌿', style: TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Natural rhythm detected',
                      style: AppTypography.heading3,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      suggestion.reason,
                      style: AppTypography.caption.copyWith(
                        color: isDark ? AppColors.darkMutedText : AppColors.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            suggestion.promptQuestion,
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: MeloButton(
                  label: 'Update to ${suggestion.suggestedFormattedTime}',
                  variant: MeloButtonVariant.primary,
                  onPressed: onAccept,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: MeloButton(
                  label: 'Keep ${suggestion.currentFormattedTime}',
                  variant: MeloButtonVariant.secondary,
                  onPressed: onDismiss,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
