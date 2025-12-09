import 'package:flutter/material.dart';
import 'habit.dart';
import 'habit_category.dart';

/// Represents a pre-built habit template
class HabitTemplate {
  final String id;
  final String name;
  final String description;
  final String icon;
  final HabitCategory category;
  final TimeOfDay? reminderTime;

  HabitTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.category,
    this.reminderTime,
  });

  /// Convert template to Habit
  Habit toHabit({String? customId}) {
    return Habit(
      id: customId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      category: category,
      streak: 0,
      lastCompleted: null,
      reminderTime: reminderTime,
    );
  }
}

/// Represents a pack of habit templates
class HabitPack {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final List<HabitTemplate> templates;
  final int habitCount;

  HabitPack({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.templates,
  }) : habitCount = templates.length;
}
