import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../data/models/reminder_model.dart';
import '../../../../shared/widgets/melo_badge.dart';
import '../../../../shared/widgets/melo_card.dart';

class ReminderCard extends StatelessWidget {
  const ReminderCard({
    super.key,
    required this.reminder,
    required this.isPaused,
    required this.onTap,
    required this.onToggle,
    required this.onSnooze,
  });

  final ReminderSchedule reminder;
  final bool isPaused;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggle;
  final VoidCallback onSnooze;

  IconData _getSlotIcon(ReminderSlot slot) {
    switch (slot) {
      case ReminderSlot.morning:
        return Icons.wb_sunny_outlined;
      case ReminderSlot.afternoon:
        return Icons.wb_cloudy_outlined;
      case ReminderSlot.evening:
        return Icons.bedtime_outlined;
      case ReminderSlot.custom:
        return Icons.spa_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEffectivelyActive = reminder.isEnabled && !isPaused;

    return MeloCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: isEffectivelyActive
                      ? AppColors.primary.withOpacity(0.12)
                      : (isDark
                          ? AppColors.darkSurfaceHighlight
                          : AppColors.secondarySurface),
                  borderRadius: AppSpacing.roundedSmall,
                ),
                child: Icon(
                  _getSlotIcon(reminder.slot),
                  color: isEffectivelyActive
                      ? AppColors.primary
                      : (isDark ? AppColors.darkMutedText : AppColors.mutedText),
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder.slot.title,
                      style: AppTypography.heading3,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          reminder.formattedTime,
                          style: AppTypography.bodySmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isEffectivelyActive
                                ? AppColors.primary
                                : (isDark ? AppColors.darkMutedText : AppColors.mutedText),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          '· ${reminder.daysDescription}',
                          style: AppTypography.caption.copyWith(
                            color: isDark ? AppColors.darkMutedText : AppColors.mutedText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: reminder.isEnabled,
                activeColor: AppColors.primary,
                onChanged: onToggle,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Supportive Message Snippet & Quick Snooze
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  reminder.notificationBody,
                  style: AppTypography.caption.copyWith(
                    fontStyle: FontStyle.italic,
                    color: isDark ? AppColors.darkMutedText : AppColors.mutedText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isEffectivelyActive) ...[
                const SizedBox(width: AppSpacing.sm),
                GestureDetector(
                  onTap: onSnooze,
                  child: const MeloBadge(
                    label: 'Snooze 15m',
                    variant: MeloBadgeVariant.outline,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
