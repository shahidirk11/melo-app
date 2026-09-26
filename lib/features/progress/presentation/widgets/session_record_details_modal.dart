import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../data/models/session_record_model.dart';
import '../../../../shared/widgets/melo_badge.dart';
import '../../../../shared/widgets/melo_button.dart';
import '../../../../shared/widgets/melo_dialog.dart';
import '../../../../shared/widgets/melo_icon_button.dart';

class SessionRecordDetailsModal extends StatelessWidget {
  const SessionRecordDetailsModal({
    super.key,
    required this.record,
    required this.onDelete,
  });

  final SessionRecord record;
  final VoidCallback onDelete;

  String _formatDateTime(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final month = months[dt.month - 1];
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$month ${dt.day}, ${dt.year} at $hour:$minute $ampm';
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await MeloDialog.show(
      context: context,
      title: 'Remove practice record?',
      content: 'This practice session will be removed from your history.',
      primaryActionLabel: 'Remove',
      isDestructive: true,
    );
    if (confirmed == true && context.mounted) {
      Navigator.of(context).pop(); // close details modal
      onDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Badge and Close
          Row(
            children: [
              MeloBadge(
                label: record.sessionType.displayName,
                variant: MeloBadgeVariant.primary,
              ),
              const Spacer(),
              MeloIconButton(
                icon: Icons.delete_outline_rounded,
                tooltip: 'Delete record',
                color: isDark ? AppColors.darkMutedText : AppColors.mutedText,
                onPressed: () => _confirmDelete(context),
              ),
              MeloIconButton(
                icon: Icons.close_rounded,
                tooltip: 'Close details',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Title
          Text(record.sessionTitle, style: AppTypography.heading1),
          const SizedBox(height: AppSpacing.xs),

          // Date & Time
          Text(
            _formatDateTime(record.completedAt),
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.darkMutedText : AppColors.mutedText,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Metrics Container
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Duration', style: AppTypography.bodySmall),
                    Text(
                      '${record.durationCompletedMinutes} min (${record.durationCompletedSeconds}s)',
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Divider(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Completion status', style: AppTypography.bodySmall),
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          record.wasCompleted ? 'Completed' : 'Left early',
                          style: AppTypography.bodySmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (record.moodBefore != null) ...[
                  const Divider(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Check-in before', style: AppTypography.bodySmall),
                      Text(
                        '${record.moodBefore!.emoji} ${record.moodBefore!.label}',
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
                if (record.moodAfter != null) ...[
                  const Divider(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Reflection after', style: AppTypography.bodySmall),
                      Text(
                        '${record.moodAfter!.emoji} ${record.moodAfter!.label}',
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          MeloButton(
            label: 'Close',
            isFullWidth: true,
            variant: MeloButtonVariant.secondary,
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}
