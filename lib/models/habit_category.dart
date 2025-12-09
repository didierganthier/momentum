enum HabitCategory {
  health('Health & Fitness', '💪'),
  productivity('Productivity', '📊'),
  learning('Learning', '📚'),
  mindfulness('Mindfulness', '🧘'),
  social('Social', '👥'),
  finance('Finance', '💰'),
  creativity('Creativity', '🎨'),
  other('Other', '⭐');

  final String label;
  final String emoji;

  const HabitCategory(this.label, this.emoji);

  String get displayName => '$emoji $label';
}
