import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/widgets/melo_button.dart';

class NotificationPermissionDialog extends StatelessWidget {
  const NotificationPermissionDialog({
    super.key,
    required this.onEnable,
    required this.onDismiss,
  });

  final VoidCallback onEnable;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: AppSpacing.screenPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkPrimary.withOpacity(0.25)
                        : AppColors.primaryLight.withOpacity(0.35),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('🌱', style: TextStyle(fontSize: 28)),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              Center(
                child: Text(
                  'Gentle reminders on your terms',
                  style: AppTypography.heading2.copyWith(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.deepText,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              Text(
                'Melo only sends kind, supportive reminders when you want them. Never pushy, never overwhelming.',
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark ? AppColors.darkMutedText : AppColors.mutedText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),

              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceHighlight
                      : AppColors.secondarySurface,
                  borderRadius: AppSpacing.roundedMedium,
                ),
                child: Column(
                  children: [
                    _buildBenefitRow(
                      icon: Icons.favorite_border_rounded,
                      title: 'Supportive & kind',
                      description: 'Zero guilt streaks or competitive pressure.',
                      isDark: isDark,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildBenefitRow(
                      icon: Icons.tune_rounded,
                      title: 'Your schedule',
                      description: 'Choose your preferred times and days of the week.',
                      isDark: isDark,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildBenefitRow(
                      icon: Icons.pause_circle_outline_rounded,
                      title: 'Easy to pause',
                      description: 'Silence or pause all reminders whenever you need space.',
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              MeloButton(
                label: 'Enable Reminders',
                isFullWidth: true,
                variant: MeloButtonVariant.primary,
                onPressed: onEnable,
              ),
              const SizedBox(height: AppSpacing.xs),
              MeloButton(
                label: 'Maybe Later',
                isFullWidth: true,
                variant: MeloButtonVariant.ghost,
                onPressed: onDismiss,
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitRow({
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
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkText : AppColors.deepText,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: AppTypography.caption.copyWith(
                  color: isDark ? AppColors.darkMutedText : AppColors.mutedText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
