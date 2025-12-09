import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';
import '../models/habit_completion.dart';

class LocalStorageService {
  static const String _habitsKey = 'habits';
  static const String _completionsKey = 'completions';
  static const String _hasSeenOnboardingKey = 'has_seen_onboarding';

  Future<List<Habit>> getHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = prefs.getString(_habitsKey);

    if (habitsJson == null) return [];

    final List<dynamic> habitsList = jsonDecode(habitsJson);
    return habitsList.map((json) => Habit.fromJson(json)).toList();
  }

  Future<void> saveHabits(List<Habit> habits) async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = jsonEncode(habits.map((h) => h.toJson()).toList());
    await prefs.setString(_habitsKey, habitsJson);
  }

  Future<void> addHabit(Habit habit) async {
    final habits = await getHabits();
    habits.add(habit);
    await saveHabits(habits);
  }

  Future<void> updateHabit(Habit habit) async {
    final habits = await getHabits();
    final index = habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      habits[index] = habit;
      await saveHabits(habits);
    }
  }

  Future<void> deleteHabit(String id) async {
    final habits = await getHabits();
    habits.removeWhere((h) => h.id == id);
    await saveHabits(habits);
  }

  Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasSeenOnboardingKey) ?? false;
  }

  Future<void> setHasSeenOnboarding(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSeenOnboardingKey, value);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_habitsKey);
    await prefs.remove(_completionsKey);
  }

  // Completion tracking methods
  Future<List<HabitCompletion>> getCompletions(String habitId) async {
    final prefs = await SharedPreferences.getInstance();
    final completionsJson = prefs.getString(_completionsKey);

    if (completionsJson == null) return [];

    final List<dynamic> allCompletions = jsonDecode(completionsJson);
    return allCompletions
        .map((json) => HabitCompletion.fromJson(json))
        .where((completion) => completion.habitId == habitId)
        .toList();
  }

  Future<void> addCompletion(HabitCompletion completion) async {
    final prefs = await SharedPreferences.getInstance();
    final completionsJson = prefs.getString(_completionsKey);

    List<dynamic> completions = [];
    if (completionsJson != null) {
      completions = jsonDecode(completionsJson);
    }

    completions.add(completion.toJson());
    await prefs.setString(_completionsKey, jsonEncode(completions));
  }

  Future<void> deleteCompletionsForHabit(String habitId) async {
    final prefs = await SharedPreferences.getInstance();
    final completionsJson = prefs.getString(_completionsKey);

    if (completionsJson == null) return;

    List<dynamic> completions = jsonDecode(completionsJson);
    completions.removeWhere((json) => json['habitId'] == habitId);
    await prefs.setString(_completionsKey, jsonEncode(completions));
  }

  Future<List<HabitCompletion>> getAllCompletions() async {
    final prefs = await SharedPreferences.getInstance();
    final completionsJson = prefs.getString(_completionsKey);

    if (completionsJson == null) return [];

    final List<dynamic> allCompletions = jsonDecode(completionsJson);
    return allCompletions
        .map((json) => HabitCompletion.fromJson(json))
        .toList();
  }
}
