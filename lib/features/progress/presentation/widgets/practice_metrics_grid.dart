import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/widgets/melo_card.dart';
import '../../domain/progress_analytics.dart';

class PracticeMetricsGrid extends StatelessWidget {
  const PracticeMetricsGrid({
    super.key,
    required this.summary,
  });

  final ProgressSummary summary;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: MeloCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${summary.totalMinutes}',
                      style: AppTypography.display.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.deepText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Total minutes',
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: MeloCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${summary.totalSessions}',
                      style: AppTypography.display.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.deepText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Resets completed',
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: MeloCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${summary.activeDays}',
                      style: AppTypography.display.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.deepText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Active days',
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: MeloCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${summary.todayMinutes}',
                      style: AppTypography.display.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.deepText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Today's minutes",
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
