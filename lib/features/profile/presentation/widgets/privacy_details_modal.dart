import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/widgets/melo_button.dart';
import '../../../../shared/widgets/melo_icon_button.dart';
import '../../../../shared/widgets/melo_section_header.dart';

class PrivacyDetailsModal extends StatelessWidget {
  const PrivacyDetailsModal({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Privacy & Data Care', style: AppTypography.heading2),
              MeloIconButton(
                icon: Icons.close_rounded,
                tooltip: 'Close',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // 1. Local Data Philosophy
          _buildInfoSection(
            icon: Icons.lock_outline_rounded,
            title: '100% Local-First Storage',
            description:
                'Your practice history, before/after mood check-ins, favorite sessions, and gentle streak milestones are stored directly on your device. We do not sell your personal data or transmit sensitive mindfulness habits to remote servers.',
            isDark: isDark,
          ),
          const SizedBox(height: AppSpacing.md),

          // 2. Anonymous Diagnostics
          _buildInfoSection(
            icon: Icons.analytics_outlined,
            title: 'Anonymous Diagnostic Care',
            description:
                'If enabled, Melo collects basic anonymous operational statistics (such as fatal crashes or rendering errors) solely to ensure app stability. Zero personal identifiers, audio files, or notes are ever captured.',
            isDark: isDark,
          ),
          const SizedBox(height: AppSpacing.md),

          // 3. Notification Privacy
          _buildInfoSection(
            icon: Icons.notifications_none_rounded,
            title: 'Respectful Notifications',
            description:
                'Melo notifications are scheduled on-device without third-party push tracking. We never send commercial promotions, sales messages, or guilt-tripping nudges.',
            isDark: isDark,
          ),
          const SizedBox(height: AppSpacing.md),

          // 4. Wellness Disclaimer
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
                Row(
                  children: [
                    const Icon(
                      Icons.spa_outlined,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'Wellness Notice',
                      style: AppTypography.caption.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Melo is a mindfulness and relaxation companion. It is not clinical or diagnostic software and should not replace professional medical or mental health care.',
                  style: AppTypography.caption.copyWith(
                    color: isDark ? AppColors.darkMutedText : AppColors.mutedText,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          MeloButton(
            label: 'Understood',
            isFullWidth: true,
            variant: MeloButtonVariant.primary,
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }

  Widget _buildInfoSection({
    required IconData icon,
    required String title,
    required String description,
    required bool isDark,
  }) {
    return Container(
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
          Icon(icon, size: 22, color: AppColors.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.heading3.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark ? AppColors.darkMutedText : AppColors.mutedText,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
