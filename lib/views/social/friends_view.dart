import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/social_viewmodel.dart';
import '../../models/user_profile.dart';
import '../../models/social_models.dart';

class FriendsView extends StatefulWidget {
  const FriendsView({super.key});

  @override
  State<FriendsView> createState() => _FriendsViewState();
}

class _FriendsViewState extends State<FriendsView> {
  final TextEditingController _searchController = TextEditingController();
  List<UserProfile> _searchResults = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchUsers(String query, SocialViewModel socialVm) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);
    try {
      final results = await socialVm.searchUsers(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() => _isSearching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SocialViewModel>(
      builder: (context, socialVm, child) {
        final myProfile = socialVm.myProfile;
        final friends = myProfile?.friends ?? [];
        final pendingRequests = socialVm.pendingRequests;

        return Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search users...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _searchUsers('', socialVm);
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) => _searchUsers(value, socialVm),
              ),
            ),

            // Content
            Expanded(
              child: _searchController.text.isNotEmpty
                  ? _buildSearchResults(socialVm)
                  : _buildFriendsList(friends, pendingRequests, socialVm),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchResults(SocialViewModel socialVm) {
    if (_isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchResults.isEmpty) {
      return const Center(
        child: Text('No users found'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final user = _searchResults[index];
        final isFriend = socialVm.myProfile?.friends.contains(user.id) ?? false;

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                user.displayName.isNotEmpty
                    ? user.displayName[0].toUpperCase()
                    : '?',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(user.displayName),
            subtitle: Text('${user.totalStreak} total streak'),
            trailing: isFriend
                ? const Chip(
                    label: Text('Friends', style: TextStyle(fontSize: 11)),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                  )
                : ElevatedButton.icon(
                    onPressed: () async {
                      await socialVm.sendFriendRequest(
                          user.id, user.displayName);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Friend request sent!'),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.person_add, size: 16),
                    label: const Text('Add'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildFriendsList(
    List<String> friends,
    List<FriendRequest> pendingRequests,
    SocialViewModel socialVm,
  ) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        // Pending requests
        if (pendingRequests.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Friend Requests',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          ...pendingRequests.map((request) =>
              _buildFriendRequestCard(request, socialVm)),
          const SizedBox(height: 16),
        ],

        // Friends list
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'My Friends (${friends.length})',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ),
        if (friends.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'No friends yet. Search above to add friends!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          )
        else
          ...friends.map((friendId) => _buildFriendCard(friendId, socialVm)),
      ],
    );
  }

  Widget _buildFriendRequestCard(
      FriendRequest request, SocialViewModel socialVm) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: Theme.of(context).primaryColor.withOpacity(0.05),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            request.fromUserName.isNotEmpty
                ? request.fromUserName[0].toUpperCase()
                : '?',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(request.fromUserName),
        subtitle: const Text('wants to be friends'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: () async {
                await socialVm.acceptFriendRequest(request);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Friend request accepted!')),
                  );
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () async {
                await socialVm.rejectFriendRequest(request.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendCard(String friendId, SocialViewModel socialVm) {
    return FutureBuilder<UserProfile?>(
      future: socialVm.socialService.getUserProfileOnce(friendId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final friend = snapshot.data!;
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                friend.displayName.isNotEmpty
                    ? friend.displayName[0].toUpperCase()
                    : '?',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(friend.displayName),
            subtitle: Text(
              '${friend.totalStreak} streak • ${friend.totalHabits} habits',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                _showFriendOptions(context, friend, socialVm);
              },
            ),
          ),
        );
      },
    );
  }

  void _showFriendOptions(
      BuildContext context, UserProfile friend, SocialViewModel socialVm) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.person_remove, color: Colors.red),
                title: const Text('Remove Friend'),
                onTap: () async {
                  Navigator.pop(context);
                  await socialVm.removeFriend(friend.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Removed ${friend.displayName}')),
                    );
                  }
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
