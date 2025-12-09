class Habit {
  final String id;
  final String name;
  final int streak;
  final DateTime? lastCompleted;

  Habit({
    required this.id,
    required this.name,
    required this.streak,
    required this.lastCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'streak': streak,
      'lastCompleted': lastCompleted?.toIso8601String(),
    };
  }

  factory Habit.fromMap(String id, Map<String, dynamic> map) {
    return Habit(
      id: id,
      name: map['name'],
      streak: map['streak'] ?? 0,
      lastCompleted: map['lastCompleted'] != null
          ? DateTime.parse(map['lastCompleted'])
          : null,
    );
  }
}
