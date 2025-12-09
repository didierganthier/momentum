import 'habit_category.dart';

class Habit {
  final String id;
  final String name;
  final int streak;
  final DateTime? lastCompleted;
  final HabitCategory category;

  Habit({
    required this.id,
    required this.name,
    required this.streak,
    required this.lastCompleted,
    this.category = HabitCategory.other,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'streak': streak,
      'lastCompleted': lastCompleted?.toIso8601String(),
      'category': category.name,
    };
  }

  // For Firestore
  factory Habit.fromMap(String id, Map<String, dynamic> map) {
    return Habit(
      id: id,
      name: map['name'],
      streak: map['streak'] ?? 0,
      lastCompleted: map['lastCompleted'] != null
          ? DateTime.parse(map['lastCompleted'])
          : null,
      category: HabitCategory.values.firstWhere(
        (c) => c.name == map['category'],
        orElse: () => HabitCategory.other,
      ),
    );
  }

  // For local storage (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'streak': streak,
      'lastCompleted': lastCompleted?.toIso8601String(),
      'category': category.name,
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      name: json['name'],
      streak: json['streak'] ?? 0,
      lastCompleted: json['lastCompleted'] != null
          ? DateTime.parse(json['lastCompleted'])
          : null,
      category: HabitCategory.values.firstWhere(
        (c) => c.name == (json['category'] ?? 'other'),
        orElse: () => HabitCategory.other,
      ),
    );
  }
}
