import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({
    super.key,
    required this.subject,
    required this.remainingMinutes,
    required this.onContinueSession,
    required this.onDailyReflection,
  });

  final String subject;
  final int remainingMinutes;
  final VoidCallback onContinueSession;
  final VoidCallback onDailyReflection;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: AppCard(
              padding: const EdgeInsets.all(16),
              child: InkWell(
                onTap: onContinueSession,
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.schedule_outlined,
                      color: primary,
                      size: 22,
                    ),
      
                    const SizedBox(height: 14),
      
                    Text(
                      'Continue $subject session',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
      
                    const SizedBox(height: 4),
      
                    Text(
                      '$remainingMinutes min left',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
      
          const SizedBox(width: 12),
      
          Expanded(
            child: AppCard(
              padding: const EdgeInsets.all(16),
              child: InkWell(
                onTap: onDailyReflection,
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.menu_book_outlined,
                      color: AppColors.secondary,
                      size: 22,
                    ),
      
                    const SizedBox(height: 14),
      
                    Text(
                      'Daily reflection',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
      
                    const SizedBox(height: 4),
      
                    Text(
                      'Evening check-in',
                      style: Theme.of(context).textTheme.bodySmall,
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
}