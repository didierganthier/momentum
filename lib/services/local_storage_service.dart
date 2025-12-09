import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';

class LocalStorageService {
  static const String _habitsKey = 'habits';
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
  }
}
