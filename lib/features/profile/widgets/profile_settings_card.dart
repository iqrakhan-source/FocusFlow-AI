import 'package:flutter/material.dart';

import 'profile_setting_row.dart';

class ProfileSettingsCard extends StatelessWidget {
  const ProfileSettingsCard({
    super.key,
    required this.notificationsEnabled,
    required this.darkModeEnabled,
    required this.onNotificationsChanged,
    required this.onDarkModeChanged,
    required this.onDailyGoalTap,
    required this.onExportTap,
  });

  final bool notificationsEnabled;
  final bool darkModeEnabled;

  final ValueChanged<bool> onNotificationsChanged;
  final ValueChanged<bool> onDarkModeChanged;

  final VoidCallback onDailyGoalTap;
  final VoidCallback onExportTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          ProfileSettingRow(
            icon: Icons.track_changes_outlined,
            title: 'Daily study goal',
            trailing: Text(
              '5 hours',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: onDailyGoalTap,
          ),

          const Divider(height: 1),

          ProfileSettingRow(
            icon: Icons.notifications_none_outlined,
            title: 'Notifications',
            trailing: Switch(
              value: notificationsEnabled,
              onChanged: onNotificationsChanged,
            ),
          ),

          const Divider(height: 1),

          ProfileSettingRow(
            icon: Icons.dark_mode_outlined,
            title: 'Dark mode',
            trailing: Switch(
              value: darkModeEnabled,
              onChanged: onDarkModeChanged,
            ),
          ),

          const Divider(height: 1),

          ProfileSettingRow(
            icon: Icons.download_outlined,
            title: 'Export my data',
            trailing: Text(
              'CSV',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            onTap: onExportTap,
          ),
        ],
      ),
    );
  }
}