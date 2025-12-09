import 'package:flutter/widgets.dart';
import '../models/habit.dart';
import '../services/habit_service.dart';

class HabitViewModel extends ChangeNotifier {
  final HabitService _service = HabitService();

  List<Habit> habits = [];

  HabitViewModel() {
    _service.getHabits().listen((data) {
      habits = data;
      notifyListeners();
    });
  }

  Future<void> addHabit(String name) async {
    await _service.createHabit(name);
  }

  Future<void> completeHabit(Habit habit) async {
    await _service.completeHabit(habit);
  }

  Future<void> deleteHabit(String id) async {
    await _service.deleteHabit(id);
  }
}
