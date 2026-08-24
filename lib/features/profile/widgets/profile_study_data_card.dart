import 'package:flutter/material.dart';

class ProfileStudyDataCard extends StatelessWidget {
  final VoidCallback? onSubjectsTap;
  final VoidCallback? onExamDatesTap;
  final VoidCallback? onAssignmentsTap;

  const ProfileStudyDataCard({
    super.key,
    this.onSubjectsTap,
    this.onExamDatesTap,
    this.onAssignmentsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Text(
              'My study data',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          _StudyDataTile(
            icon: Icons.menu_book_outlined,
            title: 'Subjects',
            onTap: onSubjectsTap,
          ),

          _StudyDataTile(
            icon: Icons.school_outlined,
            title: 'Exam dates',
            onTap: onExamDatesTap,
          ),

          _StudyDataTile(
            icon: Icons.assignment_outlined,
            title: 'Assignments',
            showDivider: false,
            onTap: onAssignmentsTap,
          ),
        ],
      ),
    );
  }
}

class _StudyDataTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final bool showDivider;

  const _StudyDataTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 14,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: primary,
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                Icon(
                  Icons.chevron_right,
                  size: 22,
                  color: Colors.grey.shade500,
                ),
              ],
            ),
          ),
        ),

      ],
    );
  }
}