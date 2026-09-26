import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/config/app_config.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/widgets/melo_button.dart';
import '../../../../shared/widgets/melo_card.dart';
import '../../../../shared/widgets/melo_icon_button.dart';
import '../../../../shared/widgets/melo_snackbar.dart';

class AboutMeloModal extends ConsumerWidget {
  const AboutMeloModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(configProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('About Melo', style: AppTypography.heading2),
              MeloIconButton(
                icon: Icons.close_rounded,
                tooltip: 'Close',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // App Identity Hero
          Center(
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkPrimary.withOpacity(0.18)
                        : AppColors.primaryLight.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.spa_rounded,
                      size: 38,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  config.appName,
                  style: AppTypography.heading1.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Version 1.0.0 (Build 1)',
                  style: AppTypography.caption.copyWith(
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.mutedText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  config.tagline,
                  style: AppTypography.bodySmall.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Philosophy / About Melo
          MeloCard(
            style: MeloCardStyle.subtle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.favorite_outline_rounded,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'Our Philosophy',
                      style: AppTypography.heading3,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Melo is crafted as an unhurried, gentle sanctuary in your pocket. No streaks designed to guilt you, no gamified badges, and no noisy demands on your attention. Just grounded pauses, mindful breathing, and quiet moments to return to yourself whenever you need.',
                  style: AppTypography.bodySmall.copyWith(height: 1.55),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Core Principles
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceHighlight
                  : AppColors.secondarySurface,
              borderRadius: AppSpacing.roundedMedium,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPrincipleRow(
                  icon: Icons.shield_outlined,
                  title: 'Private & Local-First',
                  subtitle: 'Your mindful moments stay strictly on your device.',
                  isDark: isDark,
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildPrincipleRow(
                  icon: Icons.notifications_off_outlined,
                  title: 'Non-Intrusive Care',
                  subtitle: 'Supportive nudges that encourage, never guilt.',
                  isDark: isDark,
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildPrincipleRow(
                  icon: Icons.timer_outlined,
                  title: 'Adaptive Practices',
                  subtitle: 'Short 1-minute resets to deep 15-minute wind-downs.',
                  isDark: isDark,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Support Section
          Text('Support & Feedback', style: AppTypography.heading3),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            'We welcome your thoughts, questions, or ideas for mindful improvements.',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          InkWell(
            onTap: () {
              Clipboard.setData(const ClipboardData(text: 'support@meloapp.com'));
              MeloSnackbar.show(
                context,
                message: 'Support email copied to clipboard.',
              );
            },
            borderRadius: AppSpacing.roundedMedium,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isDark
                      ? AppColors.darkBorder
                      : AppColors.subtleBorder,
                ),
                borderRadius: AppSpacing.roundedMedium,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.email_outlined,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'support@meloapp.com',
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.deepText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    'Copy',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Open Source Licenses
          MeloButton(
            label: 'View Open Source Licenses',
            isFullWidth: true,
            variant: MeloButtonVariant.secondary,
            icon: Icons.article_outlined,
            onPressed: () {
              showLicensePage(
                context: context,
                applicationName: 'Melo',
                applicationVersion: '1.0.0',
                applicationLegalese: 'Crafted with care for mindful presence. '
                    'All open source licenses apply to their respective libraries.',
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }

  Widget _buildPrincipleRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.primary,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.deepText,
                ),
              ),
              Text(
                subtitle,
                style: AppTypography.caption.copyWith(
                  color: isDark
                      ? AppColors.darkMutedText
                      : AppColors.mutedText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
