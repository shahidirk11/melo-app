import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/progress/domain/progress_analytics.dart';
import '../models/mood_entry_model.dart';
import '../models/session_model.dart';
import '../models/session_record_model.dart';

class PracticeStats {
  const PracticeStats({
    required this.totalSessions,
    required this.totalMinutes,
    required this.activeDays,
    required this.currentGentleStreakDays,
    required this.weeklyMinutes,
    required this.monthlyMinutes,
  });

  final int totalSessions;
  final int totalMinutes;
  final int activeDays;
  final int currentGentleStreakDays;
  final int weeklyMinutes;
  final int monthlyMinutes;

  static const empty = PracticeStats(
    totalSessions: 0,
    totalMinutes: 0,
    activeDays: 0,
    currentGentleStreakDays: 0,
    weeklyMinutes: 0,
    monthlyMinutes: 0,
  );
}

abstract class ProgressRepository {
  Future<void> recordSession(SessionRecord record);
  Future<List<SessionRecord>> getHistory({int limit = 50});
  Future<SessionRecord?> getRecordById(String id);
  Future<void> deleteRecord(String id);
  Future<void> clearAllHistory();
  Future<PracticeStats> getStats();
  Future<ProgressSummary> getSummary({DateTime? referenceNow});
}

class InMemoryProgressRepository implements ProgressRepository {
  InMemoryProgressRepository({
    List<SessionRecord>? initialRecords,
    SharedPreferences? sharedPreferences,
  })  : _records = initialRecords != null ? List.of(initialRecords) : [],
        _prefs = sharedPreferences {
    _initPersistence();
  }

  static const String _recordsPrefKey = 'melo_saved_session_records_json';
  final List<SessionRecord> _records;
  SharedPreferences? _prefs;

  Future<void> _initPersistence() async {
    if (_prefs == null) {
      try {
        _prefs = await SharedPreferences.getInstance();
      } catch (_) {}
    }
    if (_prefs != null) {
      final jsonStr = _prefs?.getString(_recordsPrefKey);
      if (jsonStr != null && _records.isEmpty) {
        try {
          final list = jsonDecode(jsonStr) as List<dynamic>;
          for (final item in list) {
            _records.add(_recordFromJson(item as Map<String, dynamic>));
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
      final list = _records.map(_recordToJson).toList();
      final jsonStr = jsonEncode(list);
      await _prefs?.setString(_recordsPrefKey, jsonStr);
    } catch (_) {}
  }

  @override
  Future<void> recordSession(SessionRecord record) async {
    _records.insert(0, record);
    await _persist();
  }

  @override
  Future<List<SessionRecord>> getHistory({int limit = 50}) async {
    return _records.take(limit).toList();
  }

  @override
  Future<SessionRecord?> getRecordById(String id) async {
    try {
      return _records.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> deleteRecord(String id) async {
    _records.removeWhere((r) => r.id == id);
    await _persist();
  }

  @override
  Future<void> clearAllHistory() async {
    _records.clear();
    await _persist();
  }

  @override
  Future<PracticeStats> getStats() async {
    final summary = ProgressAnalytics.calculate(_records);
    return PracticeStats(
      totalSessions: summary.totalSessions,
      totalMinutes: summary.totalMinutes,
      activeDays: summary.activeDays,
      currentGentleStreakDays: summary.gentleStreakDays,
      weeklyMinutes: summary.weeklyMinutes,
      monthlyMinutes: summary.monthlyMinutes,
    );
  }

  @override
  Future<ProgressSummary> getSummary({DateTime? referenceNow}) async {
    return ProgressAnalytics.calculate(_records, referenceNow: referenceNow);
  }

  Map<String, dynamic> _recordToJson(SessionRecord r) => {
        'id': r.id,
        'sessionId': r.sessionId,
        'sessionTitle': r.sessionTitle,
        'sessionType': r.sessionType.name,
        'startedAt': r.startedAt.toIso8601String(),
        'completedAt': r.completedAt.toIso8601String(),
        'durationCompletedSeconds': r.durationCompletedSeconds,
        'wasCompleted': r.wasCompleted,
        'moodBefore': r.moodBefore?.name,
        'moodAfter': r.moodAfter?.name,
      };

  SessionRecord _recordFromJson(Map<String, dynamic> json) {
    final typeName = json['sessionType'] as String? ?? 'guidedMeditation';
    final sessionType = SessionType.values.firstWhere(
      (t) => t.name == typeName,
      orElse: () => SessionType.guidedMeditation,
    );

    final moodBeforeName = json['moodBefore'] as String?;
    final moodBefore = moodBeforeName != null
        ? MoodType.values.firstWhere(
            (m) => m.name == moodBeforeName,
            orElse: () => MoodType.calm,
          )
        : null;

    final moodAfterName = json['moodAfter'] as String?;
    final moodAfter = moodAfterName != null
        ? ReflectionMood.values.firstWhere(
            (m) => m.name == moodAfterName,
            orElse: () => ReflectionMood.moreRelaxed,
          )
        : null;

    return SessionRecord(
      id: json['id'] as String,
      sessionId: json['sessionId'] as String,
      sessionTitle: json['sessionTitle'] as String,
      sessionType: sessionType,
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt: DateTime.parse(json['completedAt'] as String),
      durationCompletedSeconds: json['durationCompletedSeconds'] as int? ?? 0,
      wasCompleted: json['wasCompleted'] as bool? ?? true,
      moodBefore: moodBefore,
      moodAfter: moodAfter,
    );
  }
}
