import 'package:flutter/material.dart';

class WeekCalendar extends StatelessWidget {
  const WeekCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _WeekEventCard(
          day: 'Mon 3',
          events: [
            _WeekEvent(
              title: 'DSA · Deep Work',
              type: WeekEventType.study,
            ),
          ],
        ),

        SizedBox(height: 12),

        _WeekEventCard(
          day: 'Wed 5',
          events: [
            _WeekEvent(
              title: 'DBMS · Revision',
              type: WeekEventType.study,
            ),
            _WeekEvent(
              title: 'CN Lab Report due',
              type: WeekEventType.assignment,
            ),
          ],
        ),

        SizedBox(height: 12),

        _WeekEventCard(
          day: 'Fri 14',
          events: [
            _WeekEvent(
              title: 'Mid-Sem: DSA',
              type: WeekEventType.exam,
            ),
          ],
        ),
      ],
    );
  }
}

class _WeekEventCard extends StatelessWidget {
  const _WeekEventCard({
    required this.day,
    required this.events,
  });

  final String day;
  final List<_WeekEvent> events;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

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
            day,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          ...events.map(
                (event) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _eventColor(
                          context,
                          event.type,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 8),

                    Text(
                      event.title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _WeekEvent {
  const _WeekEvent({
    required this.title,
    required this.type,
  });

  final String title;
  final WeekEventType type;
}

enum WeekEventType {
  study,
  assignment,
  exam,
}

Color _eventColor(
    BuildContext context,
    WeekEventType type,
    ) {
  final colors = Theme.of(context).colorScheme;

  switch (type) {
    case WeekEventType.study:
      return colors.primary;

    case WeekEventType.assignment:
      return colors.secondary;

    case WeekEventType.exam:
      return const Color(0xFFF2994A);
  }
}