class UserProfile {
  final String id;
  final String displayName;
  final String? photoUrl;
  final String? bio;
  final int totalHabits;
  final int totalStreak;
  final int longestStreak;
  final List<String> friends;
  final List<String> groups;
  final DateTime createdAt;
  final bool isPublic; // Public profile visibility

  UserProfile({
    required this.id,
    required this.displayName,
    this.photoUrl,
    this.bio,
    this.totalHabits = 0,
    this.totalStreak = 0,
    this.longestStreak = 0,
    this.friends = const [],
    this.groups = const [],
    required this.createdAt,
    this.isPublic = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'photoUrl': photoUrl,
      'bio': bio,
      'totalHabits': totalHabits,
      'totalStreak': totalStreak,
      'longestStreak': longestStreak,
      'friends': friends,
      'groups': groups,
      'createdAt': createdAt.toIso8601String(),
      'isPublic': isPublic,
    };
  }

  factory UserProfile.fromMap(String id, Map<String, dynamic> map) {
    return UserProfile(
      id: id,
      displayName: map['displayName'] ?? '',
      photoUrl: map['photoUrl'],
      bio: map['bio'],
      totalHabits: map['totalHabits'] ?? 0,
      totalStreak: map['totalStreak'] ?? 0,
      longestStreak: map['longestStreak'] ?? 0,
      friends: List<String>.from(map['friends'] ?? []),
      groups: List<String>.from(map['groups'] ?? []),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      isPublic: map['isPublic'] ?? true,
    );
  }

  UserProfile copyWith({
    String? displayName,
    String? photoUrl,
    String? bio,
    int? totalHabits,
    int? totalStreak,
    int? longestStreak,
    List<String>? friends,
    List<String>? groups,
    bool? isPublic,
  }) {
    return UserProfile(
      id: id,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      totalHabits: totalHabits ?? this.totalHabits,
      totalStreak: totalStreak ?? this.totalStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      friends: friends ?? this.friends,
      groups: groups ?? this.groups,
      createdAt: createdAt,
      isPublic: isPublic ?? this.isPublic,
    );
  }
}
