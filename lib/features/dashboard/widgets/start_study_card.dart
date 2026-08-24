import 'package:flutter/material.dart';

class StartStudyCard extends StatelessWidget {
  const StartStudyCard({
    super.key,
    required this.onStart,
  });

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Material(
      color: colorScheme.primary,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onStart,
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 72,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Start study session',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.w700, ),
                      ),
                      const SizedBox(height: 1),
                      Text( 'Deep work · pick subject & timer',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(
                  Icons.play_arrow_outlined,
                  color: colorScheme.onPrimary,                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}