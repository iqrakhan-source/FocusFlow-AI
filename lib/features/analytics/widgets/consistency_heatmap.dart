import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modelview/analytics_viewmodel.dart';
class ConsistencyHeatmap extends StatelessWidget {
  const ConsistencyHeatmap({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final analytics = context.watch<AnalyticsViewModel>();
    final data = analytics.consistencyData;
    // 5 weeks × 7 days.
    // 0 = no study
    // 1 = low
    // 2 = medium
    // 3 = high

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        16,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Consistency heatmap',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 16),

          Column(
            children: [
              for (final week in data)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      for (final intensity in week)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 2,
                            ),
                            child: _HeatmapCell(
                              intensity: intensity,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 2),

          Text(
            'Darker means more focused hours.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeatmapCell extends StatelessWidget {
  const _HeatmapCell({
    required this.intensity,
  });

  final int intensity;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final Color background;

    switch (intensity) {
      case 1:
        background = colors.primary.withValues(alpha: 0.25);
        break;

      case 2:
        background = colors.primary.withValues(alpha: 0.50);
        break;

      case 3:
        background = colors.primary;
        break;

      default:
        background = colors.surfaceContainerHighest;
    }

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}