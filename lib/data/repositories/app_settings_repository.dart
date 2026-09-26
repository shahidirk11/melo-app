import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_settings_model.dart';

abstract class AppSettingsRepository {
  Future<AppSettings> getSettings();
  Future<void> updateSettings(AppSettings settings);
  Future<void> setOfflineAudioCached(bool cached);
  Future<void> setBackgroundAudioEnabled(bool enabled);
  Future<void> setAnalyticsOptIn(bool optIn);
  Future<void> resetToDefaults();
}

class InMemoryAppSettingsRepository implements AppSettingsRepository {
  InMemoryAppSettingsRepository({
    AppSettings? initialSettings,
    SharedPreferences? sharedPreferences,
  })  : _settings = initialSettings ?? const AppSettings(),
        _prefs = sharedPreferences {
    _initPersistence();
  }

  AppSettings _settings;
  SharedPreferences? _prefs;
  static const String _settingsKey = 'melo_saved_app_settings_json';

  Future<void> _initPersistence() async {
    if (_prefs == null) {
      try {
        _prefs = await SharedPreferences.getInstance();
      } catch (_) {}
    }
    if (_prefs != null) {
      final jsonStr = _prefs?.getString(_settingsKey);
      if (jsonStr != null) {
        try {
          final map = jsonDecode(jsonStr) as Map<String, dynamic>;
          _settings = _fromJson(map);
        } catch (_) {}
      }
    }
  }

  Future<void> _persist() async {
    try {
      if (_prefs == null) {
        _prefs = await SharedPreferences.getInstance();
      }
      final jsonStr = jsonEncode(_toJson(_settings));
      await _prefs?.setString(_settingsKey, jsonStr);
    } catch (_) {}
  }

  @override
  Future<AppSettings> getSettings() async => _settings;

  @override
  Future<void> updateSettings(AppSettings settings) async {
    _settings = settings;
    await _persist();
  }

  @override
  Future<void> setOfflineAudioCached(bool cached) async {
    _settings = _settings.copyWith(offlineAudioCached: cached);
    await _persist();
  }

  @override
  Future<void> setBackgroundAudioEnabled(bool enabled) async {
    _settings = _settings.copyWith(backgroundAudioEnabled: enabled);
    await _persist();
  }

  @override
  Future<void> setAnalyticsOptIn(bool optIn) async {
    _settings = _settings.copyWith(analyticsOptIn: optIn);
    await _persist();
  }

  @override
  Future<void> resetToDefaults() async {
    _settings = const AppSettings();
    await _persist();
  }

  Map<String, dynamic> _toJson(AppSettings s) => {
        'id': s.id,
        'offlineAudioCached': s.offlineAudioCached,
        'backgroundAudioEnabled': s.backgroundAudioEnabled,
        'analyticsOptIn': s.analyticsOptIn,
        'databaseVersion': s.databaseVersion,
      };

  AppSettings _fromJson(Map<String, dynamic> json) => AppSettings(
        id: json['id'] as String? ?? 'singleton_settings',
        offlineAudioCached: json['offlineAudioCached'] as bool? ?? false,
        backgroundAudioEnabled: json['backgroundAudioEnabled'] as bool? ?? true,
        analyticsOptIn: json['analyticsOptIn'] as bool? ?? true,
        databaseVersion: json['databaseVersion'] as int? ?? 1,
      );
}
