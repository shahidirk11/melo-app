import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../data/models/session_record_model.dart';
import '../../../shared/animations/melo_slide_transition.dart';
import '../../../shared/widgets/melo_bottom_sheet.dart';
import '../../../shared/widgets/melo_responsive_container.dart';
import '../../../shared/widgets/melo_section_header.dart';
import '../../../shared/widgets/melo_snackbar.dart';
import '../../../shared/widgets/state_views/empty_view.dart';
import '../../../shared/widgets/state_views/error_view.dart';
import '../../../shared/widgets/state_views/loading_view.dart';
import 'progress_provider.dart';
import 'widgets/gentle_streak_banner.dart';
import 'widgets/monthly_summary_card.dart';
import 'widgets/practice_metrics_grid.dart';
import 'widgets/session_record_card.dart';
import 'widgets/session_record_details_modal.dart';
import 'widgets/weekly_activity_chart.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  void _openRecordDetails(
    BuildContext context,
    WidgetRef ref,
    SessionRecord record,
  ) {
    MeloBottomSheet.show(
      context,
      child: SessionRecordDetailsModal(
        record: record,
        onDelete: () async {
          await ref.read(progressNotifierProvider.notifier).deleteRecord(record.id);
          if (context.mounted) {
            MeloSnackbar.show(
              context,
              message: 'Practice record removed.',
              type: MeloSnackbarType.info,
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(progressNotifierProvider);
    final notifier = ref.read(progressNotifierProvider.notifier);

    if (state.isLoading && state.history.isEmpty) {
      return const Scaffold(
        body: SafeArea(
          child: LoadingView(message: 'Loading your mindful journey...'),
        ),
      );
    }

    if (state.errorMessage != null && state.history.isEmpty) {
      return Scaffold(
        body: SafeArea(
          child: ErrorView(
            title: 'Unable to load progress',
            message: state.errorMessage!,
            retryLabel: 'Try again',
            onRetry: () => notifier.load(),
          ),
        ),
      );
    }

    final summary = state.summary;
    final history = state.history;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: MeloResponsiveContainer(
          child: RefreshIndicator(
            color: isDark ? AppColors.darkPrimary : AppColors.primary,
            onRefresh: () => notifier.load(),
            child: ListView(
              padding: AppSpacing.screenPadding,
              children: [
                // 1. Header
                MeloSlideTransition(
                  delay: const Duration(milliseconds: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Journey',
                        style: AppTypography.display.copyWith(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.deepText,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        'Small mindful pauses add up to lasting peace.',
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // 2. Gentle Streak Banner
                MeloSlideTransition(
                  delay: const Duration(milliseconds: 100),
                  child: GentleStreakBanner(summary: summary),
                ),
                const SizedBox(height: AppSpacing.lg),

                // 3. Core Metric Stat Cards Grid
                MeloSlideTransition(
                  delay: const Duration(milliseconds: 150),
                  child: PracticeMetricsGrid(summary: summary),
                ),
                const SizedBox(height: AppSpacing.xl),

                // 4. Weekly Activity Bar Chart
                MeloSlideTransition(
                  delay: const Duration(milliseconds: 200),
                  child: WeeklyActivityChart(summary: summary),
                ),
                const SizedBox(height: AppSpacing.xl),

                // 5. Monthly Summary Card
                MeloSlideTransition(
                  delay: const Duration(milliseconds: 250),
                  child: MonthlySummaryCard(summary: summary),
                ),
                const SizedBox(height: AppSpacing.xl),

                // 6. Practice History Section
                MeloSlideTransition(
                  delay: const Duration(milliseconds: 300),
                  child: MeloSectionHeader(
                    eyebrow: 'History',
                    title: 'Recent Resets',
                    actionLabel: history.isNotEmpty ? '${history.length}' : null,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),

                if (history.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                    child: EmptyView(
                      title: 'No practice history yet',
                      message: 'Every gentle pause you complete will appear here.',
                      icon: Icons.history_rounded,
                    ),
                  )
                else
                  Column(
                    children: history.map((record) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: SessionRecordCard(
                          record: record,
                          onTap: () => _openRecordDetails(context, ref, record),
                        ),
                      );
                    }).toList(),
                  ),

                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
