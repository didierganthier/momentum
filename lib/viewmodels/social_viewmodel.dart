import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../models/accountability_group.dart';
import '../models/social_models.dart';
import '../services/social_service.dart';

class SocialViewModel extends ChangeNotifier {
  final SocialService _socialService = SocialService();

  // Expose service for friend profile lookup
  SocialService get socialService => _socialService;

  UserProfile? _myProfile;
  List<UserProfile> _leaderboard = [];
  List<AccountabilityGroup> _myGroups = [];
  List<FriendRequest> _pendingRequests = [];
  List<SharePost> _feed = [];
  bool _isLoading = false;

  UserProfile? get myProfile => _myProfile;
  List<UserProfile> get leaderboard => _leaderboard;
  List<AccountabilityGroup> get myGroups => _myGroups;
  List<FriendRequest> get pendingRequests => _pendingRequests;
  List<SharePost> get feed => _feed;
  bool get isLoading => _isLoading;

  void initialize() {
    _listenToProfile();
    _listenToGroups();
    _listenToFriendRequests();
    _listenToFeed();
  }

  void _listenToProfile() {
    _socialService.getMyProfile().listen((profile) {
      _myProfile = profile;
      notifyListeners();
      if (profile != null) {
        _loadLeaderboard();
      }
    });
  }

  void _listenToGroups() {
    _socialService.getMyGroups().listen((groups) {
      _myGroups = groups;
      notifyListeners();
    });
  }

  void _listenToFriendRequests() {
    _socialService.getPendingFriendRequests().listen((requests) {
      _pendingRequests = requests;
      notifyListeners();
    });
  }

  void _listenToFeed() {
    _socialService.getFriendsPosts().listen((posts) {
      _feed = posts;
      notifyListeners();
    });
  }

  Future<void> _loadLeaderboard() async {
    try {
      _leaderboard = await _socialService.getFriendsLeaderboard();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading leaderboard: $e');
    }
  }

  // Profile methods
  Future<void> updateProfile(UserProfile profile) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _socialService.createOrUpdateProfile(profile);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateStats(
    int totalHabits,
    int totalStreak,
    int longestStreak,
  ) async {
    await _socialService.updateProfileStats(
      totalHabits,
      totalStreak,
      longestStreak,
    );
  }

  // Friend methods
  Future<void> sendFriendRequest(String toUserId, String toUserName) async {
    await _socialService.sendFriendRequest(toUserId, toUserName);
  }

  Future<void> acceptFriendRequest(FriendRequest request) async {
    await _socialService.acceptFriendRequest(request.id, request.fromUserId);
    await _loadLeaderboard();
  }

  Future<void> rejectFriendRequest(String requestId) async {
    await _socialService.rejectFriendRequest(requestId);
  }

  Future<void> removeFriend(String friendId) async {
    await _socialService.removeFriend(friendId);
    await _loadLeaderboard();
  }

  Future<List<UserProfile>> searchUsers(String query) async {
    return await _socialService.searchUsers(query);
  }

  // Group methods
  Future<String> createGroup(AccountabilityGroup group) async {
    return await _socialService.createGroup(group);
  }

  Future<void> joinGroup(String groupId, String? inviteCode) async {
    await _socialService.joinGroup(groupId, inviteCode);
  }

  Future<void> leaveGroup(String groupId) async {
    await _socialService.leaveGroup(groupId);
  }

  Future<List<AccountabilityGroup>> discoverGroups() async {
    return await _socialService.discoverGroups();
  }

  Stream<List<SharePost>> getGroupPosts(String groupId) {
    return _socialService.getGroupPosts(groupId);
  }

  String generateInviteCode() {
    return _socialService.generateInviteCode();
  }

  // Post methods
  Future<void> sharePost(SharePost post) async {
    await _socialService.sharePost(post);
  }

  Future<void> likePost(String postId) async {
    await _socialService.likePost(postId);
  }

  Future<void> unlikePost(String postId) async {
    await _socialService.unlikePost(postId);
  }

  Future<void> shareMilestone({
    required String habitName,
    required int streak,
    String? groupId,
  }) async {
    await _socialService.shareMilestone(
      habitName: habitName,
      streak: streak,
      groupId: groupId,
    );
  }
}
