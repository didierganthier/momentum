import 'habit_category.dart';
import 'package:flutter/material.dart';

class Habit {
  final String id;
  final String name;
  final int streak;
  final DateTime? lastCompleted;
  final HabitCategory category;
  final TimeOfDay? reminderTime;
  final int availableFreezes; // Number of freezes available this week
  final DateTime? lastFreezeReset; // When freezes were last reset
  final List<DateTime> freezeUsedDates; // Dates when freezes were used

  Habit({
    required this.id,
    required this.name,
    required this.streak,
    required this.lastCompleted,
    this.category = HabitCategory.other,
    this.reminderTime,
    this.availableFreezes = 1, // One freeze per week by default
    this.lastFreezeReset,
    this.freezeUsedDates = const [],
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
      'availableFreezes': availableFreezes,
      'lastFreezeReset': lastFreezeReset?.toIso8601String(),
      'freezeUsedDates': freezeUsedDates
          .map((d) => d.toIso8601String())
          .toList(),
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

    List<DateTime> freezeUsedDates = [];
    if (map['freezeUsedDates'] != null) {
      freezeUsedDates = (map['freezeUsedDates'] as List)
          .map((d) => DateTime.parse(d as String))
          .toList();
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
      availableFreezes: map['availableFreezes'] ?? 1,
      lastFreezeReset: map['lastFreezeReset'] != null
          ? DateTime.parse(map['lastFreezeReset'])
          : null,
      freezeUsedDates: freezeUsedDates,
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
      'availableFreezes': availableFreezes,
      'lastFreezeReset': lastFreezeReset?.toIso8601String(),
      'freezeUsedDates': freezeUsedDates
          .map((d) => d.toIso8601String())
          .toList(),
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

    List<DateTime> freezeUsedDates = [];
    if (json['freezeUsedDates'] != null) {
      freezeUsedDates = (json['freezeUsedDates'] as List)
          .map((d) => DateTime.parse(d as String))
          .toList();
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
      availableFreezes: json['availableFreezes'] ?? 1,
      lastFreezeReset: json['lastFreezeReset'] != null
          ? DateTime.parse(json['lastFreezeReset'])
          : null,
      freezeUsedDates: freezeUsedDates,
    );
  }
}
