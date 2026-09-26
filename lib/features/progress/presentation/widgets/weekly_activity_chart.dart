import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/widgets/melo_card.dart';
import '../../../../shared/widgets/melo_section_header.dart';
import '../../domain/progress_analytics.dart';

class WeeklyActivityChart extends StatelessWidget {
  const WeeklyActivityChart({
    super.key,
    required this.summary,
  });

  final ProgressSummary summary;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final maxMinutes = summary.last7Days
        .map((d) => d.minutes)
        .fold<int>(15, (max, m) => m > max ? m : max);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MeloSectionHeader(
          eyebrow: 'Activity',
          title: 'This Week',
        ),
        const SizedBox(height: AppSpacing.sm),
        MeloCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 7-day bar visualization
              SizedBox(
                height: 140,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: summary.last7Days.map((day) {
                    final ratio = maxMinutes > 0 ? (day.minutes / maxMinutes) : 0.0;
                    final barHeight = (ratio * 70.0).clamp(day.minutes > 0 ? 8.0 : 4.0, 70.0);

                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Minutes label
                          Text(
                            day.minutes > 0 ? '${day.minutes}m' : '-',
                            style: AppTypography.caption.copyWith(
                              fontSize: 10,
                              fontWeight: day.isToday ? FontWeight.bold : FontWeight.normal,
                              color: day.isToday
                                  ? AppColors.primary
                                  : (isDark ? AppColors.darkMutedText : AppColors.mutedText),
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Vertical Bar
                          Container(
                            width: 22,
                            height: 70,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkSurfaceHighlight
                                  : AppColors.secondarySurface,
                              borderRadius: BorderRadius.circular(11),
                              border: day.isToday
                                  ? Border.all(color: AppColors.primary, width: 1.5)
                                  : null,
                            ),
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: 22,
                              height: barHeight,
                              decoration: BoxDecoration(
                                color: day.minutes > 0
                                    ? (day.isToday ? AppColors.primary : AppColors.primaryLight)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(11),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Day of Week Label
                          Text(
                            day.dayOfWeekLabel,
                            style: AppTypography.caption.copyWith(
                              fontWeight: day.isToday ? FontWeight.bold : FontWeight.w600,
                              color: day.isToday
                                  ? AppColors.primary
                                  : (isDark ? AppColors.darkText : AppColors.deepText),
                            ),
                          ),

                          // Day of Month number
                          Text(
                            '${day.dayOfMonth}',
                            style: AppTypography.caption.copyWith(
                              fontSize: 10,
                              color: isDark ? AppColors.darkMutedText : AppColors.mutedText,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Non-clinical, supportive weekly summary text
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceHighlight
                      : AppColors.secondarySurface,
                  borderRadius: AppSpacing.roundedMedium,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.spa_outlined,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        summary.weeklyCopy,
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark ? AppColors.darkText : AppColors.deepText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
