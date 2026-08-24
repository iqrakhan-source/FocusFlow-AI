import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routers/app_routes.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../widgets/profile_study_data_card.dart';
import '../../../core/theme/theme_provider.dart';
import '../modelview/profile_viewmodel.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_settings_card.dart';
import '../widgets/profile_insight_card.dart';
import '../widgets/logout_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileViewModel(
        authViewModel: context.read<AuthViewModel>(),
      ),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            8,
            20,
            32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHeader(
                name: profile.name,
                course: profile.course,
                semester: profile.semester,
                university: profile.university,
              ),

              const SizedBox(height: 20),

              ProfileStudyDataCard(
                onSubjectsTap: () {
                  context.push(AppRoutes.subjects);
                },

                onExamDatesTap: () {
                  context.push(AppRoutes.examDates);
                },

                onAssignmentsTap: () {
                  context.push(AppRoutes.assignments);
                },
              ),

              const SizedBox(height: 20),

              const SizedBox(height: 20),

              Text(
                'Settings',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              ProfileSettingsCard(
                dailyStudyGoal: profile.dailyStudyGoal,
                notificationsEnabled: profile.notificationsEnabled,

                darkModeEnabled:
                Theme.of(context).brightness == Brightness.dark,

                onNotificationsChanged: (value) {
                  context
                      .read<ProfileViewModel>()
                      .setNotifications(value);
                },

                onDarkModeChanged: (value) {
                  context.read<ThemeProvider>().setTheme(
                    value
                        ? ThemeMode.dark
                        : ThemeMode.light,
                  );
                },

                onDailyGoalTap: () {
                  _showDailyGoalDialog(context);
                },

                onExportTap: () {
                  // Export functionality will be added later.
                },
              ),

              const SizedBox(height: 20),

              ProfileInsightCard(
                insight: profile.aiInsight,
              ),

              const SizedBox(height: 20),

              LogoutButton(
                onPressed: () {
                  // Logout functionality will be added later.
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDailyGoalDialog(BuildContext context) {
    final profile = context.read<ProfileViewModel>();

    int selectedGoal = profile.dailyStudyGoal;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Daily study goal'),

              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$selectedGoal hours per day',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium,
                  ),

                  const SizedBox(height: 16),

                  Slider(
                    value: selectedGoal.toDouble(),
                    min: 1,
                    max: 12,
                    divisions: 11,
                    label: '$selectedGoal hours',
                    onChanged: (value) {
                      setDialogState(() {
                        selectedGoal = value.round();
                      });
                    },
                  ),
                ],
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Cancel'),
                ),

                FilledButton(
                  onPressed: () {
                    profile.updateDailyStudyGoal(
                      selectedGoal,
                    );

                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}