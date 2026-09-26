import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mood_entry_model.dart';

abstract class MoodRepository {
  Future<void> recordMood(MoodType mood, {String? note});
  Future<MoodEntry?> getLatestMood();
  Future<MoodEntry?> getMoodById(String id);
  Future<List<MoodEntry>> getRecentMoods({int limit = 20});
  Future<List<MoodEntry>> getMoodsForDay(DateTime date);
  Future<void> deleteMood(String id);
  Future<void> clearAllMoods();
}

class InMemoryMoodRepository implements MoodRepository {
  InMemoryMoodRepository({
    List<MoodEntry>? initialEntries,
    SharedPreferences? sharedPreferences,
  })  : _entries = initialEntries != null ? List.of(initialEntries) : [],
        _prefs = sharedPreferences {
    _initPersistence();
  }

  static const String _moodsPrefKey = 'melo_saved_mood_entries_json';
  final List<MoodEntry> _entries;
  SharedPreferences? _prefs;

  Future<void> _initPersistence() async {
    if (_prefs == null) {
      try {
        _prefs = await SharedPreferences.getInstance();
      } catch (_) {}
    }
    if (_prefs != null) {
      final jsonStr = _prefs?.getString(_moodsPrefKey);
      if (jsonStr != null && _entries.isEmpty) {
        try {
          final list = jsonDecode(jsonStr) as List<dynamic>;
          for (final item in list) {
            _entries.add(_moodFromJson(item as Map<String, dynamic>));
          }
        } catch (_) {}
      }
    }
  }

  Future<void> _persist() async {
    try {
      if (_prefs == null) {
        _prefs = await SharedPreferences.getInstance();
      }
      final list = _entries.map(_moodToJson).toList();
      final jsonStr = jsonEncode(list);
      await _prefs?.setString(_moodsPrefKey, jsonStr);
    } catch (_) {}
  }

  @override
  Future<void> recordMood(MoodType mood, {String? note}) async {
    final entry = MoodEntry(
      id: 'mood_${DateTime.now().millisecondsSinceEpoch}_${_entries.length}',
      timestamp: DateTime.now(),
      mood: mood,
      note: note,
    );
    _entries.insert(0, entry);
    await _persist();
  }

  @override
  Future<MoodEntry?> getLatestMood() async {
    if (_entries.isEmpty) return null;
    return _entries.first;
  }

  @override
  Future<MoodEntry?> getMoodById(String id) async {
    try {
      return _entries.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<MoodEntry>> getRecentMoods({int limit = 20}) async {
    return _entries.take(limit).toList();
  }

  @override
  Future<List<MoodEntry>> getMoodsForDay(DateTime date) async {
    return _entries.where((e) {
      return e.timestamp.year == date.year &&
          e.timestamp.month == date.month &&
          e.timestamp.day == date.day;
    }).toList();
  }

  @override
  Future<void> deleteMood(String id) async {
    _entries.removeWhere((e) => e.id == id);
    await _persist();
  }

  @override
  Future<void> clearAllMoods() async {
    _entries.clear();
    await _persist();
  }

  Map<String, dynamic> _moodToJson(MoodEntry e) => {
        'id': e.id,
        'timestamp': e.timestamp.toIso8601String(),
        'mood': e.mood.name,
        'note': e.note,
      };

  MoodEntry _moodFromJson(Map<String, dynamic> json) {
    final moodName = json['mood'] as String? ?? 'calm';
    final mood = MoodType.values.firstWhere(
      (m) => m.name == moodName,
      orElse: () => MoodType.calm,
    );

    return MoodEntry(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      mood: mood,
      note: json['note'] as String?,
    );
  }
}
