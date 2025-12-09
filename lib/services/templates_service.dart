import 'package:flutter/material.dart';
import '../models/habit_template.dart';
import '../models/habit_category.dart';

/// Service for managing habit templates and packs
class TemplatesService {
  /// Get all available habit packs
  static List<HabitPack> getAllPacks() {
    return [
      _getMorningRoutinePack(),
      _getFitnessGoalsPack(),
      _getMentalHealthPack(),
      _getProductivityBoostPack(),
    ];
  }

  /// Morning Routine Pack - 5 habits
  static HabitPack _getMorningRoutinePack() {
    return HabitPack(
      id: 'morning_routine',
      name: 'Morning Routine',
      description: 'Start your day right with these essential morning habits',
      emoji: '🌅',
      templates: [
        HabitTemplate(
          id: 'wake_up_early',
          name: 'Wake up at 6 AM',
          description: 'Rise early to make the most of your day',
          icon: '⏰',
          category: HabitCategory.health,
          reminderTime: const TimeOfDay(hour: 6, minute: 0),
        ),
        HabitTemplate(
          id: 'drink_water',
          name: 'Drink water (500ml)',
          description: 'Hydrate first thing in the morning',
          icon: '💧',
          category: HabitCategory.health,
          reminderTime: const TimeOfDay(hour: 6, minute: 15),
        ),
        HabitTemplate(
          id: 'morning_stretch',
          name: 'Morning stretch (10 min)',
          description: 'Wake up your body with gentle stretching',
          icon: '🧘',
          category: HabitCategory.health,
          reminderTime: const TimeOfDay(hour: 6, minute: 30),
        ),
        HabitTemplate(
          id: 'healthy_breakfast',
          name: 'Eat healthy breakfast',
          description: 'Fuel your body with nutritious food',
          icon: '🥗',
          category: HabitCategory.health,
          reminderTime: const TimeOfDay(hour: 7, minute: 0),
        ),
        HabitTemplate(
          id: 'plan_day',
          name: 'Plan your day',
          description: 'Review goals and schedule for the day',
          icon: '📝',
          category: HabitCategory.productivity,
          reminderTime: const TimeOfDay(hour: 7, minute: 30),
        ),
      ],
    );
  }

  /// Fitness Goals Pack - 6 habits
  static HabitPack _getFitnessGoalsPack() {
    return HabitPack(
      id: 'fitness_goals',
      name: 'Fitness Goals',
      description: 'Build a strong, healthy body with consistent exercise',
      emoji: '💪',
      templates: [
        HabitTemplate(
          id: 'morning_run',
          name: 'Morning run (30 min)',
          description: 'Cardio exercise to boost energy',
          icon: '🏃',
          category: HabitCategory.health,
          reminderTime: const TimeOfDay(hour: 6, minute: 30),
        ),
        HabitTemplate(
          id: 'strength_training',
          name: 'Strength training',
          description: 'Build muscle with resistance exercises',
          icon: '🏋️',
          category: HabitCategory.health,
        ),
        HabitTemplate(
          id: 'yoga_session',
          name: 'Yoga session (20 min)',
          description: 'Improve flexibility and balance',
          icon: '🧘',
          category: HabitCategory.health,
        ),
        HabitTemplate(
          id: '10k_steps',
          name: 'Walk 10,000 steps',
          description: 'Stay active throughout the day',
          icon: '👟',
          category: HabitCategory.health,
        ),
        HabitTemplate(
          id: 'drink_2l_water',
          name: 'Drink 2L water',
          description: 'Stay hydrated for optimal performance',
          icon: '💧',
          category: HabitCategory.health,
        ),
        HabitTemplate(
          id: 'track_calories',
          name: 'Track calories',
          description: 'Monitor your nutrition intake',
          icon: '🍎',
          category: HabitCategory.health,
        ),
      ],
    );
  }

  /// Mental Health Pack - 4 habits
  static HabitPack _getMentalHealthPack() {
    return HabitPack(
      id: 'mental_health',
      name: 'Mental Health',
      description: 'Nurture your mind and emotional well-being',
      emoji: '🧠',
      templates: [
        HabitTemplate(
          id: 'meditation',
          name: 'Meditate (15 min)',
          description: 'Practice mindfulness and reduce stress',
          icon: '🧘‍♀️',
          category: HabitCategory.mindfulness,
          reminderTime: const TimeOfDay(hour: 7, minute: 0),
        ),
        HabitTemplate(
          id: 'gratitude_journal',
          name: 'Gratitude journaling',
          description: 'Write 3 things you\'re grateful for',
          icon: '📔',
          category: HabitCategory.mindfulness,
          reminderTime: const TimeOfDay(hour: 21, minute: 0),
        ),
        HabitTemplate(
          id: 'deep_breathing',
          name: 'Deep breathing exercises',
          description: 'Practice calm breathing for 5 minutes',
          icon: '🌬️',
          category: HabitCategory.mindfulness,
        ),
        HabitTemplate(
          id: 'digital_detox',
          name: 'Digital detox (1 hour)',
          description: 'Disconnect from screens and social media',
          icon: '📵',
          category: HabitCategory.mindfulness,
          reminderTime: const TimeOfDay(hour: 20, minute: 0),
        ),
      ],
    );
  }

  /// Productivity Boost Pack - 7 habits
  static HabitPack _getProductivityBoostPack() {
    return HabitPack(
      id: 'productivity_boost',
      name: 'Productivity Boost',
      description: 'Maximize your efficiency and achieve your goals',
      emoji: '🚀',
      templates: [
        HabitTemplate(
          id: 'morning_planning',
          name: 'Morning planning session',
          description: 'Set priorities for the day ahead',
          icon: '📅',
          category: HabitCategory.productivity,
          reminderTime: const TimeOfDay(hour: 6, minute: 30),
        ),
        HabitTemplate(
          id: 'pomodoro_sessions',
          name: 'Complete 4 Pomodoros',
          description: 'Focus sessions of 25 minutes each',
          icon: '🍅',
          category: HabitCategory.productivity,
        ),
        HabitTemplate(
          id: 'inbox_zero',
          name: 'Achieve inbox zero',
          description: 'Clear and organize all emails',
          icon: '📧',
          category: HabitCategory.productivity,
        ),
        HabitTemplate(
          id: 'learn_something_new',
          name: 'Learn something new (30 min)',
          description: 'Read, watch courses, or practice skills',
          icon: '📚',
          category: HabitCategory.learning,
        ),
        HabitTemplate(
          id: 'review_goals',
          name: 'Review weekly goals',
          description: 'Track progress on long-term objectives',
          icon: '🎯',
          category: HabitCategory.productivity,
        ),
        HabitTemplate(
          id: 'no_multitasking',
          name: 'Single-task focus',
          description: 'Work on one thing at a time',
          icon: '🎯',
          category: HabitCategory.productivity,
        ),
        HabitTemplate(
          id: 'evening_review',
          name: 'Evening review',
          description: 'Reflect on accomplishments and learnings',
          icon: '🌙',
          category: HabitCategory.productivity,
          reminderTime: const TimeOfDay(hour: 21, minute: 0),
        ),
      ],
    );
  }

  /// Get a specific pack by ID
  static HabitPack? getPackById(String id) {
    try {
      return getAllPacks().firstWhere((pack) => pack.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Search templates across all packs
  static List<HabitTemplate> searchTemplates(String query) {
    final allTemplates = getAllPacks()
        .expand((pack) => pack.templates)
        .toList();
    
    if (query.isEmpty) return allTemplates;
    
    final lowerQuery = query.toLowerCase();
    return allTemplates.where((template) {
      return template.name.toLowerCase().contains(lowerQuery) ||
          template.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
