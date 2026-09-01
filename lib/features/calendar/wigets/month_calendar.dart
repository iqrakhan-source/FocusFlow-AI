import 'package:flutter/material.dart';

import '../model/calendar_event_model.dart';

class MonthCalendar extends StatelessWidget {
  const MonthCalendar({
    super.key,
    required this.events,
  });

  final List<CalendarEventModel> events;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final now = DateTime.now();

    final year = now.year;
    final month = now.month;

    // First day of the current month.
    final firstDay = DateTime(year, month, 1);

    // Number of days in the current month.
    final daysInMonth = DateTime(year, month + 1, 0).day;

    // Monday = 1 ... Sunday = 7
    final startingOffset = firstDay.weekday - 1;

    // Dynamically generate calendar days.
    final days = <int?>[
      ...List<int?>.filled(
        startingOffset,
        null,
      ),
      ...List.generate(
        daysInMonth,
            (index) => index + 1,
      ),
    ];

    const weekdays = [
      'M',
      'T',
      'W',
      'T',
      'F',
      'S',
      'S',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        16,
        18,
        16,
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
          // WEEKDAYS
          Row(
            children: weekdays.map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colors.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 12),

          // DAYS
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: days.length,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisExtent: 48,
            ),
            itemBuilder: (context, index) {
              final day = days[index];

              // Empty cells before the first day.
              if (day == null) {
                return const SizedBox();
              }

              final date = DateTime(
                year,
                month,
                day,
              );

              final isToday =
                  date.year == now.year &&
                      date.month == now.month &&
                      date.day == now.day;

              final eventColors = _eventColorsForDate(
                context,
                date,
              );

              return _CalendarDay(
                day: day,
                isSelected: isToday,
                eventColors: eventColors,
              );
            },
          ),
        ],
      ),
    );
  }

  List<Color> _eventColorsForDate(
      BuildContext context,
      DateTime date,
      ) {
    final colors = Theme.of(context).colorScheme;

    final dayEvents = events.where((event) {
      return event.date.year == date.year &&
          event.date.month == date.month &&
          event.date.day == date.day;
    }).toList();

    return dayEvents.map((event) {
      switch (event.eventType) {
        case 'study':
          return colors.primary;

        case 'assignment':
          return colors.secondary;

        case 'exam':
          return colors.error;

        case 'missed_goal':
          return const Color(0xFFF2994A);

        default:
          return colors.primary;
      }
    }).toList();
  }
}

class _CalendarDay extends StatelessWidget {
  const _CalendarDay({
    required this.day,
    required this.isSelected,
    required this.eventColors,
  });

  final int day;
  final bool isSelected;
  final List<Color> eventColors;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 44,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? colors.primary
                : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Text(
            '$day',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isSelected
                  ? colors.onPrimary
                  : colors.onSurface,
              fontWeight: isSelected
                  ? FontWeight.w700
                  : FontWeight.w400,
            ),
          ),
        ),

        const SizedBox(height: 2),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: eventColors.map((color) {
            return Container(
              width: 4,
              height: 4,
              margin: const EdgeInsets.symmetric(
                horizontal: 1,
              ),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}