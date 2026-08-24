import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modelview/analytics_viewmodel.dart';
class FocusTrendCard extends StatelessWidget {
  const FocusTrendCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final analytics = context.watch<AnalyticsViewModel>();
    final focusTrend = analytics.focusTrend;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        14,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Focus trend',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 130,
            width: double.infinity,
            child:CustomPaint(
              painter: _FocusTrendPainter(
                lineColor: colors.secondary,
                values: focusTrend,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FocusTrendPainter extends CustomPainter {
_FocusTrendPainter({
  required this.lineColor,
  required this.values,
});

final Color lineColor;
final List<double> values;
  @override
  void paint(Canvas canvas, Size size) {
    const bottomPadding = 22.0;
    const topPadding = 8.0;

    final chartHeight =
        size.height - topPadding - bottomPadding;

    final chartWidth = size.width;

    final points = <Offset>[];

    for (int i = 0; i < values.length; i++) {
      final x = chartWidth *
          i /
          (values.length - 1);

      final normalized =
          (values[i] - 50) / 40;

      final y = topPadding +
          chartHeight -
          normalized.clamp(0.0, 1.0) *
              chartHeight;

      points.add(Offset(x, y));
    }

    // Filled area
    final areaPath = Path();

    areaPath.moveTo(
      points.first.dx,
      size.height - bottomPadding,
    );

    areaPath.lineTo(
      points.first.dx,
      points.first.dy,
    );

    for (int i = 1; i < points.length; i++) {
      areaPath.lineTo(
        points[i].dx,
        points[i].dy,
      );
    }

    areaPath.lineTo(
      points.last.dx,
      size.height - bottomPadding,
    );

    areaPath.close();

    final areaPaint = Paint()
      ..color = lineColor.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    canvas.drawPath(
      areaPath,
      areaPaint,
    );

    // Green line
    final linePath = Path();

    linePath.moveTo(
      points.first.dx,
      points.first.dy,
    );

    for (int i = 1; i < points.length; i++) {
      linePath.lineTo(
        points[i].dx,
        points[i].dy,
      );
    }

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;

    canvas.drawPath(
      linePath,
      linePaint,
    );

    // Bottom labels
    const labels = ['W1', 'W2', 'W3', 'W4'];

    final textStyle = TextStyle(
      color: lineColor.withValues(alpha: 0.85),
      fontSize: 10,
    );

    for (int i = 0; i < labels.length; i++) {
      final x = chartWidth *
          i /
          (labels.length - 1);

      final textPainter = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset(
          x - textPainter.width / 2,
          size.height - 16,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(
      covariant _FocusTrendPainter oldDelegate,
      ) {
    return oldDelegate.lineColor != lineColor;
  }
}