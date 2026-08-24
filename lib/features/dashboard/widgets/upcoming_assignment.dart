import 'package:flutter/material.dart';

import '../../../shared/widgets/app_card.dart';

class UpcomingAssignments extends StatelessWidget {
  const UpcomingAssignments({
    super.key,
    required this.assignments,
    this.onAssignmentTap,
  });

  final List<AssignmentItem> assignments;
  final ValueChanged<AssignmentItem>? onAssignmentTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upcoming assignments',
            style: Theme.of(context).textTheme.titleMedium,
          ),

          const SizedBox(height: 12),

          ...assignments.map(
                (assignment) => InkWell(
              onTap: onAssignmentTap == null
                  ? null
                  : () => onAssignmentTap!(assignment),
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 9),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            assignment.title,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            assignment.subject,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),

                    Text(
                      _dueText(assignment.dueDate),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),

                    const SizedBox(width: 6),

                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
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

  String _dueText(DateTime date) {
    final difference = date.difference(DateTime.now()).inDays;

    if (difference <= 0) {
      return 'Due today';
    }

    if (difference == 1) {
      return 'Due tomorrow';
    }

    return 'Due in $difference days';
  }
}

class AssignmentItem {
  const AssignmentItem({
    required this.title,
    required this.subject,
    required this.dueDate,
  });

  final String title;
  final String subject;
  final DateTime dueDate;
}