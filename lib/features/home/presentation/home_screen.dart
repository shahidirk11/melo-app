import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/providers.dart';
import '../../../app/router/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../data/models/mood_entry_model.dart';
import '../../../data/models/session_model.dart';
import '../../../shared/animations/melo_slide_transition.dart';
import '../../../shared/widgets/melo_badge.dart';
import '../../../shared/widgets/melo_button.dart';
import '../../../shared/widgets/melo_card.dart';
import '../../../shared/widgets/melo_chip.dart';
import '../../../shared/widgets/melo_responsive_container.dart';
import '../../../shared/widgets/melo_section_header.dart';
import '../../../shared/widgets/melo_snackbar.dart';
import '../../../shared/widgets/state_views/error_view.dart';
import '../../../shared/widgets/state_views/loading_view.dart';
import 'home_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _recordMood(
    BuildContext context,
    WidgetRef ref,
    MoodType mood,
  ) async {
    final moodRepo = ref.read(moodRepositoryProvider);
    await moodRepo.recordMood(mood);
    // Invalidate home state so recommendations dynamically adapt
    ref.invalidate(homeViewStateProvider);

    if (context.mounted) {
      MeloSnackbar.show(
        context,
        message: 'Feeling ${mood.label}. Tailoring your recommendations.',
        type: MeloSnackbarType.info,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeStateAsync = ref.watch(homeViewStateProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: MeloResponsiveContainer(
          child: homeStateAsync.when(
            loading: () => const LoadingView(
              message: 'Preparing your peaceful reset...',
            ),
            error: (err, stack) => ErrorView(
              title: 'Unable to load today\'s reset',
              message: 'Please take a deep breath and try again.',
              onRetry: () => ref.invalidate(homeViewStateProvider),
            ),
            data: (state) {
              return ListView(
                padding: AppSpacing.screenPadding,
                children: [
                  // 1. Time-aware Greeting
                  MeloSlideTransition(
                    delay: const Duration(milliseconds: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.greeting,
                          style: AppTypography.display.copyWith(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.deepText,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          'Take a gentle moment for yourself today.',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // 2. Mood Check-in Section
                  MeloSlideTransition(
                    delay: const Duration(milliseconds: 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const MeloSectionHeader(
                          eyebrow: 'Check-in',
                          title: 'How are you feeling?',
                        ),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: MoodType.values.map((mood) {
                            final isSelected = state.selectedMood == mood;
                            return MeloChip(
                              label: '${mood.emoji} ${mood.label}',
                              isSelected: isSelected,
                              onTap: () => _recordMood(context, ref, mood),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // 3. Primary Daily Reset Recommendation
                  MeloSlideTransition(
                    delay: const Duration(milliseconds: 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const MeloSectionHeader(
                          eyebrow: 'Your Daily Reset',
                          title: 'Recommended for you',
                        ),
                        MeloCard(
                          style: MeloCardStyle.hero,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  MeloBadge(
                                    label: '${state.primarySession.durationMinutes} min',
                                    variant: MeloBadgeVariant.primary,
                                    icon: Icons.timer_outlined,
                                  ),
                                  const SizedBox(width: AppSpacing.xs),
                                  MeloBadge(
                                    label: state.primarySession.category.displayName,
                                    variant: MeloBadgeVariant.accent,
                                  ),
                                  const SizedBox(width: AppSpacing.xs),
                                  MeloBadge(
                                    label: state.primarySession.difficulty.displayName,
                                    variant: MeloBadgeVariant.surface,
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                state.primarySession.title,
                                style: AppTypography.heading1.copyWith(
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.deepText,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                state.primarySession.description,
                                style: AppTypography.body.copyWith(
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.deepText,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.darkSurfaceHighlight.withOpacity(0.5)
                                      : AppColors.secondarySurface,
                                  borderRadius: AppSpacing.roundedSmall,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.auto_awesome_rounded,
                                      size: 16,
                                      color: isDark ? AppColors.darkPrimary : AppColors.primary,
                                    ),
                                    const SizedBox(width: AppSpacing.xs),
                                    Expanded(
                                      child: Text(
                                        state.recommendationReason,
                                        style: AppTypography.bodySmall.copyWith(
                                          fontStyle: FontStyle.italic,
                                          color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              MeloButton(
                                label: 'Start reset',
                                icon: Icons.play_arrow_rounded,
                                onPressed: () {
                                  context.push(
                                    AppRoutes.sessionPath(state.primarySession.id),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // 4. Quick-Reset Actions (1-3 min)
                  if (state.quickResets.isNotEmpty) ...[
                    MeloSlideTransition(
                      delay: const Duration(milliseconds: 160),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const MeloSectionHeader(
                            eyebrow: 'Bite-Sized',
                            title: 'Quick Resets',
                            subtitle: 'When you only have a few moments',
                          ),
                          Row(
                            children: [
                              for (int i = 0; i < state.quickResets.take(2).length; i++) ...[
                                if (i > 0) const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: MeloCard(
                                    padding: AppSpacing.cardPaddingCompact,
                                    onTap: () {
                                      context.push(AppRoutes.sessionPath(state.quickResets[i].id));
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          state.quickResets[i].category == SessionCategory.breathing
                                              ? Icons.air_rounded
                                              : Icons.timer_outlined,
                                          size: 20,
                                          color: isDark ? AppColors.darkPrimary : AppColors.primary,
                                        ),
                                        const SizedBox(height: AppSpacing.sm),
                                        Text(
                                          state.quickResets[i].title,
                                          style: AppTypography.heading3.copyWith(
                                            fontSize: 15,
                                            color: isDark ? AppColors.darkTextPrimary : AppColors.deepText,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${state.quickResets[i].durationMinutes} min · ${state.quickResets[i].category.displayName}',
                                          style: AppTypography.caption.copyWith(
                                            color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],

                  // 5. Today's Practice Card
                  MeloSlideTransition(
                    delay: const Duration(milliseconds: 200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const MeloSectionHeader(
                          eyebrow: 'Daily Rhythm',
                          title: 'Today\'s Practice',
                        ),
                        MeloCard(
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.darkPrimary.withOpacity(0.2)
                                      : AppColors.primaryLight.withOpacity(0.2),
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
                                      state.todayMinutes > 0
                                          ? '${state.todayMinutes} min practiced today'
                                          : 'No practice yet today',
                                      style: AppTypography.heading3.copyWith(
                                        color: isDark ? AppColors.darkTextPrimary : AppColors.deepText,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      state.todayMinutes > 0
                                          ? '${state.todaySessionsCount} ${state.todaySessionsCount == 1 ? "reset" : "resets"} completed'
                                          : 'Ready whenever you need a pause',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 6. Upcoming Reminder Preview (if notifications enabled)
                  if (state.upcomingReminder != null) ...[
                    const SizedBox(height: AppSpacing.xl),
                    MeloSlideTransition(
                      delay: const Duration(milliseconds: 240),
                      child: MeloCard(
                        onTap: () => context.push(AppRoutes.profileReminders),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.md,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.notifications_active_outlined,
                              size: 20,
                              color: isDark ? AppColors.darkPrimary : AppColors.primary,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Upcoming Reminder',
                                    style: AppTypography.caption.copyWith(
                                      color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    state.upcomingReminder!,
                                    style: AppTypography.bodySmall.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? AppColors.darkTextPrimary
                                          : AppColors.deepText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  // 7. Secondary Suggestion (if available)
                  if (state.secondarySuggestion != null) ...[
                    const SizedBox(height: AppSpacing.xl),
                    MeloSlideTransition(
                      delay: const Duration(milliseconds: 280),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const MeloSectionHeader(
                            eyebrow: 'Also for you',
                            title: 'Wind-Down Option',
                          ),
                          MeloCard(
                            onTap: () {
                              context.push(
                                AppRoutes.sessionPath(state.secondarySuggestion!.id),
                              );
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColors.darkSurfaceHighlight
                                        : AppColors.secondarySurface,
                                    borderRadius: AppSpacing.roundedSmall,
                                  ),
                                  child: Icon(
                                    Icons.nightlight_round,
                                    color: isDark ? AppColors.darkPrimary : AppColors.primary,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.secondarySuggestion!.title,
                                        style: AppTypography.heading3.copyWith(
                                          color: isDark ? AppColors.darkTextPrimary : AppColors.deepText,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${state.secondarySuggestion!.durationMinutes} min · ${state.secondarySuggestion!.category.displayName}',
                                        style: AppTypography.bodySmall.copyWith(
                                          color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xxl),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
