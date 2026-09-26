import 'package:equatable/equatable.dart';
import '../../../data/models/reminder_model.dart';
import '../../../data/models/session_record_model.dart';

class ScheduleAdjustmentSuggestion extends Equatable {
  const ScheduleAdjustmentSuggestion({
    required this.reminderId,
    required this.reminderTitle,
    required this.currentFormattedTime,
    required this.suggestedHour,
    required this.suggestedMinute,
    required this.suggestedFormattedTime,
    required this.reason,
    required this.promptQuestion,
  });

  final String reminderId;
  final String reminderTitle;
  final String currentFormattedTime;
  final int suggestedHour;
  final int suggestedMinute;
  final String suggestedFormattedTime;
  final String reason;
  final String promptQuestion;

  @override
  List<Object?> get props => [
        reminderId,
        reminderTitle,
        currentFormattedTime,
        suggestedHour,
        suggestedMinute,
        suggestedFormattedTime,
        reason,
        promptQuestion,
      ];
}

abstract class ScheduleSuggestionService {
  static ScheduleAdjustmentSuggestion? analyzePracticeHabits({
    required List<ReminderSchedule> reminders,
    required List<SessionRecord> history,
  }) {
    final completed = history.where((r) => r.wasCompleted).toList();
    if (completed.length < 3) return null;

    // 1. Group completed sessions by hour of day
    final hourFrequencies = <int, int>{};
    for (final record in completed) {
      final hour = record.completedAt.hour;
      hourFrequencies[hour] = (hourFrequencies[hour] ?? 0) + 1;
    }

    // 2. Find the most frequent practice hour with at least 3 occurrences
    int? dominantHour;
    int maxCount = 0;
    for (final entry in hourFrequencies.entries) {
      if (entry.value >= 3 && entry.value > maxCount) {
        dominantHour = entry.key;
        maxCount = entry.value;
      }
    }

    if (dominantHour == null) return null;

    // 3. Find if any enabled reminder already matches this hour (within 1 hour)
    for (final reminder in reminders.where((r) => r.isEnabled)) {
      final hourDiff = (reminder.hour - dominantHour).abs();
      if (hourDiff <= 1) {
        // Already aligned
        return null;
      }
    }

    // 4. Find the closest reminder slot to adjust
    ReminderSchedule? candidateReminder;
    if (dominantHour >= 18) {
      // Evening
      candidateReminder = reminders.cast<ReminderSchedule?>().firstWhere(
            (r) => r?.slot == ReminderSlot.evening && r?.isEnabled == true,
            orElse: () => null,
          );
    } else if (dominantHour <= 11) {
      // Morning
      candidateReminder = reminders.cast<ReminderSchedule?>().firstWhere(
            (r) => r?.slot == ReminderSlot.morning && r?.isEnabled == true,
            orElse: () => null,
          );
    } else {
      // Afternoon
      candidateReminder = reminders.cast<ReminderSchedule?>().firstWhere(
            (r) => r?.slot == ReminderSlot.afternoon && r?.isEnabled == true,
            orElse: () => null,
          );
    }

    candidateReminder ??= reminders.cast<ReminderSchedule?>().firstWhere(
          (r) => r?.isEnabled == true,
          orElse: () => null,
        );

    if (candidateReminder == null) return null;

    final period = dominantHour >= 12 ? 'PM' : 'AM';
    final displayHour = dominantHour > 12
        ? dominantHour - 12
        : (dominantHour == 0 ? 12 : dominantHour);
    final suggestedTimeStr = '$displayHour:00 $period';

    return ScheduleAdjustmentSuggestion(
      reminderId: candidateReminder.id,
      reminderTitle: candidateReminder.slot.title,
      currentFormattedTime: candidateReminder.formattedTime,
      suggestedHour: dominantHour,
      suggestedMinute: 0,
      suggestedFormattedTime: suggestedTimeStr,
      reason: 'You frequently take mindful moments around $suggestedTimeStr.',
      promptQuestion:
          'Would you like to adjust your ${candidateReminder.slot.title} from ${candidateReminder.formattedTime} to $suggestedTimeStr to match your natural flow?',
    );
  }
}
