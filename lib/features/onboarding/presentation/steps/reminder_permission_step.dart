import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/animations/melo_fade_scale.dart';
import '../../../../shared/animations/melo_slide_transition.dart';
import '../../../../shared/widgets/melo_button.dart';
import '../../../../shared/widgets/melo_card.dart';

class ReminderPermissionStep extends StatelessWidget {
  const ReminderPermissionStep({
    super.key,
    required this.formattedTime,
    required this.onDecision,
  });

  final String formattedTime;
  final ValueChanged<bool> onDecision;

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
                          width: 84,
                          height: 84,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkPrimary.withOpacity(0.2)
                                : AppColors.secondarySurface,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.notifications_none_rounded,
                            size: 42,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      MeloSlideTransition(
                        delay: const Duration(milliseconds: 100),
                        child: Text(
                          'A gentle nudge when it\'s time',
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
                          'Would you like a supportive reminder around $formattedTime?',
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
                          child: Column(
                            children: [
                              _benefitRow(
                                icon: Icons.favorite_border_rounded,
                                title: 'Always supportive, never guilt-inducing',
                                description: 'No countdown timers, no streak shaming if you miss a day.',
                                isDark: isDark,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              _benefitRow(
                                icon: Icons.alarm_off_rounded,
                                title: 'You stay in complete control',
                                description: 'Easily adjust the time or turn off reminders in settings.',
                                isDark: isDark,
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
                          label: 'Enable reminders',
                          isFullWidth: true,
                          icon: Icons.notifications_active_rounded,
                          onPressed: () => onDecision(true),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        MeloButton(
                          label: 'Not now',
                          isFullWidth: true,
                          variant: MeloButtonVariant.ghost,
                          onPressed: () => onDecision(false),
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

  Widget _benefitRow({
    required IconData icon,
    required String title,
    required String description,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: isDark ? AppColors.darkPrimary : AppColors.primary,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.heading3.copyWith(
                  fontSize: 15,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.deepText,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: AppTypography.bodySmall.copyWith(
                  color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
