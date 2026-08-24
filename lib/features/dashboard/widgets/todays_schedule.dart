import 'package:flutter/material.dart';

import '../../../shared/widgets/app_card.dart';

class ScheduleItem {
  const ScheduleItem({
    required this.subject,
    required this.startTime,
    required this.endTime,
    required this.type,
  });

  final String subject;
  final String startTime;
  final String endTime;
  final String type;
}

class TodaySchedule extends StatelessWidget {
  const TodaySchedule({
    super.key,
    required this.sessions,
    this.onSessionTap,
  });

  final List<ScheduleItem> sessions;
  final ValueChanged<ScheduleItem>? onSessionTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Today's schedule",
            style: Theme.of(context).textTheme.titleMedium,
          ),

          const SizedBox(height: 12),

          ...sessions.map(
                (session) => InkWell(
              onTap: onSessionTap == null
                  ? null
                  : () => onSessionTap!(session),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 52,
                      child: Text(
                        session.startTime,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${session.subject} — ${session.type}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 1),
                          Text(
                            session.type,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    _StatusDot(
                      color: _statusColor(
                        context,
                        session.type,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(BuildContext context, String type) {
    switch (type.toLowerCase()) {
      case 'practice':
        return Colors.orange;
      case 'revision':
      case 'deep work':
        return Theme.of(context).colorScheme.secondary;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}