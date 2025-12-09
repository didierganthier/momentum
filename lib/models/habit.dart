import 'habit_category.dart';
import 'package:flutter/material.dart';

class Habit {
  final String id;
  final String name;
  final int streak;
  final DateTime? lastCompleted;
  final HabitCategory category;
  final TimeOfDay? reminderTime;

  Habit({
    required this.id,
    required this.name,
    required this.streak,
    required this.lastCompleted,
    this.category = HabitCategory.other,
    this.reminderTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'streak': streak,
      'lastCompleted': lastCompleted?.toIso8601String(),
      'category': category.name,
      'reminderTime': reminderTime != null
          ? '${reminderTime!.hour}:${reminderTime!.minute}'
          : null,
    };
  }

  // For Firestore
  factory Habit.fromMap(String id, Map<String, dynamic> map) {
    TimeOfDay? reminderTime;
    if (map['reminderTime'] != null) {
      final parts = (map['reminderTime'] as String).split(':');
      reminderTime = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    }

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
      reminderTime: reminderTime,
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
      'reminderTime': reminderTime != null
          ? '${reminderTime!.hour}:${reminderTime!.minute}'
          : null,
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    TimeOfDay? reminderTime;
    if (json['reminderTime'] != null) {
      final parts = (json['reminderTime'] as String).split(':');
      reminderTime = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    }

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
      reminderTime: reminderTime,
    );
  }
}
