import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a single completion event for a habit
class HabitCompletion {
  final String id;
  final String habitId;
  final DateTime completedAt;
  final String? note;

  HabitCompletion({
    required this.id,
    required this.habitId,
    required this.completedAt,
    this.note,
  });

  // Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'habitId': habitId,
      'completedAt': Timestamp.fromDate(completedAt),
      'note': note,
    };
  }

  // Create from Firestore document
  factory HabitCompletion.fromMap(String id, Map<String, dynamic> map) {
    return HabitCompletion(
      id: id,
      habitId: map['habitId'] as String,
      completedAt: (map['completedAt'] as Timestamp).toDate(),
      note: map['note'] as String?,
    );
  }

  // Convert to JSON for local storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'habitId': habitId,
      'completedAt': completedAt.toIso8601String(),
      'note': note,
    };
  }

  // Create from JSON
  factory HabitCompletion.fromJson(Map<String, dynamic> json) {
    return HabitCompletion(
      id: json['id'] as String,
      habitId: json['habitId'] as String,
      completedAt: DateTime.parse(json['completedAt'] as String),
      note: json['note'] as String?,
    );
  }

  /// Check if this completion is for a specific date (ignoring time)
  bool isForDate(DateTime date) {
    return completedAt.year == date.year &&
        completedAt.month == date.month &&
        completedAt.day == date.day;
  }

  /// Check if this completion is for today
  bool isToday() {
    final now = DateTime.now();
    return isForDate(now);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitCompletion &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
