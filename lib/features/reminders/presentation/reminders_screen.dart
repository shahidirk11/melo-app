import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../data/models/reminder_model.dart';
import '../../../shared/animations/melo_slide_transition.dart';
import '../../../shared/widgets/melo_app_bar.dart';
import '../../../shared/widgets/melo_bottom_sheet.dart';
import '../../../shared/widgets/melo_button.dart';
import '../../../shared/widgets/melo_card.dart';
import '../../../shared/widgets/melo_responsive_container.dart';
import '../../../shared/widgets/melo_section_header.dart';
import '../../../shared/widgets/melo_snackbar.dart';
import '../../../shared/widgets/state_views/loading_view.dart';
import 'reminders_provider.dart';
import 'widgets/edit_reminder_modal.dart';
import 'widgets/notification_permission_dialog.dart';
import 'widgets/reminder_card.dart';
import 'widgets/schedule_suggestion_card.dart';

class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key});

  void _openEditReminder(
    BuildContext context,
    WidgetRef ref,
    ReminderSchedule reminder,
  ) {
    final notifier = ref.read(remindersProvider.notifier);
    MeloBottomSheet.show(
      context,
      child: EditReminderModal(
        reminder: reminder,
        onSaveTime: (hour, minute) {
          notifier.updateReminderTime(reminder.id, hour, minute);
          MeloSnackbar.show(
            context,
            message: 'Reminder time updated.',
            type: MeloSnackbarType.info,
          );
        },
        onSaveDays: (days) {
          notifier.updateReminderDays(reminder.id, days);
        },
        onDelete: reminder.slot == ReminderSlot.custom
            ? () {
                notifier.deleteReminder(reminder.id);
                MeloSnackbar.show(
                  context,
                  message: 'Reminder removed.',
                  type: MeloSnackbarType.info,
                );
              }
            : null,
      ),
    );
  }

  void _showPermissionExplanation(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NotificationPermissionDialog(
        onEnable: () async {
          Navigator.of(context).pop();
          final granted =
              await ref.read(remindersProvider.notifier).requestPermission();
          if (context.mounted) {
            MeloSnackbar.show(
              context,
              message: granted
                  ? 'Reminders enabled. We will keep them gentle.'
                  : 'Notifications not enabled. You can update this in settings.',
              type: granted ? MeloSnackbarType.success : MeloSnackbarType.info,
            );
          }
        },
        onDismiss: () {
          Navigator.of(context).pop();
          ref.read(remindersProvider.notifier).dismissPermissionExplanation();
        },
      ),
    );
  }

  void _addCustomReminder(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(remindersProvider.notifier);
    final dummy = ReminderSchedule(
      id: 'custom_new',
      slot: ReminderSlot.custom,
      hour: 12,
      minute: 0,
      daysOfWeek: const [1, 2, 3, 4, 5],
    );

    MeloBottomSheet.show(
      context,
      child: EditReminderModal(
        reminder: dummy,
        onSaveTime: (hour, minute) {
          notifier.addCustomReminder(
            hour: hour,
            minute: minute,
            daysOfWeek: const [1, 2, 3, 4, 5],
          );
          MeloSnackbar.show(
            context,
            message: 'Custom reminder created.',
            type: MeloSnackbarType.success,
          );
        },
        onSaveDays: (days) {},
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(remindersProvider);
    final notifier = ref.read(remindersProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (state.isLoading && state.reminders.isEmpty) {
      return const Scaffold(
        body: SafeArea(
          child: LoadingView(message: 'Loading reminder schedules...'),
        ),
      );
    }

    return Scaffold(
      appBar: const MeloAppBar(title: 'Mindful Reminders'),
      body: SafeArea(
        child: MeloResponsiveContainer(
          child: ListView(
            padding: AppSpacing.screenPadding,
            children: [
              // 1. Permission Explanation Banner (if permission not yet granted)
              if (!state.hasNotificationPermission)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: MeloCard(
                    style: MeloCardStyle.hero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.notifications_active_outlined,
                              color: isDark ? AppColors.darkPrimary : AppColors.primary,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Reminders are currently off',
                              style: AppTypography.heading3.copyWith(
                                color: isDark ? AppColors.darkTextPrimary : AppColors.deepText,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Enable notifications to receive kind, supportive nudges on your schedule.',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        MeloButton(
                          label: 'Enable notifications',
                          variant: MeloButtonVariant.primary,
                          onPressed: () => _showPermissionExplanation(context, ref),
                        ),
                      ],
                    ),
                  ),
                ),

              // 2. Intelligent Schedule Suggestion (if habit detected)
              if (state.activeSuggestion != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: MeloSlideTransition(
                    delay: const Duration(milliseconds: 50),
                    child: ScheduleSuggestionCard(
                      suggestion: state.activeSuggestion!,
                      onAccept: () {
                        notifier.acceptSuggestion(state.activeSuggestion!);
                        MeloSnackbar.show(
                          context,
                          message: 'Schedule adjusted to your practice rhythm.',
                          type: MeloSnackbarType.success,
                        );
                      },
                      onDismiss: () => notifier.dismissSuggestion(),
                    ),
                  ),
                ),

              // 3. Global Pause All Toggle Card
              MeloSlideTransition(
                delay: const Duration(milliseconds: 100),
                child: MeloCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pause all reminders',
                              style: AppTypography.heading3.copyWith(
                                color: isDark ? AppColors.darkTextPrimary : AppColors.deepText,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              state.areAllPaused
                                  ? 'All reminders are temporarily silenced.'
                                  : 'Silence reminders whenever you need quiet space.',
                              style: AppTypography.caption.copyWith(
                                color: isDark
                                    ? AppColors.darkMutedText
                                    : AppColors.mutedText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch.adaptive(
                        value: state.areAllPaused,
                        activeColor: AppColors.primary,
                        onChanged: (_) => notifier.toggleAllPaused(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // 4. Reminders List
              MeloSlideTransition(
                delay: const Duration(milliseconds: 150),
                child: const MeloSectionHeader(
                  eyebrow: 'Schedules',
                  title: 'Daily & Weekly Resets',
                ),
              ),
              const SizedBox(height: AppSpacing.xs),

              ...state.reminders.map((reminder) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: ReminderCard(
                    reminder: reminder,
                    isPaused: state.areAllPaused,
                    onTap: () => _openEditReminder(context, ref, reminder),
                    onToggle: (enabled) {
                      if (enabled && !state.hasNotificationPermission) {
                        _showPermissionExplanation(context, ref);
                      }
                      notifier.toggleReminder(reminder.id, enabled);
                    },
                    onSnooze: () async {
                      await notifier.snoozeReminder(reminder.id, minutes: 15);
                      if (context.mounted) {
                        MeloSnackbar.show(
                          context,
                          message: 'Reminder snoozed for 15 minutes 🌿',
                          type: MeloSnackbarType.info,
                        );
                      }
                    },
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.md),

              // 5. Add Custom Reminder Button
              MeloButton(
                label: 'Add Custom Reminder',
                icon: Icons.add_rounded,
                variant: MeloButtonVariant.secondary,
                isFullWidth: true,
                onPressed: () => _addCustomReminder(context, ref),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // 6. Supportive Philosophy Note
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Text(
                    'Melo reminders are kind, respectful pauses.\nThey will never guilt-trip you or shame you for missing days.',
                    style: AppTypography.caption.copyWith(
                      color: isDark ? AppColors.darkMutedText : AppColors.mutedText,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
