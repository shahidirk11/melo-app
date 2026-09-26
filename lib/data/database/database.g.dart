// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $UserPreferencesTableTable userPreferencesTable = $UserPreferencesTableTable(this);
  late final $MoodEntriesTableTable moodEntriesTable = $MoodEntriesTableTable(this);
  late final $SessionsTableTable sessionsTable = $SessionsTableTable(this);
  late final $SessionRecordsTableTable sessionRecordsTable = $SessionRecordsTableTable(this);
  late final $RemindersTableTable remindersTable = $RemindersTableTable(this);
  late final $FavoritesTableTable favoritesTable = $FavoritesTableTable(this);
  late final $BreathingPatternsTableTable breathingPatternsTable = $BreathingPatternsTableTable(this);
  late final $AppSettingsTableTable appSettingsTable = $AppSettingsTableTable(this);

  @override
  Iterable<TableInfo<Table, Object?>> get allTables => allSchemaEntities.whereType<TableInfo<Table, Object?>>();

  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        userPreferencesTable,
        moodEntriesTable,
        sessionsTable,
        sessionRecordsTable,
        remindersTable,
        favoritesTable,
        breathingPatternsTable,
        appSettingsTable,
      ];
}

class $UserPreferencesTableTable extends UserPreferencesTable
    with TableInfo<UserPreferencesTable, dynamic> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserPreferencesTableTable(this.attachedDatabase, [this._alias]);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        firstName,
        goals,
        preferredDurationSeconds,
        preferredTimeOfDayIndex,
        customReminderHour,
        customReminderMinute,
        notificationsEnabled,
        themeModeIndex,
        reducedMotion,
        hapticsEnabled,
        onboardingCompleted,
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_preferences_table';
  @override
  dynamic map(Map<String, dynamic> data, {String? tablePrefix}) => data;
  @override
  $UserPreferencesTableTable createAlias(String alias) =>
      $UserPreferencesTableTable(attachedDatabase, alias);
}

class $MoodEntriesTableTable extends MoodEntriesTable
    with TableInfo<MoodEntriesTable, dynamic> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoodEntriesTableTable(this.attachedDatabase, [this._alias]);
  @override
  List<GeneratedColumn> get $columns => [id, timestamp, mood, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mood_entries_table';
  @override
  dynamic map(Map<String, dynamic> data, {String? tablePrefix}) => data;
  @override
  $MoodEntriesTableTable createAlias(String alias) =>
      $MoodEntriesTableTable(attachedDatabase, alias);
}

class $SessionsTableTable extends SessionsTable
    with TableInfo<SessionsTable, dynamic> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTableTable(this.attachedDatabase, [this._alias]);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        description,
        category,
        type,
        durationSeconds,
        difficulty,
        tags,
        audioAsset,
        backgroundSoundAsset,
        isPremium,
        sortOrder,
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions_table';
  @override
  dynamic map(Map<String, dynamic> data, {String? tablePrefix}) => data;
  @override
  $SessionsTableTable createAlias(String alias) =>
      $SessionsTableTable(attachedDatabase, alias);
}

class $SessionRecordsTableTable extends SessionRecordsTable
    with TableInfo<SessionRecordsTable, dynamic> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionRecordsTableTable(this.attachedDatabase, [this._alias]);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        sessionId,
        sessionTitle,
        sessionType,
        startedAt,
        completedAt,
        durationCompletedSeconds,
        wasCompleted,
        moodBefore,
        moodAfter,
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_records_table';
  @override
  dynamic map(Map<String, dynamic> data, {String? tablePrefix}) => data;
  @override
  $SessionRecordsTableTable createAlias(String alias) =>
      $SessionRecordsTableTable(attachedDatabase, alias);
}

class $RemindersTableTable extends RemindersTable
    with TableInfo<RemindersTable, dynamic> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTableTable(this.attachedDatabase, [this._alias]);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        slot,
        hour,
        minute,
        daysOfWeek,
        isEnabled,
        soundEnabled,
        vibrationEnabled,
        customMessage,
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders_table';
  @override
  dynamic map(Map<String, dynamic> data, {String? tablePrefix}) => data;
  @override
  $RemindersTableTable createAlias(String alias) =>
      $RemindersTableTable(attachedDatabase, alias);
}

class $FavoritesTableTable extends FavoritesTable
    with TableInfo<FavoritesTable, dynamic> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoritesTableTable(this.attachedDatabase, [this._alias]);
  @override
  List<GeneratedColumn> get $columns => [sessionId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorites_table';
  @override
  dynamic map(Map<String, dynamic> data, {String? tablePrefix}) => data;
  @override
  $FavoritesTableTable createAlias(String alias) =>
      $FavoritesTableTable(attachedDatabase, alias);
}

class $BreathingPatternsTableTable extends BreathingPatternsTable
    with TableInfo<BreathingPatternsTable, dynamic> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BreathingPatternsTableTable(this.attachedDatabase, [this._alias]);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        inhaleSeconds,
        holdAfterInhaleSeconds,
        exhaleSeconds,
        holdAfterExhaleSeconds,
        totalCycles,
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'breathing_patterns_table';
  @override
  dynamic map(Map<String, dynamic> data, {String? tablePrefix}) => data;
  @override
  $BreathingPatternsTableTable createAlias(String alias) =>
      $BreathingPatternsTableTable(attachedDatabase, alias);
}

class $AppSettingsTableTable extends AppSettingsTable
    with TableInfo<AppSettingsTable, dynamic> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTableTable(this.attachedDatabase, [this._alias]);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        offlineAudioCached,
        backgroundAudioEnabled,
        analyticsOptIn,
        lastBackupTimestamp,
        databaseVersion,
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings_table';
  @override
  dynamic map(Map<String, dynamic> data, {String? tablePrefix}) => data;
  @override
  $AppSettingsTableTable createAlias(String alias) =>
      $AppSettingsTableTable(attachedDatabase, alias);
}
