import 'package:equatable/equatable.dart';

enum ReminderSlot {
  morning('Morning Reset', 8, 30),
  afternoon('Afternoon Pause', 14, 0),
  evening('Evening Wind-Down', 20, 30),
  custom('Mindful Pause', 12, 0);

  const ReminderSlot(this.title, this.defaultHour, this.defaultMinute);
  final String title;
  final int defaultHour;
  final int defaultMinute;
}

class ReminderSchedule extends Equatable {
  const ReminderSchedule({
    required this.id,
    required this.slot,
    required this.hour,
    required this.minute,
    required this.daysOfWeek,
    this.isEnabled = true,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.customMessage,
    this.deepLinkPayload,
  });

  final String id;
  final ReminderSlot slot;
  final int hour;
  final int minute;
  final List<int> daysOfWeek; // 1 = Mon ... 7 = Sun
  final bool isEnabled;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final String? customMessage;
  final String? deepLinkPayload;

  String get formattedTime {
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final displayMinute = minute.toString().padLeft(2, '0');
    return '$displayHour:$displayMinute $period';
  }

  bool get isEveryday =>
      daysOfWeek.length == 7 &&
      daysOfWeek.toSet().containsAll([1, 2, 3, 4, 5, 6, 7]);

  bool get isWeekdaysOnly =>
      daysOfWeek.length == 5 &&
      daysOfWeek.toSet().containsAll([1, 2, 3, 4, 5]);

  bool get isWeekendsOnly =>
      daysOfWeek.length == 2 &&
      daysOfWeek.toSet().containsAll([6, 7]);

  String get daysDescription {
    if (daysOfWeek.isEmpty) return 'No days selected';
    if (isEveryday) return 'Every day';
    if (isWeekdaysOnly) return 'Weekdays';
    if (isWeekendsOnly) return 'Weekends';

    const dayNames = {
      1: 'Mon',
      2: 'Tue',
      3: 'Wed',
      4: 'Thu',
      5: 'Fri',
      6: 'Sat',
      7: 'Sun',
    };
    final sorted = List<int>.from(daysOfWeek)..sort();
    return sorted.map((d) => dayNames[d] ?? '').where((s) => s.isNotEmpty).join(', ');
  }

  String get notificationTitle {
    switch (slot) {
      case ReminderSlot.morning:
        return 'Good morning 🌱';
      case ReminderSlot.afternoon:
        return 'Afternoon pause ☁️';
      case ReminderSlot.evening:
        return 'Evening wind-down 🌙';
      case ReminderSlot.custom:
        return 'Mindful pause 🌿';
    }
  }

  String get notificationBody {
    if (customMessage != null && customMessage!.trim().isNotEmpty) {
      return customMessage!.trim();
    }
    switch (slot) {
      case ReminderSlot.morning:
        return 'A small reset might feel good right now.';
      case ReminderSlot.afternoon:
        return 'Take a few minutes for yourself.';
      case ReminderSlot.evening:
        return 'Ready for your evening wind-down?';
      case ReminderSlot.custom:
        return 'Whenever you are ready, take a quiet breath.';
    }
  }

  ReminderSchedule copyWith({
    String? id,
    ReminderSlot? slot,
    int? hour,
    int? minute,
    List<int>? daysOfWeek,
    bool? isEnabled,
    bool? soundEnabled,
    bool? vibrationEnabled,
    String? customMessage,
    String? deepLinkPayload,
  }) {
    return ReminderSchedule(
      id: id ?? this.id,
      slot: slot ?? this.slot,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      isEnabled: isEnabled ?? this.isEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      customMessage: customMessage ?? this.customMessage,
      deepLinkPayload: deepLinkPayload ?? this.deepLinkPayload,
    );
  }

  @override
  List<Object?> get props => [
        id,
        slot,
        hour,
        minute,
        daysOfWeek,
        isEnabled,
        soundEnabled,
        vibrationEnabled,
        customMessage,
        deepLinkPayload,
      ];
}
