import 'package:drift/drift.dart';

part 'database.g.dart';

// --- TABLE DEFINITIONS ---

class UserPreferencesTable extends Table {
  TextColumn get id => text()();
  TextColumn get firstName => text().withDefault(const Constant(''))();
  TextColumn get goals => text().withDefault(const Constant(''))(); // comma-separated
  IntColumn get preferredDurationSeconds => integer().withDefault(const Constant(300))();
  IntColumn get preferredTimeOfDayIndex => integer().withDefault(const Constant(0))();
  IntColumn get customReminderHour => integer().withDefault(const Constant(8))();
  IntColumn get customReminderMinute => integer().withDefault(const Constant(0))();
  BoolColumn get notificationsEnabled => boolean().withDefault(const Constant(false))();
  IntColumn get themeModeIndex => integer().withDefault(const Constant(0))();
  BoolColumn get reducedMotion => boolean().withDefault(const Constant(false))();
  BoolColumn get hapticsEnabled => boolean().withDefault(const Constant(true))();
  BoolColumn get onboardingCompleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class MoodEntriesTable extends Table {
  TextColumn get id => text()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get mood => text()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class SessionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get category => text()();
  TextColumn get type => text()();
  IntColumn get durationSeconds => integer()();
  TextColumn get difficulty => text()();
  TextColumn get tags => text().withDefault(const Constant(''))(); // comma-separated
  TextColumn get audioAsset => text().nullable()();
  TextColumn get backgroundSoundAsset => text().nullable()();
  BoolColumn get isPremium => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class SessionRecordsTable extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text()();
  TextColumn get sessionTitle => text()();
  TextColumn get sessionType => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime()();
  IntColumn get durationCompletedSeconds => integer()();
  BoolColumn get wasCompleted => boolean()();
  TextColumn get moodBefore => text().nullable()();
  TextColumn get moodAfter => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class RemindersTable extends Table {
  TextColumn get id => text()();
  TextColumn get slot => text()();
  IntColumn get hour => integer()();
  IntColumn get minute => integer()();
  TextColumn get daysOfWeek => text()(); // comma-separated e.g. "1,2,3,4,5"
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();
  BoolColumn get soundEnabled => boolean().withDefault(const Constant(true))();
  BoolColumn get vibrationEnabled => boolean().withDefault(const Constant(true))();
  TextColumn get customMessage => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class FavoritesTable extends Table {
  TextColumn get sessionId => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {sessionId};
}

class BreathingPatternsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  IntColumn get inhaleSeconds => integer()();
  IntColumn get holdAfterInhaleSeconds => integer()();
  IntColumn get exhaleSeconds => integer()();
  IntColumn get holdAfterExhaleSeconds => integer()();
  IntColumn get totalCycles => integer().withDefault(const Constant(4))();

  @override
  Set<Column> get primaryKey => {id};
}

class AppSettingsTable extends Table {
  TextColumn get id => text()();
  BoolColumn get offlineAudioCached => boolean().withDefault(const Constant(false))();
  BoolColumn get backgroundAudioEnabled => boolean().withDefault(const Constant(true))();
  BoolColumn get analyticsOptIn => boolean().withDefault(const Constant(true))();
  DateTimeColumn get lastBackupTimestamp => dateTime().nullable()();
  IntColumn get databaseVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  UserPreferencesTable,
  MoodEntriesTable,
  SessionsTable,
  SessionRecordsTable,
  RemindersTable,
  FavoritesTable,
  BreathingPatternsTable,
  AppSettingsTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Safe progressive database migrations
          if (from < 2) {
            // Future schema migrations
          }
        },
        beforeOpen: (details) async {
          // Ensure foreign keys and pragma performance optimization
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
