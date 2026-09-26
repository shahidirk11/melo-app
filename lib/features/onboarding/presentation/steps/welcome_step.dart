import 'package:flutter/material.dart';
import '../../../../app/config/app_config.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/animations/melo_fade_scale.dart';
import '../../../../shared/animations/melo_slide_transition.dart';
import '../../../../shared/widgets/melo_button.dart';

class WelcomeStep extends StatelessWidget {
  const WelcomeStep({
    super.key,
    required this.config,
    required this.onNext,
  });

  final AppConfig config;
  final VoidCallback onNext;

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
                        duration: const Duration(milliseconds: 500),
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
                            child: Icon(
                              Icons.spa_rounded,
                              size: 44,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      MeloSlideTransition(
                        delay: const Duration(milliseconds: 100),
                        child: Text(
                          config.appName,
                          style: AppTypography.display.copyWith(
                            fontSize: 36,
                            letterSpacing: -1.0,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.deepText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      MeloSlideTransition(
                        delay: const Duration(milliseconds: 150),
                        child: Text(
                          config.tagline,
                          style: AppTypography.body.copyWith(
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.mutedText,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      MeloSlideTransition(
                        delay: const Duration(milliseconds: 200),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: AppSpacing.md,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkSurface
                                : AppColors.cardSurface,
                            borderRadius: AppSpacing.roundedCard,
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : const Color(0xFFE5E9E1),
                            ),
                          ),
                          child: Text(
                            'Short, gentle moments for yourself throughout the day. '
                            'Calm your mind, breathe with ease, and return whenever you need a reset.',
                            style: AppTypography.bodySmall.copyWith(
                              height: 1.55,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.deepText,
                            ),
                            textAlign: TextAlign.center,
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
                          label: 'Get started',
                          isFullWidth: true,
                          icon: Icons.arrow_forward_rounded,
                          onPressed: onNext,
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
