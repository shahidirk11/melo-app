import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/widgets/melo_card.dart';
import '../../../../shared/widgets/melo_progress_indicator.dart';
import '../../domain/progress_analytics.dart';

class GentleStreakBanner extends StatelessWidget {
  const GentleStreakBanner({
    super.key,
    required this.summary,
  });

  final ProgressSummary summary;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final weeklyGoalMinutes = 35; // 5 min/day gentle target
    final weeklyRatio = (summary.weeklyMinutes / weeklyGoalMinutes).clamp(0.0, 1.0);

    return MeloCard(
      style: MeloCardStyle.hero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkPrimary.withOpacity(0.25)
                      : AppColors.primaryLight.withOpacity(0.35),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('🌱', style: TextStyle(fontSize: 26)),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      summary.streakHeadline,
                      style: AppTypography.heading2,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      summary.streakSubtitle,
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColors.darkMutedText : AppColors.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weekly flow',
                style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                '${summary.weeklyMinutes} min practiced',
                style: AppTypography.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          MeloLinearProgressIndicator(
            progress: weeklyRatio,
            height: 8.0,
          ),
        ],
      ),
    );
  }
}
