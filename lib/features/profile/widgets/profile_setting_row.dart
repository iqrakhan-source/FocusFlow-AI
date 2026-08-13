import 'package:flutter/material.dart';

class ProfileSettingRow extends StatelessWidget {
  const ProfileSettingRow({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 52,
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: colors.primary,
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyMedium,
              ),
            ),

            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}