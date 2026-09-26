import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_preferences_model.dart';

abstract class UserPreferencesRepository {
  Future<UserPreferences> getPreferences();
  Future<void> updatePreferences(UserPreferences preferences);
  Future<void> setFirstName(String name);
  Future<void> setGoals(List<String> goals);
  Future<void> setPreferredDuration(int durationSeconds);
  Future<void> setOnboardingCompleted(bool completed);
  Future<void> setThemePreference(AppThemePreference theme);
  Future<void> setReducedMotion(bool enabled);
  Future<void> setHapticsEnabled(bool enabled);
  Future<void> resetToDefaults();
}

class InMemoryUserPreferencesRepository implements UserPreferencesRepository {
  InMemoryUserPreferencesRepository({
    UserPreferences? initial,
    SharedPreferences? sharedPreferences,
  })  : _preferences = initial ?? const UserPreferences(),
        _prefs = sharedPreferences {
    _initPersistence();
  }

  UserPreferences _preferences;
  SharedPreferences? _prefs;
  static const String _prefsKey = 'melo_saved_user_preferences_json';

  Future<void> _initPersistence() async {
    if (_prefs == null) {
      try {
        _prefs = await SharedPreferences.getInstance();
      } catch (_) {
        // Fallback for tests
      }
    }
    if (_prefs != null) {
      final jsonStr = _prefs?.getString(_prefsKey);
      if (jsonStr != null) {
        try {
          final map = jsonDecode(jsonStr) as Map<String, dynamic>;
          _preferences = _fromJson(map);
        } catch (_) {
          // Keep existing if parse error
        }
      }
    }
  }

  Future<void> _persist() async {
    try {
      if (_prefs == null) {
        _prefs = await SharedPreferences.getInstance();
      }
      final jsonStr = jsonEncode(_toJson(_preferences));
      await _prefs?.setString(_prefsKey, jsonStr);
    } catch (_) {
      // In-memory fallback
    }
  }

  @override
  Future<UserPreferences> getPreferences() async => _preferences;

  @override
  Future<void> updatePreferences(UserPreferences preferences) async {
    _preferences = preferences;
    await _persist();
  }

  @override
  Future<void> setFirstName(String name) async {
    _preferences = _preferences.copyWith(firstName: name);
    await _persist();
  }

  @override
  Future<void> setGoals(List<String> goals) async {
    _preferences = _preferences.copyWith(goals: goals);
    await _persist();
  }

  @override
  Future<void> setPreferredDuration(int durationSeconds) async {
    _preferences = _preferences.copyWith(preferredDurationSeconds: durationSeconds);
    await _persist();
  }

  @override
  Future<void> setOnboardingCompleted(bool completed) async {
    _preferences = _preferences.copyWith(onboardingCompleted: completed);
    await _persist();
  }

  @override
  Future<void> setThemePreference(AppThemePreference theme) async {
    _preferences = _preferences.copyWith(themeMode: theme);
    await _persist();
  }

  @override
  Future<void> setReducedMotion(bool enabled) async {
    _preferences = _preferences.copyWith(reducedMotion: enabled);
    await _persist();
  }

  @override
  Future<void> setHapticsEnabled(bool enabled) async {
    _preferences = _preferences.copyWith(hapticsEnabled: enabled);
    await _persist();
  }

  @override
  Future<void> resetToDefaults() async {
    _preferences = const UserPreferences();
    await _persist();
  }

  Map<String, dynamic> _toJson(UserPreferences p) => {
        'id': p.id,
        'firstName': p.firstName,
        'goals': p.goals,
        'preferredDurationSeconds': p.preferredDurationSeconds,
        'preferredTimeOfDay': p.preferredTimeOfDay.name,
        'customReminderHour': p.customReminderHour,
        'customReminderMinute': p.customReminderMinute,
        'notificationsEnabled': p.notificationsEnabled,
        'themeMode': p.themeMode.name,
        'reducedMotion': p.reducedMotion,
        'hapticsEnabled': p.hapticsEnabled,
        'onboardingCompleted': p.onboardingCompleted,
      };

  UserPreferences _fromJson(Map<String, dynamic> json) {
    final themeName = json['themeMode'] as String? ?? 'system';
    final theme = AppThemePreference.values.firstWhere(
      (t) => t.name == themeName,
      orElse: () => AppThemePreference.system,
    );

    final timeName = json['preferredTimeOfDay'] as String? ?? 'morning';
    final timeOfDay = TimeOfDayPreference.values.firstWhere(
      (t) => t.name == timeName,
      orElse: () => TimeOfDayPreference.morning,
    );

    final goalsList = (json['goals'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        const [];

    return UserPreferences(
      id: json['id'] as String? ?? 'default_user',
      firstName: json['firstName'] as String? ?? '',
      goals: goalsList,
      preferredDurationSeconds:
          json['preferredDurationSeconds'] as int? ?? 300,
      preferredTimeOfDay: timeOfDay,
      customReminderHour: json['customReminderHour'] as int? ?? 8,
      customReminderMinute: json['customReminderMinute'] as int? ?? 0,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? false,
      themeMode: theme,
      reducedMotion: json['reducedMotion'] as bool? ?? false,
      hapticsEnabled: json['hapticsEnabled'] as bool? ?? true,
      onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
    );
  }
}
