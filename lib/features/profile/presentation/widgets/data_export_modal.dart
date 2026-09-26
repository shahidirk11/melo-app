import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/widgets/melo_button.dart';
import '../../../../shared/widgets/melo_card.dart';
import '../../../../shared/widgets/melo_icon_button.dart';
import '../../../../shared/widgets/melo_snackbar.dart';
import '../../../progress/presentation/progress_provider.dart';

class DataExportModal extends ConsumerWidget {
  const DataExportModal({super.key});

  Map<String, dynamic> _buildExportPayload(WidgetRef ref) {
    final prefs = ref.read(userPreferencesProvider);
    final settings = ref.read(appSettingsProvider);
    final progress = ref.read(progressNotifierProvider);

    return {
      'melo_export_version': '1.0',
      'exported_at': DateTime.now().toIso8601String(),
      'preferences': {
        'firstName': prefs.firstName,
        'goals': prefs.goals,
        'preferredDurationSeconds': prefs.preferredDurationSeconds,
        'preferredTimeOfDay': prefs.preferredTimeOfDay.name,
        'customReminderHour': prefs.customReminderHour,
        'customReminderMinute': prefs.customReminderMinute,
        'notificationsEnabled': prefs.notificationsEnabled,
        'themeMode': prefs.themeMode.name,
        'reducedMotion': prefs.reducedMotion,
        'hapticsEnabled': prefs.hapticsEnabled,
      },
      'settings': {
        'backgroundAudioEnabled': settings.backgroundAudioEnabled,
        'offlineAudioCached': settings.offlineAudioCached,
        'analyticsOptIn': settings.analyticsOptIn,
      },
      'practice_summary': {
        'totalSessions': progress.summary.totalSessions,
        'totalMinutes': progress.summary.totalMinutes,
        'activeDays': progress.summary.activeDays,
        'gentleStreakDays': progress.summary.gentleStreakDays,
      },
      'history_records': progress.history.map((r) => {
        'id': r.id,
        'sessionId': r.sessionId,
        'sessionTitle': r.sessionTitle,
        'durationSeconds': r.durationSeconds,
        'completedAt': r.completedAt.toIso8601String(),
        'preMood': r.preMood,
        'postMood': r.postMood,
        'rating': r.rating,
      }).toList(),
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final exportData = _buildExportPayload(ref);
    final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);
    final progress = ref.watch(progressNotifierProvider);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Export Your Data', style: AppTypography.heading2),
              MeloIconButton(
                icon: Icons.close_rounded,
                tooltip: 'Close',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Your mindfulness records belong solely to you. You can export your full configuration and practice history as readable JSON data.',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),

          // Overview stats
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceHighlight
                  : AppColors.secondarySurface,
              borderRadius: AppSpacing.roundedMedium,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  '${progress.summary.totalSessions}',
                  'Sessions',
                  isDark,
                ),
                _buildStatItem(
                  '${progress.summary.totalMinutes}m',
                  'Mindful Time',
                  isDark,
                ),
                _buildStatItem(
                  '${progress.summary.activeDays}',
                  'Active Days',
                  isDark,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // JSON Preview Box
          Container(
            height: 180,
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF141A17) : const Color(0xFFF1F5F2),
              borderRadius: AppSpacing.roundedMedium,
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.subtleBorder,
              ),
            ),
            child: SingleChildScrollView(
              child: SelectableText(
                jsonString,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Copy Action
          MeloButton(
            label: 'Copy JSON to Clipboard',
            icon: Icons.copy_rounded,
            isFullWidth: true,
            variant: MeloButtonVariant.primary,
            onPressed: () {
              Clipboard.setData(ClipboardData(text: jsonString));
              MeloSnackbar.show(
                context,
                message: 'Practice data copied to clipboard.',
              );
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, bool isDark) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.heading3.copyWith(
            color: isDark ? AppColors.darkTextPrimary : AppColors.deepText,
          ),
        ),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: isDark ? AppColors.darkMutedText : AppColors.mutedText,
          ),
        ),
      ],
    );
  }
}
