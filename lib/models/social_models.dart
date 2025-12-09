enum ShareType { milestone, achievement, streak, completion }

class SharePost {
  final String id;
  final String userId;
  final String userName;
  final String? userPhotoUrl;
  final ShareType type;
  final String title;
  final String description;
  final Map<String, dynamic> data; // Flexible data for different share types
  final DateTime createdAt;
  final List<String> likes;
  final int commentCount;
  final String? groupId; // If shared to a specific group

  SharePost({
    required this.id,
    required this.userId,
    required this.userName,
    this.userPhotoUrl,
    required this.type,
    required this.title,
    required this.description,
    this.data = const {},
    required this.createdAt,
    this.likes = const [],
    this.commentCount = 0,
    this.groupId,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
      'type': type.name,
      'title': title,
      'description': description,
      'data': data,
      'createdAt': createdAt.toIso8601String(),
      'likes': likes,
      'commentCount': commentCount,
      'groupId': groupId,
    };
  }

  factory SharePost.fromMap(String id, Map<String, dynamic> map) {
    return SharePost(
      id: id,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userPhotoUrl: map['userPhotoUrl'],
      type: ShareType.values.firstWhere(
        (t) => t.name == map['type'],
        orElse: () => ShareType.completion,
      ),
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      data: Map<String, dynamic>.from(map['data'] ?? {}),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      likes: List<String>.from(map['likes'] ?? []),
      commentCount: map['commentCount'] ?? 0,
      groupId: map['groupId'],
    );
  }

  bool isLikedBy(String userId) => likes.contains(userId);
}

class FriendRequest {
  final String id;
  final String fromUserId;
  final String fromUserName;
  final String? fromUserPhoto;
  final String toUserId;
  final DateTime createdAt;
  final String status; // pending, accepted, rejected

  FriendRequest({
    required this.id,
    required this.fromUserId,
    required this.fromUserName,
    this.fromUserPhoto,
    required this.toUserId,
    required this.createdAt,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'fromUserId': fromUserId,
      'fromUserName': fromUserName,
      'fromUserPhoto': fromUserPhoto,
      'toUserId': toUserId,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }

  factory FriendRequest.fromMap(String id, Map<String, dynamic> map) {
    return FriendRequest(
      id: id,
      fromUserId: map['fromUserId'] ?? '',
      fromUserName: map['fromUserName'] ?? '',
      fromUserPhoto: map['fromUserPhoto'],
      toUserId: map['toUserId'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      status: map['status'] ?? 'pending',
    );
  }
}
