import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modelview/analytics_viewmodel.dart';
class AnalyticsSummary extends StatelessWidget {
  const AnalyticsSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final analytics = context.watch<AnalyticsViewModel>();

    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            value: '${analytics.dayStreak}',
            label: 'Day streak',
          ),
        ),
        const SizedBox(width: 12),
         Expanded(
          child: _SummaryCard(
            value: '${analytics.monthlyStudyHours.toStringAsFixed(1)}h',
            label: 'This month',
          ),
        ),
        const SizedBox(width: 12),
         Expanded(
          child: _SummaryCard(
            value: '${analytics.goalsMet}%',
            label: 'Goals met',
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
     // height: 80,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.outlineVariant,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}