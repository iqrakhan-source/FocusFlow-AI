import 'package:flutter/material.dart';

import '../model/calendar_event_model.dart';

class WeekCalendar extends StatelessWidget {
  const WeekCalendar({
    super.key,
    required this.events,
  });

  final List<CalendarEventModel> events;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final now = DateTime.now();

    // Monday of the current week.
    final monday = now.subtract(
      Duration(days: now.weekday - 1),
    );

    final weekDays = List.generate(
      7,
          (index) => DateTime(
        monday.year,
        monday.month,
        monday.day + index,
      ),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        12,
        18,
        12,
        20,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colors.outlineVariant,
        ),
      ),
      child: Column(
        children: [
          // WEEK DAYS
          Row(
            children: weekDays.map((date) {
              final isToday =
                  date.year == now.year &&
                      date.month == now.month &&
                      date.day == now.day;

              return Expanded(
                child: Column(
                  children: [
                    Text(
                      _weekdayName(date.weekday),
                      style:
                      theme.textTheme.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isToday
                            ? colors.primary
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${date.day}',
                        style:
                        theme.textTheme.bodyMedium?.copyWith(
                          color: isToday
                              ? colors.onPrimary
                              : colors.onSurface,
                          fontWeight: isToday
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    _EventDots(
                      events: _eventsForDate(date),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  List<CalendarEventModel> _eventsForDate(
    DateTime date,
  ) {
    return events.where((event) {
      final eDate = event.date.toLocal();
      return eDate.year == date.year &&
          eDate.month == date.month &&
          eDate.day == date.day;
    }).toList();
  }

  String _weekdayName(int weekday) {
    const names = [
      'M',
      'T',
      'W',
      'T',
      'F',
      'S',
      'S',
    ];

    return names[weekday - 1];
  }
}

class _EventDots extends StatelessWidget {
  const _EventDots({
    required this.events,
  });

  final List<CalendarEventModel> events;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: events.take(4).map((event) {
        Color color;

        switch (event.eventType) {
          case 'study':
            color = colors.primary;
            break;

          case 'assignment':
            color = colors.secondary;
            break;

          case 'exam':
            color = const Color(0xFFF2994A);
            break;

          case 'missed_goal':
            color = colors.error;
            break;

          default:
            color = colors.primary;
        }

        return Container(
          width: 5,
          height: 5,
          margin: const EdgeInsets.symmetric(
            horizontal: 1.5,
          ),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        );
      }).toList(),
    );
  }
}