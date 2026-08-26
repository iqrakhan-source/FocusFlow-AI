import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modelview/analytics_viewmodel.dart';

class SubjectDistributionCard extends StatelessWidget {
  const SubjectDistributionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final distribution =
        context.watch<AnalyticsViewModel>().subjectDistribution;

    if (distribution.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
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
              'Subject distribution',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'No study data yet.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final totalMinutes = distribution.values.fold<double>(
      0,
          (sum, value) => sum + value,
    );

    final subjects = distribution.entries.toList();

    final subjectColors = [
      const Color(0xFF5B4BCF),
      const Color(0xFF38B887),
      const Color(0xFFF4B547),
      Colors.grey,
    ];

    final percentages = subjects.map((entry) {
      return (entry.value / totalMinutes) * 100;
    }).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
            'Subject distribution',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: CustomPaint(
                  painter: _DonutPainter(
                    segments: percentages,
                    colors: List.generate(
                      subjects.length,
                          (index) => subjectColors[
                      index % subjectColors.length],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 24),

              Expanded(
                child: Column(
                  children: List.generate(
                    subjects.length,
                        (index) {
                      final subject =
                          subjects[index].key;

                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index ==
                              subjects.length - 1
                              ? 0
                              : 12,
                        ),
                        child: _SubjectRow(
                          subject: subject,
                          percentage:
                          '${percentages[index].round()}%',
                          color: subjectColors[
                          index %
                              subjectColors.length],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SubjectRow extends StatelessWidget {
  const _SubjectRow({
    required this.subject,
    required this.percentage,
    required this.color,
  });

  final String subject;
  final String percentage;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            subject,
            style: Theme.of(context)
                .textTheme
                .bodyMedium,
          ),
        ),

        Text(
          percentage,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(
            color: colors.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({
    required this.segments,
    required this.colors,
  });

  final List<double> segments;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius = size.width / 2;
    const strokeWidth = 24.0;

    final rect = Rect.fromCircle(
      center: center,
      radius: radius - strokeWidth / 2,
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    double startAngle = -math.pi / 2;

    for (int i = 0; i < segments.length; i++) {
      final sweepAngle =
          (segments[i] / 100) * 2 * math.pi;

      paint.color = colors[i];

      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(
      covariant _DonutPainter oldDelegate,
      ) {
    return oldDelegate.segments != segments ||
        oldDelegate.colors != colors;
  }
}