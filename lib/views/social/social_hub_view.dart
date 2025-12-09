import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/social_viewmodel.dart';
import 'social_feed_view.dart';
import 'leaderboard_view.dart';
import 'friends_view.dart';
import 'groups_view.dart';

class SocialHubView extends StatefulWidget {
  const SocialHubView({super.key});

  @override
  State<SocialHubView> createState() => _SocialHubViewState();
}

class _SocialHubViewState extends State<SocialHubView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Social',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).primaryColor,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(
              icon: Consumer<SocialViewModel>(
                builder: (context, socialVm, child) {
                  return Badge(
                    isLabelVisible: socialVm.pendingRequests.isNotEmpty,
                    label: Text('${socialVm.pendingRequests.length}'),
                    child: const Icon(Icons.people),
                  );
                },
              ),
              text: 'Friends',
            ),
            const Tab(icon: Icon(Icons.leaderboard), text: 'Leaderboard'),
            const Tab(icon: Icon(Icons.group), text: 'Groups'),
            const Tab(icon: Icon(Icons.feed), text: 'Feed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          FriendsView(),
          LeaderboardView(),
          GroupsView(),
          SocialFeedView(),
        ],
      ),
    );
  }
}
