import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modelview/analytics_viewmodel.dart';
class WeeklyStudyCard extends StatelessWidget {
  const WeeklyStudyCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final weeklyHours =
        context.watch<AnalyticsViewModel>().weeklyStudyHours;
    const days = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        18,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colors.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly study hours',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 28),

          SizedBox(
            height: 145,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                weeklyHours.length,
                    (index) {
                  return _StudyBar(
                    value: weeklyHours[index],
                    label: days[index],
                    maxValue: 6,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StudyBar extends StatelessWidget {
  const _StudyBar({
    required this.value,
    required this.label,
    required this.maxValue,
  });

  final double value;
  final String label;
  final double maxValue;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final barHeight = (value / maxValue) * 90;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 18,
          height: barHeight,
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        const SizedBox(height: 7),

        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: colors.onSurfaceVariant,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}