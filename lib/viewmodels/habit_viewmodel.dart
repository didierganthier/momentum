import 'package:flutter/widgets.dart';
import '../models/habit.dart';
import '../models/habit_category.dart';
import '../services/habit_service.dart';
import '../services/local_storage_service.dart';

class HabitViewModel extends ChangeNotifier {
  final HabitService _firebaseService = HabitService();
  final LocalStorageService _localStorage = LocalStorageService();

  List<Habit> habits = [];
  bool _isLoggedIn = false;
  HabitCategory? _selectedCategory;

  bool get isLoggedIn => _isLoggedIn;
  HabitCategory? get selectedCategory => _selectedCategory;

  List<Habit> get filteredHabits {
    if (_selectedCategory == null) return habits;
    return habits.where((h) => h.category == _selectedCategory).toList();
  }

  HabitViewModel() {
    _loadHabits();
  }

  void setLoggedIn(bool value) {
    _isLoggedIn = value;
    if (value) {
      _syncLocalToFirebase();
      _listenToFirebase();
    } else {
      _loadLocalHabits();
    }
  }

  Future<void> _loadHabits() async {
    // Initially load from local storage
    await _loadLocalHabits();
  }

  Future<void> _loadLocalHabits() async {
    habits = await _localStorage.getHabits();
    notifyListeners();
  }

  void _listenToFirebase() {
    _firebaseService.getHabits().listen((data) {
      habits = data;
      notifyListeners();
    });
  }

  Future<void> _syncLocalToFirebase() async {
    // Get local habits
    final localHabits = await _localStorage.getHabits();

    if (localHabits.isNotEmpty) {
      // Upload to Firebase
      for (var habit in localHabits) {
        await _firebaseService.createHabitWithData(
          habit.name,
          habit.streak,
          habit.lastCompleted,
          habit.category,
        );
      }

      // Clear local storage after successful sync
      await _localStorage.clearAll();
    }
  }

  void setCategory(HabitCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> addHabit(String name, HabitCategory category) async {
    if (_isLoggedIn) {
      await _firebaseService.createHabit(name, category);
    } else {
      final habit = Habit(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        streak: 0,
        lastCompleted: null,
        category: category,
      );
      await _localStorage.addHabit(habit);
      await _loadLocalHabits();
    }
  }

  Future<void> completeHabit(Habit habit) async {
    if (_isLoggedIn) {
      await _firebaseService.completeHabit(habit);
    } else {
      final now = DateTime.now();
      final lastCompleted = habit.lastCompleted;

      int newStreak = habit.streak;
      if (lastCompleted != null) {
        final difference = now.difference(lastCompleted).inDays;
        if (difference == 1) {
          newStreak++;
        } else if (difference > 1) {
          newStreak = 1;
        }
      } else {
        newStreak = 1;
      }

      final updatedHabit = Habit(
        id: habit.id,
        name: habit.name,
        streak: newStreak,
        lastCompleted: now,
        category: habit.category,
      );

      await _localStorage.updateHabit(updatedHabit);
      await _loadLocalHabits();
    }
  }

  Future<void> deleteHabit(String id) async {
    if (_isLoggedIn) {
      await _firebaseService.deleteHabit(id);
    } else {
      await _localStorage.deleteHabit(id);
      await _loadLocalHabits();
    }
  }
}
