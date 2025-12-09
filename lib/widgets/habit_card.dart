import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../viewmodels/habit_viewmodel.dart';
import '../viewmodels/social_viewmodel.dart';
import '../views/habit/habit_history_view.dart';
import 'habit_completion_dialog.dart';
import 'freeze_indicator.dart';

class HabitCard extends StatefulWidget {
  final Habit habit;

  const HabitCard({super.key, required this.habit});

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getStreakColor() {
    if (widget.habit.streak >= 30) return Colors.purple;
    if (widget.habit.streak >= 14) return Colors.orange;
    if (widget.habit.streak >= 7) return Colors.green;
    return Colors.blue;
  }

  IconData _getStreakIcon() {
    if (widget.habit.streak >= 30) return Icons.emoji_events;
    if (widget.habit.streak >= 14) return Icons.local_fire_department;
    if (widget.habit.streak >= 7) return Icons.trending_up;
    return Icons.whatshot;
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HabitViewModel>(context, listen: false);
    final streakColor = _getStreakColor();

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: _isPressed ? 1 : 3,
        shadowColor: streakColor.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: streakColor.withOpacity(0.2), width: 2),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTapDown: (_) {
            setState(() => _isPressed = true);
            _controller.forward();
          },
          onTapUp: (_) {
            setState(() => _isPressed = false);
            _controller.reverse();
          },
          onTapCancel: () {
            setState(() => _isPressed = false);
            _controller.reverse();
          },
          onLongPress: () {
            _showOptionsBottomSheet(context, vm);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Streak indicator
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [streakColor, streakColor.withOpacity(0.6)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: streakColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${widget.habit.streak}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(_getStreakIcon(), color: Colors.white, size: 16),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Habit details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.habit.category.emoji,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.habit.name,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              _getStreakMessage(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          FreezeIndicator(habit: widget.habit),
                        ],
                      ),
                    ],
                  ),
                ),
                // History button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HabitHistoryView(habit: widget.habit),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.calendar_month,
                        color: Colors.grey[700],
                        size: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Complete button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () async {
                      // Show dialog to optionally add a note
                      final note = await showDialog<String>(
                        context: context,
                        builder: (context) =>
                            HabitCompletionDialog(habit: widget.habit),
                      );

                      // If null, user cancelled
                      if (note == null) return;

                      // Complete the habit with the note (empty string if skipped)
                      await vm.completeHabit(
                        widget.habit,
                        note: note.isEmpty ? null : note,
                      );

                      if (context.mounted) {
                        _showCompletionAnimation(context);
                        _checkMilestoneShare(context);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: streakColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: streakColor,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getStreakMessage() {
    if (widget.habit.streak == 0) return 'Start your streak today!';
    if (widget.habit.streak == 1) return '1 day streak';
    if (widget.habit.streak >= 30)
      return '${widget.habit.streak} days - Amazing!';
    if (widget.habit.streak >= 14)
      return '${widget.habit.streak} days - Great job!';
    if (widget.habit.streak >= 7)
      return '${widget.habit.streak} days - Keep it up!';
    return '${widget.habit.streak} days';
  }

  void _showCompletionAnimation(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.celebration, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '${widget.habit.name} completed! 🎉',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: _getStreakColor(),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _checkMilestoneShare(BuildContext context) {
    final newStreak = widget.habit.streak + 1;
    final milestones = [7, 30, 100, 365];

    if (milestones.contains(newStreak)) {
      Future.delayed(const Duration(seconds: 2), () {
        if (!context.mounted) return;

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(Icons.emoji_events, color: Theme.of(context).primaryColor),
                const SizedBox(width: 12),
                const Text('Milestone Reached!'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '🎉 $newStreak Day Streak! 🎉',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Would you like to share this achievement with your friends?',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Maybe Later'),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  final socialVm = Provider.of<SocialViewModel>(
                    context,
                    listen: false,
                  );
                  await socialVm.shareMilestone(
                    habitName: widget.habit.name,
                    streak: newStreak,
                  );

                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('🎉 Milestone shared with friends!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.share),
                label: const Text('Share'),
              ),
            ],
          ),
        );
      });
    }
  }

  void _showFreezeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => FreezeDialog(habit: widget.habit),
    );
  }

  void _showOptionsBottomSheet(BuildContext context, HabitViewModel vm) {
    final canFreeze = vm.canUseFreeze(widget.habit);
    final needsFreeze = vm.needsFreeze(widget.habit);

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

              // Freeze option
              if (canFreeze || needsFreeze)
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: needsFreeze
                          ? Colors.orange.withOpacity(0.1)
                          : Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.ac_unit,
                      color: needsFreeze
                          ? Colors.orange
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                  title: Text(
                    needsFreeze ? 'Use Streak Freeze' : 'Streak Freeze',
                  ),
                  subtitle: Text(
                    needsFreeze
                        ? 'Protect your streak - ${widget.habit.availableFreezes} available'
                        : '${widget.habit.availableFreezes} freeze(s) available',
                  ),
                  trailing: needsFreeze
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'At Risk',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : null,
                  onTap: () {
                    Navigator.pop(context);
                    _showFreezeDialog(this.context);
                  },
                ),

              // Delete option
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.delete_outline, color: Colors.red),
                ),
                title: const Text('Delete Habit'),
                subtitle: const Text('This action cannot be undone'),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteDialog(this.context, vm);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, HabitViewModel vm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.delete_outline, color: Colors.red),
            SizedBox(width: 12),
            Text('Delete Habit'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "${widget.habit.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              vm.deleteHabit(widget.habit.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.delete, color: Colors.white),
                      SizedBox(width: 12),
                      Text('Habit deleted'),
                    ],
                  ),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
