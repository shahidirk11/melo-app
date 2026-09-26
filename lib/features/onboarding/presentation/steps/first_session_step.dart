import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/animations/melo_fade_scale.dart';
import '../../../../shared/animations/melo_slide_transition.dart';
import '../../../../shared/widgets/melo_badge.dart';
import '../../../../shared/widgets/melo_button.dart';
import '../../../../shared/widgets/melo_card.dart';

class FirstSessionStep extends StatelessWidget {
  const FirstSessionStep({
    super.key,
    required this.onStartFirstSession,
    required this.onSkipToHome,
  });

  final VoidCallback onStartFirstSession;
  final VoidCallback onSkipToHome;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
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
                  const SizedBox(height: AppSpacing.xl),
                  Column(
                    children: [
                      MeloFadeScale(
                        child: Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkPrimary.withOpacity(0.2)
                                : AppColors.secondarySurface,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text('🌿', style: TextStyle(fontSize: 42)),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      MeloSlideTransition(
                        delay: const Duration(milliseconds: 100),
                        child: Text(
                          'Ready for your first reset?',
                          style: AppTypography.heading1.copyWith(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.deepText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      MeloSlideTransition(
                        delay: const Duration(milliseconds: 150),
                        child: Text(
                          'A gentle 2-minute breath session to welcome you into this space.',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      MeloSlideTransition(
                        delay: const Duration(milliseconds: 200),
                        child: MeloCard(
                          style: MeloCardStyle.hero,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  MeloBadge(
                                    label: '2 min · Beginner',
                                    variant: MeloBadgeVariant.primary,
                                    icon: Icons.timer_outlined,
                                  ),
                                  SizedBox(width: AppSpacing.xs),
                                  MeloBadge(
                                    label: 'Calm',
                                    variant: MeloBadgeVariant.accent,
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                'First Breath Reset',
                                style: AppTypography.heading2.copyWith(
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.deepText,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Drop your shoulders, soften your gaze, and notice your natural rhythm.',
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
                  const SizedBox(height: AppSpacing.xl),
                  MeloSlideTransition(
                    delay: const Duration(milliseconds: 250),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MeloButton(
                          label: 'Start first session',
                          isFullWidth: true,
                          icon: Icons.play_arrow_rounded,
                          onPressed: onStartFirstSession,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        MeloButton(
                          label: 'Explore home first',
                          isFullWidth: true,
                          variant: MeloButtonVariant.ghost,
                          onPressed: onSkipToHome,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
