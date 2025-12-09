import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/habit.dart';
import '../models/habit_category.dart';

class HabitService {
  String get userId => FirebaseAuth.instance.currentUser!.uid;

  CollectionReference get _habitRef => FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('habits');

  Stream<List<Habit>> getHabits() {
    return _habitRef.snapshots().map((snapshot) {
      return snapshot.docs
          .map(
            (doc) => Habit.fromMap(doc.id, doc.data() as Map<String, dynamic>),
          )
          .toList();
    });
  }

  Future<void> createHabit(String name, HabitCategory category) async {
    await _habitRef.add({
      'name': name,
      'streak': 0,
      'lastCompleted': null,
      'category': category.name,
    });
  }

  Future<void> createHabitWithData(
    String name,
    int streak,
    DateTime? lastCompleted,
    HabitCategory category,
  ) async {
    await _habitRef.add({
      'name': name,
      'streak': streak,
      'lastCompleted': lastCompleted?.toIso8601String(),
      'category': category.name,
    });
  }

  Future<void> completeHabit(Habit habit) async {
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
  }

  Future<void> deleteHabit(String id) async {
    await _habitRef.doc(id).delete();
  }
}
