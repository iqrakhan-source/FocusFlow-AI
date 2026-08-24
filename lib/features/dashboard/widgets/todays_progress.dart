import 'package:flutter/material.dart';

import '../../../shared/widgets/app_card.dart';

class TodayProgressCard extends StatelessWidget {
  const TodayProgressCard({
    super.key,
    required this.goalHours,
    required this.completedHours,
    required this.remainingHours,
  });

  final double goalHours;
  final double completedHours;
  final double remainingHours;

  @override
  Widget build(BuildContext context) {
    final progress = goalHours == 0
        ? 0.0
        : (completedHours / goalHours).clamp(0.0, 1.0);

    final percentage = (progress * 100).round();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's Progress",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                '$percentage%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _ProgressValue(
                  value: '${_formatHours(goalHours)}h',
                  label: 'Goal',
                ),
              ),
              Expanded(
                child: _ProgressValue(
                  value: '${_formatHours(completedHours)}h',
                  label: 'Completed',
                ),
              ),
              Expanded(
                child: _ProgressValue(
                  value: '${_formatHours(remainingHours)}h',
                  label: 'Remaining',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatHours(double hours) {
    return hours % 1 == 0
        ? hours.toInt().toString()
        : hours.toString();
  }
}

class _ProgressValue extends StatelessWidget {
  const _ProgressValue({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}