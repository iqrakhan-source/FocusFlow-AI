import 'package:flutter/material.dart';

import '../../../shared/widgets/app_card.dart';

class StudyQuoteCard extends StatelessWidget {
  const StudyQuoteCard({
    super.key,
    required this.quote,
    this.author,
  });

  final String quote;
  final String? author;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      child: Column(
        children: [
          Text(
            '"$quote"',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),

          if (author != null) ...[
            const SizedBox(height: 6),
            Text(
              '— $author',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}