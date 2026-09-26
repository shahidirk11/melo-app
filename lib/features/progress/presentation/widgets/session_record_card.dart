import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../data/models/session_record_model.dart';
import '../../../../shared/widgets/melo_badge.dart';
import '../../../../shared/widgets/melo_card.dart';

class SessionRecordCard extends StatelessWidget {
  const SessionRecordCard({
    super.key,
    required this.record,
    required this.onTap,
  });

  final SessionRecord record;
  final VoidCallback onTap;

  static String _formatTimeAgo(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final recordDate = DateTime(dt.year, dt.month, dt.day);
    final differenceDays = today.difference(recordDate).inDays;

    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final timeStr = '$hour:$minute $ampm';

    if (differenceDays == 0) {
      return 'Today, $timeStr';
    } else if (differenceDays == 1) {
      return 'Yesterday, $timeStr';
    } else {
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[dt.month - 1]} ${dt.day}, $timeStr';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MeloCard(
      padding: AppSpacing.cardPaddingCompact,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceHighlight
                  : AppColors.secondarySurface,
              borderRadius: AppSpacing.roundedSmall,
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.sessionTitle,
                  style: AppTypography.heading3,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${record.durationCompletedMinutes} min · ${_formatTimeAgo(record.completedAt)}',
                  style: AppTypography.caption.copyWith(
                    color: isDark ? AppColors.darkMutedText : AppColors.mutedText,
                  ),
                ),
                if (record.moodAfter != null) ...[
                  const SizedBox(height: 4),
                  MeloBadge(
                    label: '${record.moodAfter!.emoji} ${record.moodAfter!.label}',
                    variant: MeloBadgeVariant.surface,
                  ),
                ],
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: isDark ? AppColors.darkMutedText : AppColors.mutedText,
          ),
        ],
      ),
    );
  }
}
