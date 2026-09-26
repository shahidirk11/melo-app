import 'package:equatable/equatable.dart';

enum AppThemePreference {
  system,
  light,
  dark,
}

enum TimeOfDayPreference {
  morning,
  afternoon,
  evening,
  custom,
}

class UserPreferences extends Equatable {
  const UserPreferences({
    this.id = 'default_user',
    this.firstName = '',
    this.goals = const [],
    this.preferredDurationSeconds = 300, // 5 minutes default
    this.preferredTimeOfDay = TimeOfDayPreference.morning,
    this.customReminderHour = 8,
    this.customReminderMinute = 0,
    this.notificationsEnabled = false,
    this.themeMode = AppThemePreference.system,
    this.reducedMotion = false,
    this.hapticsEnabled = true,
    this.onboardingCompleted = false,
  });

  final String id;
  final String firstName;
  final List<String> goals;
  final int preferredDurationSeconds;
  final TimeOfDayPreference preferredTimeOfDay;
  final int customReminderHour;
  final int customReminderMinute;
  final bool notificationsEnabled;
  final AppThemePreference themeMode;
  final bool reducedMotion;
  final bool hapticsEnabled;
  final bool onboardingCompleted;

  UserPreferences copyWith({
    String? id,
    String? firstName,
    List<String>? goals,
    int? preferredDurationSeconds,
    TimeOfDayPreference? preferredTimeOfDay,
    int? customReminderHour,
    int? customReminderMinute,
    bool? notificationsEnabled,
    AppThemePreference? themeMode,
    bool? reducedMotion,
    bool? hapticsEnabled,
    bool? onboardingCompleted,
  }) {
    return UserPreferences(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      goals: goals ?? this.goals,
      preferredDurationSeconds:
          preferredDurationSeconds ?? this.preferredDurationSeconds,
      preferredTimeOfDay: preferredTimeOfDay ?? this.preferredTimeOfDay,
      customReminderHour: customReminderHour ?? this.customReminderHour,
      customReminderMinute: customReminderMinute ?? this.customReminderMinute,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      themeMode: themeMode ?? this.themeMode,
      reducedMotion: reducedMotion ?? this.reducedMotion,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        goals,
        preferredDurationSeconds,
        preferredTimeOfDay,
        customReminderHour,
        customReminderMinute,
        notificationsEnabled,
        themeMode,
        reducedMotion,
        hapticsEnabled,
        onboardingCompleted,
      ];
}
