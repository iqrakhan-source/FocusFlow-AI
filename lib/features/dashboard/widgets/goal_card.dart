import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class GoalCard extends StatelessWidget {
  const GoalCard({
    super.key,
    required this.goalMinutes,
    required this.completedMinutes,
    required this.onTap,
  });

  final int goalMinutes;
  final int completedMinutes;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final progress = goalMinutes == 0
        ? 0.0
        : (completedMinutes / goalMinutes).clamp(0.0, 1.0);

    final remainingMinutes =
    (goalMinutes - completedMinutes).clamp(0, goalMinutes);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Today's Goal",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: AppColors.mutedForeground,)
                ],
              ),

              const SizedBox(height: 20),

              Text(
                '${completedMinutes ~/ 60}h ${completedMinutes % 60}m',
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const SizedBox(height: 4),

              Text(
                'of ${goalMinutes ~/ 60}h ${goalMinutes % 60}m goal',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 16),

              LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                borderRadius: BorderRadius.circular(8),
                backgroundColor: AppColors.primarySoft,
                color: AppColors.primary,
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(progress * 100).round()}% completed',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '$remainingMinutes min remaining',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}