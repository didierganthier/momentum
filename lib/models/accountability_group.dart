class AccountabilityGroup {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final String createdBy;
  final List<String> members;
  final List<String> admins;
  final DateTime createdAt;
  final bool isPrivate;
  final String? inviteCode;
  final int maxMembers;

  AccountabilityGroup({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.createdBy,
    this.members = const [],
    this.admins = const [],
    required this.createdAt,
    this.isPrivate = false,
    this.inviteCode,
    this.maxMembers = 50,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'createdBy': createdBy,
      'members': members,
      'admins': admins,
      'createdAt': createdAt.toIso8601String(),
      'isPrivate': isPrivate,
      'inviteCode': inviteCode,
      'maxMembers': maxMembers,
    };
  }

  factory AccountabilityGroup.fromMap(String id, Map<String, dynamic> map) {
    return AccountabilityGroup(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'],
      createdBy: map['createdBy'] ?? '',
      members: List<String>.from(map['members'] ?? []),
      admins: List<String>.from(map['admins'] ?? []),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      isPrivate: map['isPrivate'] ?? false,
      inviteCode: map['inviteCode'],
      maxMembers: map['maxMembers'] ?? 50,
    );
  }
}
