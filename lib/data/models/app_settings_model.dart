import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  const AppSettings({
    this.id = 'singleton_settings',
    this.offlineAudioCached = false,
    this.backgroundAudioEnabled = true,
    this.analyticsOptIn = true,
    this.lastBackupTimestamp,
    this.databaseVersion = 1,
  });

  final String id;
  final bool offlineAudioCached;
  final bool backgroundAudioEnabled;
  final bool analyticsOptIn;
  final DateTime? lastBackupTimestamp;
  final int databaseVersion;

  AppSettings copyWith({
    String? id,
    bool? offlineAudioCached,
    bool? backgroundAudioEnabled,
    bool? analyticsOptIn,
    DateTime? lastBackupTimestamp,
    int? databaseVersion,
  }) {
    return AppSettings(
      id: id ?? this.id,
      offlineAudioCached: offlineAudioCached ?? this.offlineAudioCached,
      backgroundAudioEnabled:
          backgroundAudioEnabled ?? this.backgroundAudioEnabled,
      analyticsOptIn: analyticsOptIn ?? this.analyticsOptIn,
      lastBackupTimestamp: lastBackupTimestamp ?? this.lastBackupTimestamp,
      databaseVersion: databaseVersion ?? this.databaseVersion,
    );
  }

  @override
  List<Object?> get props => [
        id,
        offlineAudioCached,
        backgroundAudioEnabled,
        analyticsOptIn,
        lastBackupTimestamp,
        databaseVersion,
      ];
}
