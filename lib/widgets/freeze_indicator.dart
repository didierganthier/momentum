import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../viewmodels/habit_viewmodel.dart';

class FreezeIndicator extends StatelessWidget {
  final Habit habit;

  const FreezeIndicator({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HabitViewModel>(context, listen: false);
    final insights = vm.getFreezeInsights(habit);
    final canUse = insights['canUse'] as bool;
    final needsIt = insights['needsFreeze'] as bool;
    final available = insights['availableFreezes'] as int;

    // Don't show if no freezes available and not needed
    if (!canUse && !needsIt) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: needsIt
            ? Colors.orange.withOpacity(0.1)
            : Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            needsIt ? Icons.warning_amber : Icons.ac_unit,
            size: 14,
            color: needsIt ? Colors.orange : Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 4),
          Text(
            '$available',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: needsIt ? Colors.orange : Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class FreezeDialog extends StatelessWidget {
  final Habit habit;

  const FreezeDialog({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HabitViewModel>(context, listen: false);
    final insights = vm.getFreezeInsights(habit);
    final message = insights['message'] as String;
    final canUse = insights['canUse'] as bool;
    final needsIt = insights['needsFreeze'] as bool;
    final daysUntilReset = insights['daysUntilReset'] as int;
    final freezeUsedCount = insights['freezeUsedCount'] as int;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.ac_unit,
                size: 48,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),

            // Title
            const Text(
              'Streak Freeze',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),

            // Info cards
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    context,
                    'Available',
                    '${habit.availableFreezes}',
                    Icons.ac_unit,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInfoCard(
                    context,
                    'Used This Week',
                    '$freezeUsedCount',
                    Icons.check_circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              context,
              'Next Reset',
              '$daysUntilReset day${daysUntilReset != 1 ? 's' : ''}',
              Icons.refresh,
              fullWidth: true,
            ),
            const SizedBox(height: 24),

            // How it works
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 18,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'How Freezes Work',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Get 1 freeze per week (resets Monday)\n'
                    '• Use it to protect your streak if you miss a day\n'
                    '• Your streak stays intact when frozen\n'
                    '• Learn from breaks without losing progress',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Actions
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: canUse && needsIt
                        ? () async {
                            try {
                              await vm.useFreeze(habit);
                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      '❄️ Freeze used! Your streak is protected.',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: ${e.toString()}'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Use Freeze'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    bool fullWidth = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: Theme.of(context).primaryColor),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: fullWidth ? 18 : 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
