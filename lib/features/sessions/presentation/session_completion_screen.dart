import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/providers.dart';
import '../../../app/router/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../data/models/mood_entry_model.dart';
import '../../../shared/animations/melo_fade_scale.dart';
import '../../../shared/animations/melo_slide_transition.dart';
import '../../../shared/widgets/melo_badge.dart';
import '../../../shared/widgets/melo_button.dart';
import '../../../shared/widgets/melo_card.dart';
import '../../../shared/widgets/melo_chip.dart';
import '../../../shared/widgets/melo_responsive_container.dart';
import '../../../shared/widgets/melo_snackbar.dart';
import 'session_provider.dart';

class SessionCompletionScreen extends ConsumerStatefulWidget {
  const SessionCompletionScreen({
    super.key,
    required this.sessionId,
  });

  final String sessionId;

  @override
  ConsumerState<SessionCompletionScreen> createState() =>
      _SessionCompletionScreenState();
}

class _SessionCompletionScreenState
    extends ConsumerState<SessionCompletionScreen> {
  ReflectionMood? _selectedReflection;

  Future<void> _onSelectReflection(ReflectionMood mood) async {
    setState(() => _selectedReflection = mood);
    await ref.read(sessionEngineProvider.notifier).recordReflection(mood);
    if (mounted) {
      MeloSnackbar.show(
        context,
        message: 'Reflection recorded. Thank you for taking this time.',
        type: MeloSnackbarType.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final playback = ref.watch(sessionEngineProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final session = playback.session;
    final minutesCompleted = playback.elapsedSeconds > 0
        ? (playback.elapsedSeconds / 60).round().clamp(1, 60)
        : 1;

    return Scaffold(
      body: SafeArea(
        child: MeloResponsiveContainer(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: AppSpacing.screenPadding,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(height: AppSpacing.md),

                        // Gentle Celebration Icon & Header
                        Column(
                          children: [
                            MeloFadeScale(
                              child: Container(
                                width: 88,
                                height: 88,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.darkPrimary.withOpacity(0.2)
                                      : AppColors.primaryLight.withOpacity(0.25),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Text('🌿', style: TextStyle(fontSize: 40)),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xl),

                            MeloSlideTransition(
                              delay: const Duration(milliseconds: 100),
                              child: Text(
                                'Nice work',
                                style: AppTypography.display.copyWith(
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.deepText,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),

                            MeloSlideTransition(
                              delay: const Duration(milliseconds: 150),
                              child: Text(
                                'You gave yourself $minutesCompleted ${minutesCompleted == 1 ? "minute" : "minutes"} of quiet care.',
                                style: AppTypography.bodySmall.copyWith(
                                  color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        // Session Summary Card
                        if (session != null)
                          MeloSlideTransition(
                            delay: const Duration(milliseconds: 200),
                            child: MeloCard(
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
                                      Icons.check_circle_outline_rounded,
                                      color: isDark ? AppColors.darkPrimary : AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          session.title,
                                          style: AppTypography.heading3.copyWith(
                                            color: isDark ? AppColors.darkTextPrimary : AppColors.deepText,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${session.category.displayName} · Completed',
                                          style: AppTypography.caption.copyWith(
                                            color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(height: AppSpacing.xl),

                        // Reflection Question
                        MeloSlideTransition(
                          delay: const Duration(milliseconds: 250),
                          child: Column(
                            children: [
                              Text(
                                'How do you feel now?',
                                style: AppTypography.heading2.copyWith(
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.deepText,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Wrap(
                                spacing: AppSpacing.sm,
                                runSpacing: AppSpacing.sm,
                                alignment: WrapAlignment.center,
                                children: ReflectionMood.values.map((reflection) {
                                  final isSelected = _selectedReflection == reflection;
                                  return MeloChip(
                                    label: '${reflection.emoji} ${reflection.label}',
                                    isSelected: isSelected,
                                    onTap: () => _onSelectReflection(reflection),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxl),

                        // Done and Try Another CTAs
                        MeloSlideTransition(
                          delay: const Duration(milliseconds: 300),
                          child: Column(
                            children: [
                              MeloButton(
                                label: 'Done',
                                isFullWidth: true,
                                onPressed: () {
                                  context.go(AppRoutes.home);
                                },
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              MeloButton(
                                label: 'Try another reset',
                                variant: MeloButtonVariant.ghost,
                                isFullWidth: true,
                                onPressed: () {
                                  context.go(AppRoutes.explore);
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
