import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../models/habit_category.dart';
import '../models/habit_completion.dart';

class HabitService {
  String get userId => FirebaseAuth.instance.currentUser!.uid;

  CollectionReference get _habitRef => FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('habits');

  CollectionReference get _completionsRef => FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('completions');

  Stream<List<Habit>> getHabits() {
    return _habitRef.snapshots().map((snapshot) {
      return snapshot.docs
          .map(
            (doc) => Habit.fromMap(doc.id, doc.data() as Map<String, dynamic>),
          )
          .toList();
    });
  }

  Future<void> createHabit(
    String name,
    HabitCategory category, {
    TimeOfDay? reminderTime,
  }) async {
    await _habitRef.add({
      'name': name,
      'streak': 0,
      'lastCompleted': null,
      'category': category.name,
      'reminderTime': reminderTime != null
          ? '${reminderTime.hour}:${reminderTime.minute}'
          : null,
    });
  }

  Future<void> createHabitWithData(
    String name,
    int streak,
    DateTime? lastCompleted,
    HabitCategory category, {
    TimeOfDay? reminderTime,
  }) async {
    await _habitRef.add({
      'name': name,
      'streak': streak,
      'lastCompleted': lastCompleted?.toIso8601String(),
      'category': category.name,
      'reminderTime': reminderTime != null
          ? '${reminderTime.hour}:${reminderTime.minute}'
          : null,
    });
  }

  Future<void> completeHabit(Habit habit, {String? note}) async {
    final now = DateTime.now();
    final last = habit.lastCompleted;

    int newStreak = habit.streak;

    if (last == null) {
      newStreak = 1;
    } else {
      final diff = now.difference(last).inDays;

      if (diff == 1) {
        newStreak += 1;
      } else if (diff > 1) {
        newStreak = 1;
      }
    }

    await _habitRef.doc(habit.id).update({
      'streak': newStreak,
      'lastCompleted': now.toIso8601String(),
    });

    // Add completion record
    await _completionsRef.add({
      'habitId': habit.id,
      'completedAt': Timestamp.fromDate(now),
      'note': note,
    });
  }

  Future<void> deleteHabit(String id) async {
    await _habitRef.doc(id).delete();
    // Also delete all completions for this habit
    final completions = await _completionsRef
        .where('habitId', isEqualTo: id)
        .get();
    for (var doc in completions.docs) {
      await doc.reference.delete();
    }
  }

  // Completion tracking methods
  Stream<List<HabitCompletion>> getCompletions(String habitId) {
    return _completionsRef
        .where('habitId', isEqualTo: habitId)
        .orderBy('completedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              HabitCompletion.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<List<HabitCompletion>> getCompletionsList(String habitId) async {
    final snapshot = await _completionsRef
        .where('habitId', isEqualTo: habitId)
        .orderBy('completedAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) =>
            HabitCompletion.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }
}
