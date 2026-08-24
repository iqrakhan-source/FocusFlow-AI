import 'package:flutter/material.dart';

class MonthCalendar extends StatelessWidget {
  const MonthCalendar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    const weekdays = [
      'M',
      'T',
      'W',
      'T',
      'F',
      'S',
      'S',
    ];

    // September 2026 starts on Tuesday.
    const days = <int?>[
      null,
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
      21,
      22,
      23,
      24,
      25,
      26,
      27,
      28,
      29,
      30,
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
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(
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

              if (day == null) {
                return const SizedBox();
              }

              final isSelected = day == 12;

              return _CalendarDay(
                day: day,
                isSelected: isSelected,
                eventColors: _eventColorsForDay(
                  context,
                  day,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<Color> _eventColorsForDay(
      BuildContext context,
      int day,
      ) {
    final colors = Theme.of(context).colorScheme;

    switch (day) {
      case 3:
        return [
          colors.primary,
        ];

      case 4:
        return [
          colors.primary,
          colors.secondary,
        ];

      case 8:
        return [
          colors.error,
        ];

      case 14:
        return [
          const Color(0xFFF2994A),
        ];

      case 17:
        return [
          colors.primary,
          colors.secondary,
        ];

      case 21:
        return [
          colors.primary,
        ];

      case 24:
        return [
          const Color(0xFFF2994A),
        ];

      case 27:
        return [
          colors.primary,
        ];

      default:
        return [];
    }
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
    final colors = Theme.of(context).colorScheme;

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
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(
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