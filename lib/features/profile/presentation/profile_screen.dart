import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/config/app_config.dart';
import '../../../app/providers.dart';
import '../../../app/router/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../data/models/user_preferences_model.dart';
import '../../../shared/animations/melo_slide_transition.dart';
import '../../../shared/widgets/melo_bottom_sheet.dart';
import '../../../shared/widgets/melo_button.dart';
import '../../../shared/widgets/melo_card.dart';
import '../../../shared/widgets/melo_dialog.dart';
import '../../../shared/widgets/melo_icon_button.dart';
import '../../../shared/widgets/melo_responsive_container.dart';
import '../../../shared/widgets/melo_section_header.dart';
import '../../../shared/widgets/melo_snackbar.dart';
import '../../progress/presentation/progress_provider.dart';
import 'widgets/about_melo_modal.dart';
import 'widgets/data_export_modal.dart';
import 'widgets/edit_duration_modal.dart';
import 'widgets/edit_goals_modal.dart';
import 'widgets/privacy_details_modal.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  String _formatDuration(int seconds) {
    if (seconds <= 180) return '1–3 min';
    if (seconds <= 300) return '5 min';
    if (seconds <= 600) return '10 min';
    return '15+ min';
  }

  void _openEditGoals(BuildContext context, WidgetRef ref, List<String> currentGoals) {
    MeloBottomSheet.show(
      context,
      child: EditGoalsModal(
        initialGoals: currentGoals,
        onSave: (newGoals) {
          ref.read(userPreferencesProvider.notifier).setGoals(newGoals);
          MeloSnackbar.show(context, message: 'Goals updated.');
        },
      ),
    );
  }

  void _openEditDuration(BuildContext context, WidgetRef ref, int currentSeconds) {
    MeloBottomSheet.show(
      context,
      child: EditDurationModal(
        initialDurationSeconds: currentSeconds,
        onSave: (newSeconds) {
          ref.read(userPreferencesProvider.notifier).setPreferredDuration(newSeconds);
          MeloSnackbar.show(context, message: 'Preferred duration updated.');
        },
      ),
    );
  }

  void _openPrivacyDetails(BuildContext context) {
    MeloBottomSheet.show(
      context,
      child: const PrivacyDetailsModal(),
    );
  }

  void _openAboutMelo(BuildContext context) {
    MeloBottomSheet.show(
      context,
      child: const AboutMeloModal(),
    );
  }

  void _openDataExport(BuildContext context) {
    MeloBottomSheet.show(
      context,
      child: const DataExportModal(),
    );
  }

  Future<void> _editName(
    BuildContext context,
    WidgetRef ref,
    String currentName,
  ) async {
    final controller = TextEditingController(text: currentName);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.roundedLarge,
        ),
        title: Text(
          'Your Name',
          style: AppTypography.heading2.copyWith(
            color: isDark ? AppColors.darkTextPrimary : AppColors.deepText,
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.deepText,
          ),
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'Enter your preferred name',
            hintStyle: TextStyle(
              color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
            ),
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (saved == true && context.mounted) {
      final newName = controller.text.trim();
      await ref.read(userPreferencesProvider.notifier).setFirstName(newName);
      if (context.mounted) {
        MeloSnackbar.show(context, message: 'Name updated.');
      }
    }
    controller.dispose();
  }

  Future<void> _handleClearData(BuildContext context, WidgetRef ref) async {
    final confirmed = await MeloDialog.show(
      context: context,
      title: 'Reset all app data?',
      content:
          'This will permanently reset your mindful goals, practice history, reminder times, and preferences on this device. This action cannot be undone.',
      primaryActionLabel: 'Reset Everything',
      secondaryActionLabel: 'Cancel',
      isDestructive: true,
    );

    if (confirmed == true && context.mounted) {
      await ref.read(userPreferencesProvider.notifier).resetToDefaults();
      await ref.read(appSettingsProvider.notifier).resetToDefaults();
      await ref.read(progressNotifierProvider.notifier).clearAllHistory();

      if (context.mounted) {
        MeloSnackbar.show(
          context,
          message: 'All local data and preferences have been reset.',
          type: MeloSnackbarType.info,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(userPreferencesProvider);
    final userNotifier = ref.read(userPreferencesProvider.notifier);
    final settings = ref.watch(appSettingsProvider);
    final settingsNotifier = ref.read(appSettingsProvider.notifier);
    final progress = ref.watch(progressNotifierProvider);
    final config = ref.watch(configProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final displayName =
        prefs.firstName.trim().isNotEmpty ? prefs.firstName.trim() : 'Mindful Practicioner';

    return Scaffold(
      body: SafeArea(
        child: MeloResponsiveContainer(
          child: ListView(
            padding: AppSpacing.screenPadding,
            children: [
              // 1. Screen Header
              MeloSlideTransition(
                delay: const Duration(milliseconds: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Settings',
                      style: AppTypography.display.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.deepText,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      'Customize your personal reset environment',
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 2. Profile Summary Card
              MeloSlideTransition(
                delay: const Duration(milliseconds: 80),
                child: MeloCard(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkPrimary.withOpacity(0.2)
                              : AppColors.primaryLight.withOpacity(0.35),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.spa_rounded,
                            color: AppColors.primary,
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    displayName,
                                    style: AppTypography.heading3.copyWith(
                                      color: isDark
                                          ? AppColors.darkTextPrimary
                                          : AppColors.deepText,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                MeloIconButton(
                                  icon: Icons.edit_outlined,
                                  size: 16,
                                  tooltip: 'Edit name',
                                  onPressed: () =>
                                      _editName(context, ref, prefs.firstName),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${progress.summary.totalSessions} mindful resets · ${progress.summary.totalMinutes}m quiet time',
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
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // 3. Mindfulness Preferences Section
              MeloSlideTransition(
                delay: const Duration(milliseconds: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MeloSectionHeader(
                      eyebrow: 'Practice',
                      title: 'Preferences',
                    ),
                    MeloCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(
                              Icons.flag_outlined,
                              color: AppColors.primary,
                            ),
                            title: const Text('Mindful Goals'),
                            subtitle: Text(
                              prefs.goals.isEmpty
                                  ? 'Set your intentions'
                                  : prefs.goals.join(', '),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: const Icon(
                              Icons.chevron_right_rounded,
                              size: 20,
                            ),
                            onTap: () =>
                                _openEditGoals(context, ref, prefs.goals),
                          ),
                          const Divider(height: 1),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(
                              Icons.timer_outlined,
                              color: AppColors.primary,
                            ),
                            title: const Text('Preferred Session Length'),
                            subtitle: Text(
                              _formatDuration(prefs.preferredDurationSeconds),
                            ),
                            trailing: const Icon(
                              Icons.chevron_right_rounded,
                              size: 20,
                            ),
                            onTap: () => _openEditDuration(
                              context,
                              ref,
                              prefs.preferredDurationSeconds,
                            ),
                          ),
                          const Divider(height: 1),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(
                              Icons.notifications_active_outlined,
                              color: AppColors.primary,
                            ),
                            title: const Text('Reminder Schedule'),
                            subtitle: Text(
                              prefs.notificationsEnabled
                                  ? 'Configured daily reminders'
                                  : 'Not scheduled',
                            ),
                            trailing: const Icon(
                              Icons.chevron_right_rounded,
                              size: 20,
                            ),
                            onTap: () =>
                                context.push(AppRoutes.profileReminders),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // 4. Audio Settings Section
              MeloSlideTransition(
                delay: const Duration(milliseconds: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MeloSectionHeader(
                      eyebrow: 'Sound',
                      title: 'Audio Settings',
                    ),
                    MeloCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      child: Column(
                        children: [
                          SwitchListTile.adaptive(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Background audio playback'),
                            subtitle: const Text(
                              'Continue guidance when screen is turned off',
                            ),
                            value: settings.backgroundAudioEnabled,
                            activeColor: isDark
                                ? AppColors.darkPrimary
                                : AppColors.primary,
                            onChanged: (val) {
                              settingsNotifier.setBackgroundAudio(val);
                            },
                          ),
                          const Divider(height: 1),
                          SwitchListTile.adaptive(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Offline audio caching'),
                            subtitle: const Text(
                              'Store practice audio locally for reliable offline sessions',
                            ),
                            value: settings.offlineAudioCached,
                            activeColor: isDark
                                ? AppColors.darkPrimary
                                : AppColors.primary,
                            onChanged: (val) {
                              settingsNotifier.setOfflineAudioCached(val);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // 5. Appearance Section
              MeloSlideTransition(
                delay: const Duration(milliseconds: 140),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MeloSectionHeader(
                      eyebrow: 'Appearance',
                      title: 'Theme',
                    ),
                    MeloCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.xs,
                      ),
                      child: Column(
                        children: [
                          RadioListTile<AppThemePreference>(
                            title: const Text('System default'),
                            value: AppThemePreference.system,
                            groupValue: prefs.themeMode,
                            activeColor: isDark
                                ? AppColors.darkPrimary
                                : AppColors.primary,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (val) {
                              if (val != null) {
                                userNotifier.setTheme(val);
                                MeloSnackbar.show(
                                  context,
                                  message: 'Theme preference updated.',
                                );
                              }
                            },
                          ),
                          const Divider(height: 1),
                          RadioListTile<AppThemePreference>(
                            title: const Text('Light'),
                            value: AppThemePreference.light,
                            groupValue: prefs.themeMode,
                            activeColor: isDark
                                ? AppColors.darkPrimary
                                : AppColors.primary,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (val) {
                              if (val != null) {
                                userNotifier.setTheme(val);
                                MeloSnackbar.show(
                                  context,
                                  message: 'Switched to Light theme.',
                                );
                              }
                            },
                          ),
                          const Divider(height: 1),
                          RadioListTile<AppThemePreference>(
                            title: const Text('Dark'),
                            value: AppThemePreference.dark,
                            groupValue: prefs.themeMode,
                            activeColor: isDark
                                ? AppColors.darkPrimary
                                : AppColors.primary,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (val) {
                              if (val != null) {
                                userNotifier.setTheme(val);
                                MeloSnackbar.show(
                                  context,
                                  message: 'Switched to Dark theme.',
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // 6. Accessibility & Senses Section
              MeloSlideTransition(
                delay: const Duration(milliseconds: 160),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MeloSectionHeader(
                      eyebrow: 'Comfort',
                      title: 'Accessibility & Senses',
                    ),
                    MeloCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm,
                      ),
                      child: Column(
                        children: [
                          SwitchListTile.adaptive(
                            title: const Text('Reduced motion'),
                            subtitle: const Text(
                              'Minimize scale and movement transitions',
                            ),
                            value: prefs.reducedMotion,
                            activeColor: isDark
                                ? AppColors.darkPrimary
                                : AppColors.primary,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (val) {
                              userNotifier.setReducedMotion(val);
                              MeloSnackbar.show(
                                context,
                                message: val
                                    ? 'Reduced motion enabled.'
                                    : 'Reduced motion disabled.',
                              );
                            },
                          ),
                          const Divider(height: 1),
                          SwitchListTile.adaptive(
                            title: const Text('Gentle haptics'),
                            subtitle: const Text(
                              'Subtle tactile feedback on tap and completion',
                            ),
                            value: prefs.hapticsEnabled,
                            activeColor: isDark
                                ? AppColors.darkPrimary
                                : AppColors.primary,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (val) => userNotifier.setHaptics(val),
                          ),
                          const Divider(height: 1),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.sm,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.text_fields_rounded,
                                  size: 20,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Text Scaling Compatible',
                                        style: AppTypography.bodyMedium
                                            .copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'Melo automatically adapts typography to your system display and text accessibility scale.',
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
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // 7. Privacy & Care Section
              MeloSlideTransition(
                delay: const Duration(milliseconds: 180),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MeloSectionHeader(
                      eyebrow: 'Trust',
                      title: 'Privacy & Data Care',
                    ),
                    MeloCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(
                              Icons.lock_outline_rounded,
                              color: AppColors.primary,
                            ),
                            title: const Text('100% Local-First Storage'),
                            subtitle: const Text(
                              'All mindful records stay on your personal device.',
                            ),
                            trailing: const Icon(
                              Icons.info_outline_rounded,
                              size: 20,
                            ),
                            onTap: () => _openPrivacyDetails(context),
                          ),
                          const Divider(height: 1),
                          SwitchListTile.adaptive(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Anonymous diagnostics'),
                            subtitle: const Text(
                              'Help improve stability with non-identifiable telemetry',
                            ),
                            value: settings.analyticsOptIn,
                            activeColor: isDark
                                ? AppColors.darkPrimary
                                : AppColors.primary,
                            onChanged: (val) {
                              settingsNotifier.setAnalyticsOptIn(val);
                            },
                          ),
                          const Divider(height: 1),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(
                              Icons.article_outlined,
                              color: AppColors.primary,
                            ),
                            title: const Text('Privacy & Wellness Details'),
                            trailing: const Icon(
                              Icons.chevron_right_rounded,
                              size: 20,
                            ),
                            onTap: () => _openPrivacyDetails(context),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    // Wellness Disclaimer Card
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurfaceHighlight
                            : AppColors.secondarySurface,
                        borderRadius: AppSpacing.roundedMedium,
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.subtleBorder,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.spa_outlined,
                            size: 18,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              config.wellnessDisclaimer,
                              style: AppTypography.caption.copyWith(
                                color: isDark
                                    ? AppColors.darkMutedText
                                    : AppColors.mutedText,
                                height: 1.45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // 8. Data Management Section
              MeloSlideTransition(
                delay: const Duration(milliseconds: 200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MeloSectionHeader(
                      eyebrow: 'Storage',
                      title: 'Data Management',
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: MeloButton(
                            label: 'Export Data',
                            icon: Icons.file_download_outlined,
                            variant: MeloButtonVariant.secondary,
                            onPressed: () => _openDataExport(context),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: MeloButton(
                            label: 'Clear Data',
                            icon: Icons.delete_outline_rounded,
                            variant: MeloButtonVariant.secondary,
                            onPressed: () => _handleClearData(context, ref),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // 9. About Section
              MeloSlideTransition(
                delay: const Duration(milliseconds: 220),
                child: Column(
                  children: [
                    MeloButton(
                      label: 'About Melo & Open Source Licenses',
                      icon: Icons.info_outline_rounded,
                      variant: MeloButtonVariant.secondary,
                      isFullWidth: true,
                      onPressed: () => _openAboutMelo(context),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Center(
                      child: Text(
                        '${config.appName} v1.0.0 · ${config.tagline}',
                        style: AppTypography.caption.copyWith(
                          color: isDark
                              ? AppColors.darkMutedText
                              : AppColors.mutedText,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
