import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reminder_model.dart';

abstract class ReminderRepository {
  Future<List<ReminderSchedule>> getReminders();
  Future<ReminderSchedule?> getReminderById(String id);
  Future<void> saveReminder(ReminderSchedule reminder);
  Future<void> toggleReminder(String id, bool isEnabled);
  Future<void> deleteReminder(String id);
  Future<bool> areAllPaused();
  Future<void> setAllPaused(bool paused);
  Future<void> resetToDefaults();
}

class InMemoryReminderRepository implements ReminderRepository {
  InMemoryReminderRepository({
    List<ReminderSchedule>? initialReminders,
    bool? initialAllPaused,
    SharedPreferences? sharedPreferences,
  })  : _reminders = initialReminders != null
            ? List.of(initialReminders)
            : [
                const ReminderSchedule(
                  id: 'reminder_morning',
                  slot: ReminderSlot.morning,
                  hour: 8,
                  minute: 30,
                  daysOfWeek: [1, 2, 3, 4, 5],
                  isEnabled: true,
                  deepLinkPayload: '/home',
                ),
                const ReminderSchedule(
                  id: 'reminder_evening',
                  slot: ReminderSlot.evening,
                  hour: 20,
                  minute: 30,
                  daysOfWeek: [1, 2, 3, 4, 5, 6, 7],
                  isEnabled: true,
                  deepLinkPayload: '/home',
                ),
              ],
        _allPaused = initialAllPaused ?? false,
        _prefs = sharedPreferences {
    _initPersistence();
  }

  static const String _remindersPrefKey = 'melo_saved_reminders_json';
  static const String _allPausedPrefKey = 'melo_reminders_all_paused';

  final List<ReminderSchedule> _reminders;
  bool _allPaused;
  SharedPreferences? _prefs;

  Future<void> _initPersistence() async {
    if (_prefs == null) {
      try {
        _prefs = await SharedPreferences.getInstance();
      } catch (_) {
        // Fallback for tests
      }
    }
    if (_prefs != null) {
      final paused = _prefs?.getBool(_allPausedPrefKey);
      if (paused != null) {
        _allPaused = paused;
      }

      final jsonStr = _prefs?.getString(_remindersPrefKey);
      if (jsonStr != null) {
        try {
          final List<dynamic> list = jsonDecode(jsonStr) as List<dynamic>;
          final parsed = list.map((item) => _fromJson(item as Map<String, dynamic>)).toList();
          _reminders.clear();
          _reminders.addAll(parsed);
        } catch (_) {
          // Keep defaults if json invalid
        }
      }
    }
  }

  Future<void> _persist() async {
    try {
      if (_prefs == null) {
        _prefs = await SharedPreferences.getInstance();
      }
      final jsonList = _reminders.map(_toJson).toList();
      await _prefs?.setString(_remindersPrefKey, jsonEncode(jsonList));
      await _prefs?.setBool(_allPausedPrefKey, _allPaused);
    } catch (_) {
      // In-memory fallback
    }
  }

  @override
  Future<List<ReminderSchedule>> getReminders() async {
    return List.unmodifiable(_reminders);
  }

  @override
  Future<ReminderSchedule?> getReminderById(String id) async {
    try {
      return _reminders.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveReminder(ReminderSchedule reminder) async {
    final index = _reminders.indexWhere((r) => r.id == reminder.id);
    if (index >= 0) {
      _reminders[index] = reminder;
    } else {
      _reminders.add(reminder);
    }
    await _persist();
  }

  @override
  Future<void> toggleReminder(String id, bool isEnabled) async {
    final index = _reminders.indexWhere((r) => r.id == id);
    if (index >= 0) {
      _reminders[index] = _reminders[index].copyWith(isEnabled: isEnabled);
      await _persist();
    }
  }

  @override
  Future<void> deleteReminder(String id) async {
    _reminders.removeWhere((r) => r.id == id);
    await _persist();
  }

  @override
  Future<bool> areAllPaused() async {
    return _allPaused;
  }

  @override
  Future<void> setAllPaused(bool paused) async {
    _allPaused = paused;
    await _persist();
  }

  @override
  Future<void> resetToDefaults() async {
    _reminders.clear();
    _reminders.addAll([
      const ReminderSchedule(
        id: 'reminder_morning',
        slot: ReminderSlot.morning,
        hour: 8,
        minute: 30,
        daysOfWeek: [1, 2, 3, 4, 5],
        isEnabled: true,
        deepLinkPayload: '/home',
      ),
      const ReminderSchedule(
        id: 'reminder_evening',
        slot: ReminderSlot.evening,
        hour: 20,
        minute: 30,
        daysOfWeek: [1, 2, 3, 4, 5, 6, 7],
        isEnabled: true,
        deepLinkPayload: '/home',
      ),
    ]);
    _allPaused = false;
    await _persist();
  }

  Map<String, dynamic> _toJson(ReminderSchedule r) => {
        'id': r.id,
        'slot': r.slot.name,
        'hour': r.hour,
        'minute': r.minute,
        'daysOfWeek': r.daysOfWeek,
        'isEnabled': r.isEnabled,
        'soundEnabled': r.soundEnabled,
        'vibrationEnabled': r.vibrationEnabled,
        'customMessage': r.customMessage,
        'deepLinkPayload': r.deepLinkPayload,
      };

  ReminderSchedule _fromJson(Map<String, dynamic> json) {
    final slotName = json['slot'] as String? ?? 'morning';
    final slot = ReminderSlot.values.firstWhere(
      (s) => s.name == slotName,
      orElse: () => ReminderSlot.morning,
    );
    final daysList = (json['daysOfWeek'] as List<dynamic>?)
            ?.map((e) => e as int)
            .toList() ??
        [1, 2, 3, 4, 5];

    return ReminderSchedule(
      id: json['id'] as String,
      slot: slot,
      hour: json['hour'] as int? ?? 8,
      minute: json['minute'] as int? ?? 0,
      daysOfWeek: daysList,
      isEnabled: json['isEnabled'] as bool? ?? true,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
      customMessage: json['customMessage'] as String?,
      deepLinkPayload: json['deepLinkPayload'] as String?,
    );
  }
}
