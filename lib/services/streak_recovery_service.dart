import '../models/habit.dart';

class StreakRecoveryService {
  /// Check if freezes need to be reset (weekly reset on Monday)
  static bool shouldResetFreezes(DateTime? lastReset) {
    if (lastReset == null) return true;

    final now = DateTime.now();
    final lastMonday = _getLastMonday(now);
    final lastResetMonday = _getLastMonday(lastReset);

    // If the last Monday is different, we're in a new week
    return lastMonday.isAfter(lastResetMonday);
  }

  /// Get the most recent Monday
  static DateTime _getLastMonday(DateTime date) {
    final dayOfWeek = date.weekday; // Monday is 1, Sunday is 7
    final daysToSubtract = dayOfWeek - 1; // 0 for Monday, 6 for Sunday
    final monday = date.subtract(Duration(days: daysToSubtract));
    return DateTime(monday.year, monday.month, monday.day);
  }

  /// Reset freezes for a new week
  static Habit resetFreezes(Habit habit) {
    return Habit(
      id: habit.id,
      name: habit.name,
      streak: habit.streak,
      lastCompleted: habit.lastCompleted,
      category: habit.category,
      reminderTime: habit.reminderTime,
      availableFreezes: 1, // Reset to 1 freeze per week
      lastFreezeReset: DateTime.now(),
      freezeUsedDates: [], // Clear used freeze history
    );
  }

  /// Check if a freeze can be used
  static bool canUseFreeze(Habit habit) {
    // First check if freezes need to be reset
    if (shouldResetFreezes(habit.lastFreezeReset)) {
      return true; // Will be reset when used
    }

    return habit.availableFreezes > 0;
  }

  /// Use a freeze to protect the streak
  static Habit useFreeze(Habit habit) {
    // Reset freezes if needed
    final updatedHabit = shouldResetFreezes(habit.lastFreezeReset)
        ? resetFreezes(habit)
        : habit;

    if (updatedHabit.availableFreezes <= 0) {
      throw Exception('No freezes available');
    }

    final now = DateTime.now();
    final updatedFreezeUsedDates = List<DateTime>.from(
      updatedHabit.freezeUsedDates,
    )..add(now);

    return Habit(
      id: updatedHabit.id,
      name: updatedHabit.name,
      streak: updatedHabit.streak, // Streak is preserved
      lastCompleted: now, // Set as completed to prevent streak break
      category: updatedHabit.category,
      reminderTime: updatedHabit.reminderTime,
      availableFreezes: updatedHabit.availableFreezes - 1,
      lastFreezeReset: updatedHabit.lastFreezeReset ?? now,
      freezeUsedDates: updatedFreezeUsedDates,
    );
  }

  /// Get days until next freeze reset
  static int getDaysUntilReset(DateTime? lastReset) {
    final now = DateTime.now();
    final nextMonday = _getNextMonday(now);
    return nextMonday.difference(now).inDays;
  }

  /// Get the next Monday
  static DateTime _getNextMonday(DateTime date) {
    final dayOfWeek = date.weekday;
    final daysToAdd = dayOfWeek == 1 ? 7 : (8 - dayOfWeek);
    final nextMonday = date.add(Duration(days: daysToAdd));
    return DateTime(nextMonday.year, nextMonday.month, nextMonday.day);
  }

  /// Check if habit needs a freeze to maintain streak
  static bool needsFreeze(Habit habit) {
    if (habit.lastCompleted == null) return false;

    final now = DateTime.now();
    final lastCompleted = habit.lastCompleted!;
    final daysSinceCompletion = now.difference(lastCompleted).inDays;

    // If more than 1 day has passed, streak is at risk
    return daysSinceCompletion > 1;
  }

  /// Get insights about freeze usage
  static Map<String, dynamic> getFreezeInsights(Habit habit) {
    final canUse = canUseFreeze(habit);
    final needsIt = needsFreeze(habit);
    final daysUntilReset = getDaysUntilReset(habit.lastFreezeReset);

    String message = '';
    if (canUse && needsIt) {
      message = '🔄 Your streak is at risk! Use a freeze to protect it.';
    } else if (canUse && !needsIt) {
      message = '✨ You have ${habit.availableFreezes} freeze(s) available.';
    } else if (!canUse && needsIt) {
      message = '⚠️ No freezes left! Complete today to save your streak.';
    } else {
      message = '🎯 Keep going! Next freeze in $daysUntilReset days.';
    }

    return {
      'canUse': canUse,
      'needsFreeze': needsIt,
      'availableFreezes': habit.availableFreezes,
      'daysUntilReset': daysUntilReset,
      'message': message,
      'freezeUsedCount': habit.freezeUsedDates.length,
    };
  }
}
