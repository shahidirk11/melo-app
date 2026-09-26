import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../core/services/notification_service.dart';
import '../../../data/models/reminder_model.dart';
import '../../../data/repositories/progress_repository.dart';
import '../../../data/repositories/reminder_repository.dart';
import '../domain/schedule_suggestion_service.dart';

class RemindersViewState extends Equatable {
  const RemindersViewState({
    this.isLoading = false,
    this.reminders = const [],
    this.areAllPaused = false,
    this.hasNotificationPermission = false,
    this.activeSuggestion,
    this.needsPermissionExplanation = false,
    this.errorMessage,
  });

  final bool isLoading;
  final List<ReminderSchedule> reminders;
  final bool areAllPaused;
  final bool hasNotificationPermission;
  final ScheduleAdjustmentSuggestion? activeSuggestion;
  final bool needsPermissionExplanation;
  final String? errorMessage;

  RemindersViewState copyWith({
    bool? isLoading,
    List<ReminderSchedule>? reminders,
    bool? areAllPaused,
    bool? hasNotificationPermission,
    ScheduleAdjustmentSuggestion? Function()? activeSuggestion,
    bool? needsPermissionExplanation,
    String? errorMessage,
  }) {
    return RemindersViewState(
      isLoading: isLoading ?? this.isLoading,
      reminders: reminders ?? this.reminders,
      areAllPaused: areAllPaused ?? this.areAllPaused,
      hasNotificationPermission:
          hasNotificationPermission ?? this.hasNotificationPermission,
      activeSuggestion:
          activeSuggestion != null ? activeSuggestion() : this.activeSuggestion,
      needsPermissionExplanation:
          needsPermissionExplanation ?? this.needsPermissionExplanation,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        reminders,
        areAllPaused,
        hasNotificationPermission,
        activeSuggestion,
        needsPermissionExplanation,
        errorMessage,
      ];
}

class RemindersNotifier extends StateNotifier<RemindersViewState> {
  RemindersNotifier({
    required this.reminderRepository,
    required this.notificationService,
    required this.progressRepository,
  }) : super(const RemindersViewState()) {
    load();
  }

  final ReminderRepository reminderRepository;
  final NotificationService notificationService;
  final ProgressRepository progressRepository;

  Future<void> load() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final reminders = await reminderRepository.getReminders();
      final allPaused = await reminderRepository.areAllPaused();
      final hasPermission = await notificationService.isPermissionGranted();
      final history = await progressRepository.getHistory(limit: 50);

      // Check practice habits for gentle schedule adjustment suggestions
      final suggestion = ScheduleSuggestionService.analyzePracticeHabits(
        reminders: reminders,
        history: history,
      );

      // Reschedule active reminders if not paused and permission granted
      if (!allPaused && hasPermission) {
        for (final r in reminders.where((r) => r.isEnabled)) {
          await notificationService.scheduleReminder(r);
        }
      }

      state = state.copyWith(
        isLoading: false,
        reminders: reminders,
        areAllPaused: allPaused,
        hasNotificationPermission: hasPermission,
        activeSuggestion: () => suggestion,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to load reminder settings.',
      );
    }
  }

  Future<bool> requestPermission() async {
    final granted = await notificationService.requestPermission();
    state = state.copyWith(
      hasNotificationPermission: granted,
      needsPermissionExplanation: false,
    );

    if (granted && !state.areAllPaused) {
      for (final r in state.reminders.where((r) => r.isEnabled)) {
        await notificationService.scheduleReminder(r);
      }
    }
    return granted;
  }

  void dismissPermissionExplanation() {
    state = state.copyWith(needsPermissionExplanation: false);
  }

  Future<void> toggleReminder(String id, bool isEnabled) async {
    // If user is enabling a reminder but hasn't granted permission yet
    if (isEnabled && !state.hasNotificationPermission) {
      state = state.copyWith(needsPermissionExplanation: true);
    }

    await reminderRepository.toggleReminder(id, isEnabled);
    final updatedList = await reminderRepository.getReminders();
    final updatedReminder = updatedList.firstWhere((r) => r.id == id);

    if (isEnabled && !state.areAllPaused) {
      await notificationService.scheduleReminder(updatedReminder);
    } else {
      await notificationService.cancelReminder(id);
    }

    state = state.copyWith(reminders: updatedList);
  }

  Future<void> updateReminderTime(String id, int hour, int minute) async {
    final existing = await reminderRepository.getReminderById(id);
    if (existing == null) return;

    final updated = existing.copyWith(hour: hour, minute: minute);
    await reminderRepository.saveReminder(updated);
    final updatedList = await reminderRepository.getReminders();

    if (updated.isEnabled && !state.areAllPaused) {
      await notificationService.scheduleReminder(updated);
    }

    state = state.copyWith(reminders: updatedList);
  }

  Future<void> updateReminderDays(String id, List<int> days) async {
    final existing = await reminderRepository.getReminderById(id);
    if (existing == null) return;

    final updated = existing.copyWith(daysOfWeek: days);
    await reminderRepository.saveReminder(updated);
    final updatedList = await reminderRepository.getReminders();

    if (updated.isEnabled && !state.areAllPaused) {
      await notificationService.scheduleReminder(updated);
    }

    state = state.copyWith(reminders: updatedList);
  }

  Future<void> toggleAllPaused() async {
    final newPaused = !state.areAllPaused;
    await reminderRepository.setAllPaused(newPaused);

    if (newPaused) {
      // Pause all: cancel active notifications in system
      await notificationService.cancelAll();
    } else {
      // Unpause all: reschedule enabled reminders
      for (final r in state.reminders.where((r) => r.isEnabled)) {
        await notificationService.scheduleReminder(r);
      }
    }

    state = state.copyWith(areAllPaused: newPaused);
  }

  Future<void> snoozeReminder(String id, {int minutes = 15}) async {
    final reminder = await reminderRepository.getReminderById(id);
    if (reminder != null) {
      await notificationService.snoozeReminder(reminder: reminder, minutes: minutes);
    }
  }

  Future<void> acceptSuggestion(ScheduleAdjustmentSuggestion suggestion) async {
    final existing = await reminderRepository.getReminderById(suggestion.reminderId);
    if (existing == null) return;

    final updated = existing.copyWith(
      hour: suggestion.suggestedHour,
      minute: suggestion.suggestedMinute,
    );
    await reminderRepository.saveReminder(updated);
    final updatedList = await reminderRepository.getReminders();

    if (updated.isEnabled && !state.areAllPaused) {
      await notificationService.scheduleReminder(updated);
    }

    state = state.copyWith(
      reminders: updatedList,
      activeSuggestion: () => null,
    );
  }

  void dismissSuggestion() {
    state = state.copyWith(activeSuggestion: () => null);
  }

  Future<void> addCustomReminder({
    required int hour,
    required int minute,
    required List<int> daysOfWeek,
    String? customMessage,
    String? deepLinkPayload,
  }) async {
    final newReminder = ReminderSchedule(
      id: 'reminder_custom_${DateTime.now().millisecondsSinceEpoch}',
      slot: ReminderSlot.custom,
      hour: hour,
      minute: minute,
      daysOfWeek: daysOfWeek,
      isEnabled: true,
      customMessage: customMessage,
      deepLinkPayload: deepLinkPayload ?? '/home',
    );

    await reminderRepository.saveReminder(newReminder);
    final updatedList = await reminderRepository.getReminders();

    if (!state.areAllPaused) {
      await notificationService.scheduleReminder(newReminder);
    }

    state = state.copyWith(reminders: updatedList);
  }

  Future<void> deleteReminder(String id) async {
    await reminderRepository.deleteReminder(id);
    await notificationService.cancelReminder(id);
    final updatedList = await reminderRepository.getReminders();
    state = state.copyWith(reminders: updatedList);
  }
}

final remindersProvider =
    StateNotifierProvider<RemindersNotifier, RemindersViewState>((ref) {
  final reminderRepo = ref.watch(reminderRepositoryProvider);
  final notificationService = ref.watch(notificationServiceProvider);
  final progressRepo = ref.watch(progressRepositoryProvider);

  return RemindersNotifier(
    reminderRepository: reminderRepo,
    notificationService: notificationService,
    progressRepository: progressRepo,
  );
});
