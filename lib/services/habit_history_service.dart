import '../models/habit.dart';
import '../models/habit_completion.dart';
import 'local_storage_service.dart';
import 'habit_service.dart';

/// Service to manage habit completion history
class HabitHistoryService {
  final LocalStorageService _localStorage = LocalStorageService();
  final HabitService? _firebaseService;
  final bool _isLoggedIn;

  HabitHistoryService({HabitService? firebaseService, bool isLoggedIn = false})
    : _firebaseService = firebaseService,
      _isLoggedIn = isLoggedIn;

  /// Get all completions for a specific habit
  Future<List<HabitCompletion>> getCompletions(String habitId) async {
    if (_isLoggedIn && _firebaseService != null) {
      return await _firebaseService.getCompletionsList(habitId);
    } else {
      return await _localStorage.getCompletions(habitId);
    }
  }

  /// Add a completion for a habit
  Future<void> addCompletion(HabitCompletion completion) async {
    if (!_isLoggedIn) {
      await _localStorage.addCompletion(completion);
    }
    // Firebase service handles this in completeHabit method
  }

  /// Check if a habit was completed on a specific date
  Future<bool> isCompletedOn(String habitId, DateTime date) async {
    final completions = await getCompletions(habitId);
    return completions.any((completion) => completion.isForDate(date));
  }

  /// Get total number of completions for a habit
  Future<int> getTotalCompletions(String habitId) async {
    final completions = await getCompletions(habitId);
    return completions.length;
  }

  /// Get completions for a specific month
  Future<List<HabitCompletion>> getCompletionsForMonth(
    String habitId,
    int year,
    int month,
  ) async {
    final completions = await getCompletions(habitId);
    return completions.where((completion) {
      return completion.completedAt.year == year &&
          completion.completedAt.month == month;
    }).toList();
  }

  /// Get completions for a date range
  Future<List<HabitCompletion>> getCompletionsForRange(
    String habitId,
    DateTime start,
    DateTime end,
  ) async {
    final completions = await getCompletions(habitId);
    return completions.where((completion) {
      return completion.completedAt.isAfter(start) &&
          completion.completedAt.isBefore(end);
    }).toList();
  }

  /// Calculate completion rate as percentage
  Future<int> getCompletionRate(String habitId, {int daysToCheck = 30}) async {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: daysToCheck));

    int completedDays = 0;
    for (int i = 0; i < daysToCheck; i++) {
      final checkDate = startDate.add(Duration(days: i));
      if (await isCompletedOn(habitId, checkDate)) {
        completedDays++;
      }
    }

    return ((completedDays / daysToCheck) * 100).round();
  }

  /// Get current streak for a habit
  Future<int> getCurrentStreak(String habitId) async {
    final completions = await getCompletions(habitId);
    if (completions.isEmpty) return 0;

    // Sort by date descending
    completions.sort((a, b) => b.completedAt.compareTo(a.completedAt));

    int streak = 0;
    DateTime checkDate = DateTime.now();

    for (int i = 0; i < 365; i++) {
      // Check up to a year
      if (await isCompletedOn(habitId, checkDate)) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        // Check if we should allow today if it hasn't been completed yet
        if (i == 0 && !_isToday(checkDate)) {
          break;
        } else if (i > 0) {
          break;
        }
        checkDate = checkDate.subtract(const Duration(days: 1));
      }
    }

    return streak;
  }

  /// Get longest streak for a habit
  Future<int> getLongestStreak(String habitId) async {
    final completions = await getCompletions(habitId);
    if (completions.isEmpty) return 0;

    // Sort by date ascending
    completions.sort((a, b) => a.completedAt.compareTo(b.completedAt));

    int longestStreak = 0;
    int currentStreak = 1;
    DateTime? previousDate;

    for (var completion in completions) {
      if (previousDate != null) {
        final daysDiff = completion.completedAt.difference(previousDate).inDays;

        if (daysDiff == 1) {
          currentStreak++;
        } else {
          longestStreak = currentStreak > longestStreak
              ? currentStreak
              : longestStreak;
          currentStreak = 1;
        }
      }

      previousDate = completion.completedAt;
    }

    return currentStreak > longestStreak ? currentStreak : longestStreak;
  }

  /// Get average streak length
  Future<double> getAverageStreak(String habitId) async {
    final longestStreak = await getLongestStreak(habitId);
    final currentStreak = await getCurrentStreak(habitId);

    if (longestStreak == 0) return 0;

    // Simplified: average of current and longest
    return (currentStreak + longestStreak) / 2;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Clear completions for a specific habit
  Future<void> clearHabit(String habitId) async {
    if (!_isLoggedIn) {
      await _localStorage.deleteCompletionsForHabit(habitId);
    }
    // Firebase deletes completions when habit is deleted
  }

  /// Generate demo data for testing
  Future<void> generateDemoData(Habit habit) async {
    final now = DateTime.now();

    // Generate random completions for the last 90 days
    for (int i = 0; i < 90; i++) {
      final date = now.subtract(Duration(days: i));

      // 70% chance of completion on any given day
      if (DateTime.now().millisecondsSinceEpoch % (i + 2) > 3) {
        final completion = HabitCompletion(
          id: '${habit.id}_demo_$i',
          habitId: habit.id,
          completedAt: date,
        );

        // Add to storage
        if (!_isLoggedIn) {
          await _localStorage.addCompletion(completion);
        }
      }
    }
  }
}
