import 'package:equatable/equatable.dart';
import '../../../data/models/session_record_model.dart';

class DayPracticeSummary extends Equatable {
  const DayPracticeSummary({
    required this.date,
    required this.dayOfWeekLabel,
    required this.dayOfMonth,
    required this.minutes,
    required this.sessionCount,
    required this.isToday,
  });

  final DateTime date;
  final String dayOfWeekLabel;
  final int dayOfMonth;
  final int minutes;
  final int sessionCount;
  final bool isToday;

  bool get hasPractice => minutes > 0 || sessionCount > 0;

  @override
  List<Object?> get props => [
        date.year,
        date.month,
        date.day,
        dayOfWeekLabel,
        dayOfMonth,
        minutes,
        sessionCount,
        isToday,
      ];
}

class ProgressSummary extends Equatable {
  const ProgressSummary({
    required this.totalSessions,
    required this.totalMinutes,
    required this.activeDays,
    required this.gentleStreakDays,
    required this.todaySessions,
    required this.todayMinutes,
    required this.weeklySessions,
    required this.weeklyMinutes,
    required this.monthlySessions,
    required this.monthlyMinutes,
    required this.monthlyActiveDays,
    required this.last7Days,
    required this.weeklyCopy,
    required this.monthlyCopy,
    required this.streakHeadline,
    required this.streakSubtitle,
  });

  final int totalSessions;
  final int totalMinutes;
  final int activeDays;
  final int gentleStreakDays;
  final int todaySessions;
  final int todayMinutes;
  final int weeklySessions;
  final int weeklyMinutes;
  final int monthlySessions;
  final int monthlyMinutes;
  final int monthlyActiveDays;
  final List<DayPracticeSummary> last7Days;
  final String weeklyCopy;
  final String monthlyCopy;
  final String streakHeadline;
  final String streakSubtitle;

  static const empty = ProgressSummary(
    totalSessions: 0,
    totalMinutes: 0,
    activeDays: 0,
    gentleStreakDays: 0,
    todaySessions: 0,
    todayMinutes: 0,
    weeklySessions: 0,
    weeklyMinutes: 0,
    monthlySessions: 0,
    monthlyMinutes: 0,
    monthlyActiveDays: 0,
    last7Days: [],
    weeklyCopy: 'A gentle week so far. Whenever you are ready, take 1 minute to pause.',
    monthlyCopy: 'Welcome to this month of gentle, mindful pauses.',
    streakHeadline: 'Ready for today 🌱',
    streakSubtitle: 'Small moments of mindfulness add up to lasting peace.',
  );

  @override
  List<Object?> get props => [
        totalSessions,
        totalMinutes,
        activeDays,
        gentleStreakDays,
        todaySessions,
        todayMinutes,
        weeklySessions,
        weeklyMinutes,
        monthlySessions,
        monthlyMinutes,
        monthlyActiveDays,
        last7Days,
        weeklyCopy,
        monthlyCopy,
        streakHeadline,
        streakSubtitle,
      ];
}

abstract class ProgressAnalytics {
  /// Pure, deterministic calculation of progress statistics from session records.
  /// Never counts abandoned sessions (where [wasCompleted] is false).
  static ProgressSummary calculate(
    List<SessionRecord> records, {
    DateTime? referenceNow,
  }) {
    // 1. Filter out abandoned sessions
    final completed = records.where((r) => r.wasCompleted).toList();
    final now = referenceNow ?? DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);

    if (completed.isEmpty) {
      final days = _buildEmptyLast7Days(todayDate);
      return ProgressSummary.empty.copyWith(last7Days: days);
    }

    // 2. Total metrics
    final totalSessions = completed.length;
    final totalSeconds = completed.fold<int>(
      0,
      (sum, r) => sum + r.durationCompletedSeconds,
    );
    final totalMinutes = (totalSeconds / 60).round();

    // 3. Unique active days
    final activeDaysSet = <String>{};
    for (final r in completed) {
      activeDaysSet.add(_dateKey(r.completedAt));
    }
    final activeDays = activeDaysSet.length;

    // 4. Today metrics
    final todayRecords = completed.where((r) {
      return _isSameDay(r.completedAt, todayDate);
    }).toList();
    final todaySessions = todayRecords.length;
    final todaySeconds = todayRecords.fold<int>(
      0,
      (sum, r) => sum + r.durationCompletedSeconds,
    );
    final todayMinutes = (todaySeconds / 60).round();

    // 5. Weekly metrics (Last 7 days, up to and including today)
    final sevenDaysAgoMidnight = DateTime(
      todayDate.year,
      todayDate.month,
      todayDate.day - 6,
    );
    final weeklyRecords = completed.where((r) {
      final local = r.completedAt.toLocal();
      final rDate = DateTime(local.year, local.month, local.day);
      return !rDate.isBefore(sevenDaysAgoMidnight) && !rDate.isAfter(todayDate);
    }).toList();
    final weeklySessions = weeklyRecords.length;
    final weeklySeconds = weeklyRecords.fold<int>(
      0,
      (sum, r) => sum + r.durationCompletedSeconds,
    );
    final weeklyMinutes = (weeklySeconds / 60).round();

    // 6. Monthly metrics (Current calendar month)
    final monthlyRecords = completed.where((r) {
      final local = r.completedAt.toLocal();
      return local.year == now.year && local.month == now.month;
    }).toList();
    final monthlySessions = monthlyRecords.length;
    final monthlySeconds = monthlyRecords.fold<int>(
      0,
      (sum, r) => sum + r.durationCompletedSeconds,
    );
    final monthlyMinutes = (monthlySeconds / 60).round();
    final monthlyActiveDays = monthlyRecords
        .map((r) => _dateKey(r.completedAt))
        .toSet()
        .length;

    // 7. Last 7 Days breakdown for simple activity chart
    final last7Days = <DayPracticeSummary>[];
    for (int i = 6; i >= 0; i--) {
      final dayDate = DateTime(todayDate.year, todayDate.month, todayDate.day - i);
      final dayRecords = completed.where((r) => _isSameDay(r.completedAt, dayDate));
      final daySeconds = dayRecords.fold<int>(
        0,
        (sum, r) => sum + r.durationCompletedSeconds,
      );

      last7Days.add(
        DayPracticeSummary(
          date: dayDate,
          dayOfWeekLabel: _weekdayShort(dayDate.weekday),
          dayOfMonth: dayDate.day,
          minutes: (daySeconds / 60).round(),
          sessionCount: dayRecords.length,
          isToday: i == 0,
        ),
      );
    }

    // 8. Gentle streak calculation
    final gentleStreakDays = _calculateGentleStreak(completed, todayDate);

    // 9. Copy generation (strictly non-clinical, non-competitive, warm)
    final weeklyCopy = _buildWeeklyCopy(weeklySessions, weeklyMinutes);
    final monthlyCopy = _buildMonthlyCopy(monthlySessions, monthlyMinutes, monthlyActiveDays);
    final (streakHeadline, streakSubtitle) = _buildStreakCopy(
      gentleStreakDays,
      todaySessions > 0,
    );

    return ProgressSummary(
      totalSessions: totalSessions,
      totalMinutes: totalMinutes,
      activeDays: activeDays,
      gentleStreakDays: gentleStreakDays,
      todaySessions: todaySessions,
      todayMinutes: todayMinutes,
      weeklySessions: weeklySessions,
      weeklyMinutes: weeklyMinutes,
      monthlySessions: monthlySessions,
      monthlyMinutes: monthlyMinutes,
      monthlyActiveDays: monthlyActiveDays,
      last7Days: last7Days,
      weeklyCopy: weeklyCopy,
      monthlyCopy: monthlyCopy,
      streakHeadline: streakHeadline,
      streakSubtitle: streakSubtitle,
    );
  }

  static int _calculateGentleStreak(
    List<SessionRecord> completed,
    DateTime todayDate,
  ) {
    if (completed.isEmpty) return 0;

    // Set of distinct practice calendar dates
    final practicedDates = <DateTime>{};
    for (final r in completed) {
      final local = r.completedAt.toLocal();
      practicedDates.add(DateTime(local.year, local.month, local.day));
    }

    bool hasPracticeOn(DateTime date) {
      return practicedDates.any((d) => _isSameDay(d, date));
    }

    // Check today and yesterday
    final practicedToday = hasPracticeOn(todayDate);
    final yesterdayDate = DateTime(todayDate.year, todayDate.month, todayDate.day - 1);
    final practicedYesterday = hasPracticeOn(yesterdayDate);

    if (!practicedToday && !practicedYesterday) {
      // Missed both today and yesterday -> streak is 0
      return 0;
    }

    // Starting anchor for backward traversal
    DateTime checkDate = practicedToday ? todayDate : yesterdayDate;
    int streak = 0;

    while (hasPracticeOn(checkDate)) {
      streak++;
      // Calendar day decrement naturally handles month transitions and leap years
      checkDate = DateTime(checkDate.year, checkDate.month, checkDate.day - 1);
    }

    return streak;
  }

  static String _buildWeeklyCopy(int sessions, int minutes) {
    if (sessions == 0) {
      return 'A gentle week so far. Whenever you are ready, take 1 minute to pause.';
    }
    final timesLabel = sessions == 1 ? '1 time' : '$sessions times';
    final minutesLabel = minutes == 1 ? '1 minute' : '$minutes minutes';
    return 'You practiced $timesLabel this week. You spent $minutesLabel creating quiet moments.';
  }

  static String _buildMonthlyCopy(int sessions, int minutes, int activeDays) {
    if (sessions == 0) {
      return 'Welcome to this month of gentle, mindful pauses.';
    }
    final sessionsLabel = sessions == 1 ? '1 mindful reset' : '$sessions mindful resets';
    final daysLabel = activeDays == 1 ? '1 day' : '$activeDays days';
    return 'You took $sessionsLabel across $daysLabel this month.';
  }

  static (String headline, String subtitle) _buildStreakCopy(
    int streak,
    bool practicedToday,
  ) {
    if (streak == 0) {
      return (
        'Ready for today 🌱',
        'Take a quiet moment whenever you feel like pausing.',
      );
    }
    if (streak == 1) {
      return (
        '1 day of showing up 🌱',
        practicedToday
            ? 'Nice work taking a quiet moment today.'
            : 'Ready for today · Take a gentle 1-minute pause.',
      );
    }
    return (
      '$streak days of showing up 🌱',
      practicedToday
          ? 'Showing kindness to yourself each day.'
          : 'Your gentle flow continues · Ready for today.',
    );
  }

  static List<DayPracticeSummary> _buildEmptyLast7Days(DateTime todayDate) {
    return List.generate(7, (idx) {
      final i = 6 - idx;
      final d = DateTime(todayDate.year, todayDate.month, todayDate.day - i);
      return DayPracticeSummary(
        date: d,
        dayOfWeekLabel: _weekdayShort(d.weekday),
        dayOfMonth: d.day,
        minutes: 0,
        sessionCount: 0,
        isToday: i == 0,
      );
    });
  }

  static String _dateKey(DateTime dt) {
    final local = dt.toLocal();
    return '${local.year}-${local.month}-${local.day}';
  }

  static bool _isSameDay(DateTime a, DateTime b) {
    final la = a.toLocal();
    final lb = b.toLocal();
    return la.year == lb.year && la.month == lb.month && la.day == lb.day;
  }

  static String _weekdayShort(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'M';
      case DateTime.tuesday:
        return 'T';
      case DateTime.wednesday:
        return 'W';
      case DateTime.thursday:
        return 'T';
      case DateTime.friday:
        return 'F';
      case DateTime.saturday:
        return 'S';
      case DateTime.sunday:
        return 'S';
      default:
        return '';
    }
  }
}

extension ProgressSummaryCopyWith on ProgressSummary {
  ProgressSummary copyWith({
    int? totalSessions,
    int? totalMinutes,
    int? activeDays,
    int? gentleStreakDays,
    int? todaySessions,
    int? todayMinutes,
    int? weeklySessions,
    int? weeklyMinutes,
    int? monthlySessions,
    int? monthlyMinutes,
    int? monthlyActiveDays,
    List<DayPracticeSummary>? last7Days,
    String? weeklyCopy,
    String? monthlyCopy,
    String? streakHeadline,
    String? streakSubtitle,
  }) {
    return ProgressSummary(
      totalSessions: totalSessions ?? this.totalSessions,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      activeDays: activeDays ?? this.activeDays,
      gentleStreakDays: gentleStreakDays ?? this.gentleStreakDays,
      todaySessions: todaySessions ?? this.todaySessions,
      todayMinutes: todayMinutes ?? this.todayMinutes,
      weeklySessions: weeklySessions ?? this.weeklySessions,
      weeklyMinutes: weeklyMinutes ?? this.weeklyMinutes,
      monthlySessions: monthlySessions ?? this.monthlySessions,
      monthlyMinutes: monthlyMinutes ?? this.monthlyMinutes,
      monthlyActiveDays: monthlyActiveDays ?? this.monthlyActiveDays,
      last7Days: last7Days ?? this.last7Days,
      weeklyCopy: weeklyCopy ?? this.weeklyCopy,
      monthlyCopy: monthlyCopy ?? this.monthlyCopy,
      streakHeadline: streakHeadline ?? this.streakHeadline,
      streakSubtitle: streakSubtitle ?? this.streakSubtitle,
    );
  }
}
