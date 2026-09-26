# Melo Database & Persistence Architecture

This document outlines the local storage architecture, table definitions, migration strategy, serialization schemas, and data management flows in the **Melo** application.

---

## 1. Local-First Philosophy

Melo is built on a **100% offline-first, privacy-by-design** storage foundation:
* **No Remote Database Requirement:** No cloud sync, user logins, or remote server dependencies are required to meditate, track progress, or schedule reminders.
* **Instantaneous Latency:** Data reads and writes complete in single-digit milliseconds directly from local device memory and disk.
* **Zero Telemetry Leakage:** Personal reflections, mood entries, and mindfulness history never leave the user's phone.

---

## 2. Storage Architecture

Melo utilizes a **hybrid dual-tier storage strategy**:

```
┌────────────────────────────────────────────────────────┐
│                   Flutter Application                  │
└──────────────┬──────────────────────────┬──────────────┘
               │                          │
       ┌───────▼────────┐        ┌────────▼────────┐
       │   Relational   │        │   Fast Key/Doc  │
       │  Drift SQLite  │        │   SharedPrefs   │
       └───────┬────────┘        └────────┬────────┘
               │                          │
       ┌───────▼──────────────────────────▼────────┐
       │          Device Local Storage             │
       │    (app_database.sqlite / XML prefs)      │
       └───────────────────────────────────────────┘
```

1. **Relational SQLite via Drift (`lib/data/database/database.dart`):**
   * High-capacity structured storage for historical practice data, relational joins, complex analytics queries, and index-accelerated searching.
2. **Key-Value Document Store (`shared_preferences`):**
   * High-speed JSON serialization for instant app bootstrapping, active preferences, theme mode, and in-memory repository caching without asynchronous startup lag.

---

## 3. Drift SQLite Schema Specifications

### 3.1 `UserPreferencesTable`
| Column | Type | Default | Description |
|---|---|---|---|
| `id` | TEXT (PK) | - | Unique user preference profile identifier |
| `firstName` | TEXT | `''` | User's preferred display name |
| `goals` | TEXT | `''` | Comma-separated mindful intentions (e.g. `calm,sleep`) |
| `preferredDurationSeconds` | INTEGER | `300` | Default session duration (e.g. 180s, 300s, 600s) |
| `preferredTimeOfDayIndex` | INTEGER | `0` | Morning (0), Afternoon (1), Evening (2), Night (3) |
| `customReminderHour` | INTEGER | `8` | Custom reminder hour (0–23) |
| `customReminderMinute` | INTEGER | `0` | Custom reminder minute (0–59) |
| `notificationsEnabled` | BOOLEAN | `false` | Global notification permission state |
| `themeModeIndex` | INTEGER | `0` | System (0), Light (1), Dark (2) |
| `reducedMotion` | BOOLEAN | `false` | Reduced motion accessibility flag |
| `hapticsEnabled` | BOOLEAN | `true` | Tactile vibration feedback toggle |
| `onboardingCompleted` | BOOLEAN | `false` | Whether first-run onboarding has been completed |

### 3.2 `MoodEntriesTable`
| Column | Type | Default | Description |
|---|---|---|---|
| `id` | TEXT (PK) | - | Unique UUID of the mood check-in |
| `timestamp` | DATETIME | - | Timestamp when the user checked in |
| `mood` | TEXT | - | Mood identifier: `calm`, `good`, `okay`, `stressed`, `tired` |
| `note` | TEXT | `NULL` | Optional private reflection note |

### 3.3 `SessionsTable`
| Column | Type | Default | Description |
|---|---|---|---|
| `id` | TEXT (PK) | - | Unique session ID (e.g. `session_1m_reset`) |
| `title` | TEXT | - | Display title of the practice |
| `description` | TEXT | - | Detailed guidance and session overview |
| `category` | TEXT | - | Category: `calm`, `focus`, `sleep`, `morning`, etc. |
| `type` | TEXT | - | `breathing`, `guidedMeditation`, `quickReset` |
| `durationSeconds` | INTEGER | - | Practice length in seconds |
| `difficulty` | TEXT | - | `beginner`, `intermediate`, `advanced` |
| `tags` | TEXT | `''` | Searchable comma-separated tags |
| `audioAsset` | TEXT | `NULL` | Bundled audio narration file path |
| `backgroundSoundAsset` | TEXT | `NULL` | Bundled background ambient sound path |
| `isPremium` | BOOLEAN | `false` | Premium tier reservation |
| `sortOrder` | INTEGER | `0` | Default sorting priority |

### 3.4 `SessionRecordsTable`
| Column | Type | Default | Description |
|---|---|---|---|
| `id` | TEXT (PK) | - | Unique record UUID |
| `sessionId` | TEXT | - | Foreign reference to `SessionsTable.id` |
| `sessionTitle` | TEXT | - | Snapshot title at time of practice |
| `sessionType` | TEXT | - | Type at time of practice |
| `startedAt` | DATETIME | - | Session start timestamp |
| `completedAt` | DATETIME | - | Session completion timestamp |
| `durationCompletedSeconds` | INTEGER | - | Time spent in seconds |
| `wasCompleted` | BOOLEAN | - | `true` if finished; `false` if abandoned early |
| `moodBefore` | TEXT | `NULL` | Mood logged prior to session start |
| `moodAfter` | TEXT | `NULL` | Reflection logged after session completion |

### 3.5 `RemindersTable`
| Column | Type | Default | Description |
|---|---|---|---|
| `id` | TEXT (PK) | - | Reminder slot UUID |
| `slot` | TEXT | - | `morning`, `afternoon`, `evening`, `custom` |
| `hour` | INTEGER | - | Scheduled hour (0–23) |
| `minute` | INTEGER | - | Scheduled minute (0–59) |
| `daysOfWeek` | TEXT | - | Active weekdays (e.g. `"1,2,3,4,5"`) |
| `isEnabled` | BOOLEAN | `true` | Active schedule status |
| `soundEnabled` | BOOLEAN | `true` | Audible alert toggle |
| `vibrationEnabled`| BOOLEAN | `true` | Vibration pattern toggle |
| `customMessage` | TEXT | `NULL` | Optional personalized supportive copy |

### 3.6 `FavoritesTable`
| Column | Type | Default | Description |
|---|---|---|---|
| `sessionId` | TEXT (PK) | - | Session ID bookmarked as favorite |
| `createdAt` | DATETIME | - | Timestamp when added to favorites |

---

## 4. Migration Strategy

The Drift database uses explicit schema versioning:

```dart
@override
int get schemaVersion => 1;

@override
MigrationStrategy get migration => MigrationStrategy(
  onCreate: (Migrator m) async {
    await m.createAll();
  },
  onUpgrade: (Migrator m, int from, int to) async {
    // Progressive version upgrade steps:
    // if (from < 2) { ... }
  },
  beforeOpen: (details) async {
    await customStatement('PRAGMA foreign_keys = ON');
  },
);
```

### Upgrades & Migrations Policy
1. **Never drop tables in production:** Schema migrations must add columns using `.addColumn()` or transform tables through temporary staging tables.
2. **Version Bump:** Every schema change increments `schemaVersion` by 1 and is accompanied by a migration test in `test/unit/database_migration_test.dart`.

---

## 5. Data Management & Privacy Actions

1. **JSON Data Export:**
   Users can export their complete mindful journey at any time from **Settings $\to$ Data Management $\to$ Export Data**. The export produces a structured JSON bundle containing:
   * Profile preferences and goals
   * Complete session history and timestamps
   * Mood log records
   * Active reminder configurations
2. **Clear Local Data:**
   Accessible via **Settings $\to$ Data Management $\to$ Clear Data**. To prevent accidental loss, the action displays a modal warning requiring explicit user confirmation before purging records.
