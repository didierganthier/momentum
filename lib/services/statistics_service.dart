import '../models/habit.dart';
import 'habit_history_service.dart';

/// Service for calculating habit statistics and insights
class StatisticsService {
  final HabitHistoryService _historyService = HabitHistoryService();

  /// Calculate weekly statistics for all habits
  Future<WeeklyStatistics> getWeeklyStatistics(List<Habit> habits) async {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday % 7));
    final weekStartDate = DateTime(weekStart.year, weekStart.month, weekStart.day);

    int totalPossibleCompletions = habits.length * 7;
    int totalCompletions = 0;
    Map<int, int> completionsByDay = {}; // weekday -> count
    Map<int, int> possibleByDay = {}; // weekday -> total habits

    // Initialize days
    for (int i = 0; i < 7; i++) {
      completionsByDay[i] = 0;
      possibleByDay[i] = habits.length;
    }

    // Count completions for each habit
    for (var habit in habits) {
      final completions = await _historyService.getCompletionsForRange(
        habit.id,
        weekStartDate,
        now.add(const Duration(days: 1)),
      );

      for (var completion in completions) {
        final weekday = completion.completedAt.weekday % 7;
        completionsByDay[weekday] = (completionsByDay[weekday] ?? 0) + 1;
        totalCompletions++;
      }
    }

    // Calculate completion rate
    final completionRate = totalPossibleCompletions > 0
        ? (totalCompletions / totalPossibleCompletions * 100).round()
        : 0;

    // Find best and worst days
    int bestDay = 0;
    int worstDay = 0;
    int maxCompletions = 0;
    int minCompletions = habits.length * 7;

    completionsByDay.forEach((day, count) {
      if (count > maxCompletions) {
        maxCompletions = count;
        bestDay = day;
      }
      if (count < minCompletions && possibleByDay[day]! > 0) {
        minCompletions = count;
        worstDay = day;
      }
    });

    final bestDayRate = possibleByDay[bestDay]! > 0
        ? (completionsByDay[bestDay]! / possibleByDay[bestDay]! * 100).round()
        : 0;

    return WeeklyStatistics(
      completionRate: completionRate,
      totalCompletions: totalCompletions,
      totalPossible: totalPossibleCompletions,
      bestDay: bestDay,
      bestDayRate: bestDayRate,
      worstDay: worstDay,
      completionsByDay: completionsByDay,
    );
  }

  /// Calculate monthly statistics for all habits
  Future<MonthlyStatistics> getMonthlyStatistics(List<Habit> habits) async {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);
    final daysInMonth = monthEnd.day;

    int totalPossibleCompletions = habits.length * daysInMonth;
    int totalCompletions = 0;
    int longestStreak = 0;
    Map<int, int> completionsByWeek = {}; // week -> count

    // Count completions for each habit
    for (var habit in habits) {
      final completions = await _historyService.getCompletionsForRange(
        habit.id,
        monthStart,
        now.add(const Duration(days: 1)),
      );

      totalCompletions += completions.length;

      // Calculate streaks for this habit
      final habitStreak = await _historyService.getCurrentStreak(habit.id);
      if (habitStreak > longestStreak) {
        longestStreak = habitStreak;
      }

      // Group by week
      for (var completion in completions) {
        final weekNumber = ((completion.completedAt.day - 1) / 7).floor();
        completionsByWeek[weekNumber] = (completionsByWeek[weekNumber] ?? 0) + 1;
      }
    }

    // Calculate completion rate
    final completionRate = totalPossibleCompletions > 0
        ? (totalCompletions / totalPossibleCompletions * 100).round()
        : 0;

    // Find best week
    int bestWeek = 0;
    int maxWeekCompletions = 0;
    completionsByWeek.forEach((week, count) {
      if (count > maxWeekCompletions) {
        maxWeekCompletions = count;
        bestWeek = week;
      }
    });

    return MonthlyStatistics(
      completionRate: completionRate,
      totalCompletions: totalCompletions,
      totalPossible: totalPossibleCompletions,
      longestStreak: longestStreak,
      bestWeek: bestWeek,
      completionsByWeek: completionsByWeek,
      daysInMonth: daysInMonth,
    );
  }

  /// Get insights and motivational messages
  Future<List<String>> getInsights(List<Habit> habits) async {
    List<String> insights = [];
    
    if (habits.isEmpty) {
      insights.add("Add your first habit to start tracking! 🎯");
      return insights;
    }

    final weekly = await getWeeklyStatistics(habits);
    final monthly = await getMonthlyStatistics(habits);

    // Completion rate insight
    if (weekly.completionRate >= 85) {
      insights.add("🌟 Amazing! You completed ${weekly.completionRate}% of your habits this week!");
    } else if (weekly.completionRate >= 70) {
      insights.add("👏 Great job! ${weekly.completionRate}% completion rate this week.");
    } else if (weekly.completionRate >= 50) {
      insights.add("💪 Keep going! ${weekly.completionRate}% completion this week.");
    } else {
      insights.add("📈 Let's improve! ${weekly.completionRate}% completion this week.");
    }

    // Best day insight
    final dayNames = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    if (weekly.bestDayRate > 0) {
      insights.add("✨ Best day: ${dayNames[weekly.bestDay]} (${weekly.bestDayRate}% completion)");
    }

    // Longest streak insight
    if (monthly.longestStreak > 0) {
      if (monthly.longestStreak >= 30) {
        insights.add("🔥 Incredible! Longest streak: ${monthly.longestStreak} days!");
      } else if (monthly.longestStreak >= 7) {
        insights.add("🔥 Longest streak: ${monthly.longestStreak} days - Keep it up!");
      } else {
        insights.add("🔥 Current best: ${monthly.longestStreak} days streak");
      }
    }

    // Monthly progress
    if (monthly.completionRate >= 80) {
      insights.add("📊 Excellent month! ${monthly.completionRate}% overall completion");
    }

    // Consistency insight
    final daysWithActivity = weekly.completionsByDay.values.where((c) => c > 0).length;
    if (daysWithActivity == 7) {
      insights.add("🎯 Perfect! Active every day this week");
    } else if (daysWithActivity >= 5) {
      insights.add("📅 Great consistency! Active $daysWithActivity days this week");
    }

    return insights;
  }
}

/// Weekly statistics data
class WeeklyStatistics {
  final int completionRate; // Percentage
  final int totalCompletions;
  final int totalPossible;
  final int bestDay; // 0-6 (Sun-Sat)
  final int bestDayRate; // Percentage
  final int worstDay;
  final Map<int, int> completionsByDay;

  WeeklyStatistics({
    required this.completionRate,
    required this.totalCompletions,
    required this.totalPossible,
    required this.bestDay,
    required this.bestDayRate,
    required this.worstDay,
    required this.completionsByDay,
  });
}

/// Monthly statistics data
class MonthlyStatistics {
  final int completionRate; // Percentage
  final int totalCompletions;
  final int totalPossible;
  final int longestStreak;
  final int bestWeek;
  final Map<int, int> completionsByWeek;
  final int daysInMonth;

  MonthlyStatistics({
    required this.completionRate,
    required this.totalCompletions,
    required this.totalPossible,
    required this.longestStreak,
    required this.bestWeek,
    required this.completionsByWeek,
    required this.daysInMonth,
  });
}
