import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';
import '../models/accountability_group.dart';
import '../models/social_models.dart';
import 'dart:math';

class SocialService {
  String get userId => FirebaseAuth.instance.currentUser!.uid;

  // Collections
  CollectionReference get _usersRef =>
      FirebaseFirestore.instance.collection('users');
  CollectionReference get _groupsRef =>
      FirebaseFirestore.instance.collection('groups');
  CollectionReference get _postsRef =>
      FirebaseFirestore.instance.collection('posts');
  CollectionReference get _friendRequestsRef =>
      FirebaseFirestore.instance.collection('friendRequests');

  // ==================== User Profile ====================

  Future<void> createOrUpdateProfile(UserProfile profile) async {
    await _usersRef.doc(userId).set(profile.toMap(), SetOptions(merge: true));
  }

  Stream<UserProfile?> getUserProfile(String uid) {
    return _usersRef.doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserProfile.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    });
  }

  Future<UserProfile?> getUserProfileOnce(String uid) async {
    final doc = await _usersRef.doc(uid).get();
    if (!doc.exists) return null;
    return UserProfile.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

  Stream<UserProfile?> getMyProfile() {
    return getUserProfile(userId);
  }

  Future<void> updateProfileStats(
    int totalHabits,
    int totalStreak,
    int longestStreak,
  ) async {
    await _usersRef.doc(userId).update({
      'totalHabits': totalHabits,
      'totalStreak': totalStreak,
      'longestStreak': longestStreak,
    });
  }

  // ==================== Friends ====================

  Future<void> sendFriendRequest(String toUserId, String toUserName) async {
    final myProfile = await getUserProfileOnce(userId);
    if (myProfile == null) return;

    await _friendRequestsRef.add({
      'fromUserId': userId,
      'fromUserName': myProfile.displayName,
      'fromUserPhoto': myProfile.photoUrl,
      'toUserId': toUserId,
      'createdAt': DateTime.now().toIso8601String(),
      'status': 'pending',
    });
  }

  Future<void> acceptFriendRequest(String requestId, String fromUserId) async {
    // Update request status
    await _friendRequestsRef.doc(requestId).update({'status': 'accepted'});

    // Add to both users' friend lists
    await _usersRef.doc(userId).update({
      'friends': FieldValue.arrayUnion([fromUserId]),
    });
    await _usersRef.doc(fromUserId).update({
      'friends': FieldValue.arrayUnion([userId]),
    });
  }

  Future<void> rejectFriendRequest(String requestId) async {
    await _friendRequestsRef.doc(requestId).update({'status': 'rejected'});
  }

  Stream<List<FriendRequest>> getPendingFriendRequests() {
    return _friendRequestsRef
        .where('toUserId', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(
                (doc) => FriendRequest.fromMap(
                  doc.id,
                  doc.data() as Map<String, dynamic>,
                ),
              )
              .toList();
        });
  }

  Future<void> removeFriend(String friendId) async {
    await _usersRef.doc(userId).update({
      'friends': FieldValue.arrayRemove([friendId]),
    });
    await _usersRef.doc(friendId).update({
      'friends': FieldValue.arrayRemove([userId]),
    });
  }

  // ==================== Search ====================

  Future<List<UserProfile>> searchUsers(String query) async {
    if (query.isEmpty) return [];

    final snapshot = await _usersRef
        .where('displayName', isGreaterThanOrEqualTo: query)
        .where('displayName', isLessThanOrEqualTo: '$query\uf8ff')
        .limit(10)
        .get();

    return snapshot.docs
        .map(
          (doc) =>
              UserProfile.fromMap(doc.id, doc.data() as Map<String, dynamic>),
        )
        .where((profile) => profile.id != userId)
        .toList();
  }

  // ==================== Leaderboard ====================

  Future<List<UserProfile>> getFriendsLeaderboard() async {
    final myProfile = await getUserProfileOnce(userId);
    if (myProfile == null || myProfile.friends.isEmpty) return [];

    final friendIds = [...myProfile.friends, userId];
    final profiles = <UserProfile>[];

    // Fetch in batches of 10 (Firestore limit for 'in' queries)
    for (var i = 0; i < friendIds.length; i += 10) {
      final batch = friendIds.skip(i).take(10).toList();
      final snapshot = await _usersRef
          .where(FieldPath.documentId, whereIn: batch)
          .get();

      profiles.addAll(
        snapshot.docs.map(
          (doc) =>
              UserProfile.fromMap(doc.id, doc.data() as Map<String, dynamic>),
        ),
      );
    }

    // Sort by total streak
    profiles.sort((a, b) => b.totalStreak.compareTo(a.totalStreak));
    return profiles;
  }

  // ==================== Groups ====================

  Future<String> createGroup(AccountabilityGroup group) async {
    final docRef = await _groupsRef.add(group.toMap());

    // Add creator to group members
    await _usersRef.doc(userId).update({
      'groups': FieldValue.arrayUnion([docRef.id]),
    });

    return docRef.id;
  }

  Future<void> joinGroup(String groupId, String? inviteCode) async {
    final group = await getGroupOnce(groupId);
    if (group == null) throw Exception('Group not found');

    if (group.isPrivate && group.inviteCode != inviteCode) {
      throw Exception('Invalid invite code');
    }

    if (group.members.length >= group.maxMembers) {
      throw Exception('Group is full');
    }

    await _groupsRef.doc(groupId).update({
      'members': FieldValue.arrayUnion([userId]),
    });

    await _usersRef.doc(userId).update({
      'groups': FieldValue.arrayUnion([groupId]),
    });
  }

  Future<void> leaveGroup(String groupId) async {
    await _groupsRef.doc(groupId).update({
      'members': FieldValue.arrayRemove([userId]),
    });

    await _usersRef.doc(userId).update({
      'groups': FieldValue.arrayRemove([groupId]),
    });
  }

  Future<AccountabilityGroup?> getGroupOnce(String groupId) async {
    final doc = await _groupsRef.doc(groupId).get();
    if (!doc.exists) return null;
    return AccountabilityGroup.fromMap(
      doc.id,
      doc.data() as Map<String, dynamic>,
    );
  }

  Stream<List<AccountabilityGroup>> getMyGroups() async* {
    await for (final userSnapshot in _usersRef.doc(userId).snapshots()) {
      if (!userSnapshot.exists) {
        yield [];
        continue;
      }

      final userData = userSnapshot.data() as Map<String, dynamic>;
      final groupIds = List<String>.from(userData['groups'] ?? []);

      if (groupIds.isEmpty) {
        yield [];
        continue;
      }

      final groups = <AccountabilityGroup>[];
      for (var i = 0; i < groupIds.length; i += 10) {
        final batch = groupIds.skip(i).take(10).toList();
        final snapshot = await _groupsRef
            .where(FieldPath.documentId, whereIn: batch)
            .get();

        groups.addAll(
          snapshot.docs.map(
            (doc) => AccountabilityGroup.fromMap(
              doc.id,
              doc.data() as Map<String, dynamic>,
            ),
          ),
        );
      }

      yield groups;
    }
  }

  Future<List<AccountabilityGroup>> discoverGroups() async {
    final snapshot = await _groupsRef
        .where('isPrivate', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .limit(20)
        .get();

    return snapshot.docs
        .map(
          (doc) => AccountabilityGroup.fromMap(
            doc.id,
            doc.data() as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  String generateInviteCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random();
    return List.generate(
      6,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }

  // ==================== Posts & Sharing ====================

  Future<void> sharePost(SharePost post) async {
    await _postsRef.add(post.toMap());
  }

  Stream<List<SharePost>> getFriendsPosts() {
    return _usersRef.doc(userId).snapshots().asyncMap((userDoc) async {
      if (!userDoc.exists) return <SharePost>[];

      final userData = userDoc.data() as Map<String, dynamic>;
      final friendIds = List<String>.from(userData['friends'] ?? []);

      if (friendIds.isEmpty) return <SharePost>[];

      final allPosts = <SharePost>[];
      for (var i = 0; i < friendIds.length; i += 10) {
        final batch = friendIds.skip(i).take(10).toList();
        final snapshot = await _postsRef
            .where('userId', whereIn: batch)
            .where('groupId', isNull: true)
            .orderBy('createdAt', descending: true)
            .limit(50)
            .get();

        allPosts.addAll(
          snapshot.docs.map(
            (doc) =>
                SharePost.fromMap(doc.id, doc.data() as Map<String, dynamic>),
          ),
        );
      }

      allPosts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return allPosts.take(30).toList();
    });
  }

  Stream<List<SharePost>> getGroupPosts(String groupId) {
    return _postsRef
        .where('groupId', isEqualTo: groupId)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(
                (doc) => SharePost.fromMap(
                  doc.id,
                  doc.data() as Map<String, dynamic>,
                ),
              )
              .toList();
        });
  }

  Future<void> likePost(String postId) async {
    await _postsRef.doc(postId).update({
      'likes': FieldValue.arrayUnion([userId]),
    });
  }

  Future<void> unlikePost(String postId) async {
    await _postsRef.doc(postId).update({
      'likes': FieldValue.arrayRemove([userId]),
    });
  }

  // ==================== Milestone Sharing ====================

  Future<void> shareMilestone({
    required String habitName,
    required int streak,
    String? groupId,
  }) async {
    final myProfile = await getUserProfileOnce(userId);
    if (myProfile == null) return;

    String title = '';
    String emoji = '';
    if (streak == 7) {
      title = '7 Day Streak! 🔥';
      emoji = '🔥';
    } else if (streak == 30) {
      title = '30 Day Streak! 🏆';
      emoji = '🏆';
    } else if (streak == 100) {
      title = '100 Day Streak! 💯';
      emoji = '💯';
    } else if (streak == 365) {
      title = '1 Year Streak! 🎉';
      emoji = '🎉';
    } else {
      title = '$streak Day Streak! ✨';
      emoji = '✨';
    }

    final post = SharePost(
      id: '',
      userId: userId,
      userName: myProfile.displayName,
      userPhotoUrl: myProfile.photoUrl,
      type: ShareType.milestone,
      title: title,
      description: 'Just hit a $streak day streak on "$habitName"! $emoji',
      data: {'habitName': habitName, 'streak': streak, 'emoji': emoji},
      createdAt: DateTime.now(),
      groupId: groupId,
    );

    await sharePost(post);
  }
}
