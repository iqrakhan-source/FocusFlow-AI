import 'package:flutter/material.dart';

import '../../../shared/widgets/app_card.dart';

class ExamItem {
  const ExamItem({
    required this.title,
    required this.examDate,
  });

  final String title;
  final DateTime examDate;
}

class ExamCountdownCard extends StatelessWidget {
  const ExamCountdownCard({
    super.key,
    required this.exams,
    this.onExamTap,
  });

  final List<ExamItem> exams;
  final ValueChanged<ExamItem>? onExamTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Exam countdown',
            style: Theme.of(context).textTheme.titleMedium,
          ),

          const SizedBox(height: 12),

          ...exams.map(
                (exam) {
              final daysRemaining =
                  exam.examDate.difference(DateTime.now()).inDays;

              final days = daysRemaining < 0 ? 0 : daysRemaining;

              return InkWell(
                onTap: onExamTap == null
                    ? null
                    : () => onExamTap!(exam),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Icon(
                        Icons.school_outlined,
                        size: 18,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant,
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Text(
                          exam.title,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$days ${days == 1 ? 'day' : 'days'}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}