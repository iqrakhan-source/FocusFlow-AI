import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routers/app_routes.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../viewmodel/dashboard_viewmodel.dart';

import '../widgets/ai_insight_card.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/exam_countdown_card.dart';
import '../widgets/quick_action.dart';
import '../widgets/start_study_card.dart';
import '../widgets/study_quote_card.dart';
import '../widgets/todays_progress.dart';
import '../widgets/todays_schedule.dart';
import '../widgets/upcoming_assignment.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId =
      context.read<AuthViewModel>().currentUser!.id!;

      context
          .read<DashboardViewModel>()
          .loadDashboard(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboard =
    context.watch<DashboardViewModel>();

    final user =
        context.watch<AuthViewModel>().currentUser;

    return Scaffold(
      body: SafeArea(
        child: dashboard.isLoading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.stretch,
            children: [

              // ---------------- HEADER ----------------

              DashboardHeader(
                name: user?.name ?? 'Student',
                streak: dashboard.dayStreak,
              ),

              const SizedBox(height: 24),

              // ---------------- TODAY'S PROGRESS ----------------

              TodayProgressCard(
                goalHours:
                dashboard.goalHours,
                completedHours:
                dashboard.completedHours,
                remainingHours:
                dashboard.remainingHours,
              ),

              const SizedBox(height: 16),

              // ---------------- START STUDY ----------------

              StartStudyCard(
                onStart: () {
                  context.push(
                    AppRoutes.study,
                  );
                },
              ),

              const SizedBox(height: 16),

              // ---------------- EXAMS ----------------

              ExamCountdownCard(
                exams: dashboard.exams
                    .map(
                      (exam) => ExamItem(
                    title:
                    exam['title'] as String,
                    examDate:
                    DateTime.parse(
                      exam['exam_date']
                      as String,
                    ),
                  ),
                )
                    .toList(),
                onExamTap: (exam) {
                  context.push(
                    AppRoutes.calendar,
                  );
                },
              ),

              const SizedBox(height: 16),

              // ---------------- TODAY'S SCHEDULE ----------------

              TodaySchedule(
                sessions: dashboard.todaySessions
                    .map(
                      (session) => ScheduleItem(
                    subject:
                    session['subject']
                    as String,
                    startTime:
                    _formatTime(
                      session['started_at']
                      as String,
                    ),
                    endTime:
                    _formatEndTime(
                      session['started_at']
                      as String,
                      session[
                      'duration_minutes'] as int,
                    ),
                    type:
                    session['session_type']
                    as String,
                  ),
                )
                    .toList(),
                onSessionTap: (session) {},
              ),

              const SizedBox(height: 16),

              // ---------------- QUICK ACTIONS ----------------

              QuickActions(
                subject: dashboard
                    .todaySessions.isNotEmpty
                    ? dashboard.todaySessions.first[
                'subject']
                as String
                    : 'Study',

                remainingMinutes:
                (dashboard.remainingHours * 60)
                    .round(),

                onContinueSession: () {
                  context.push(
                    AppRoutes.study,
                  );
                },

                onDailyReflection: () {
                  context.push(
                    AppRoutes.reflection,
                  );
                },
              ),

              const SizedBox(height: 16),

              // ---------------- ASSIGNMENTS ----------------

              UpcomingAssignments(
                assignments: dashboard.assignments
                    .map(
                      (assignment) =>
                      AssignmentItem(
                        title:
                        assignment['title']
                        as String,
                        subject:
                        assignment['subject']
                        as String,
                        dueDate:
                        DateTime.parse(
                          assignment['due_date']
                          as String,
                        ),
                      ),
                )
                    .toList(),
              ),

              const SizedBox(height: 16),

              // ---------------- AI INSIGHT ----------------

              const AiInsightCard(
                insight:
                'Keep building your study consistency. Small focused sessions add up.',
              ),

              const SizedBox(height: 16),

              // ---------------- QUOTE ----------------

              const StudyQuoteCard(
                quote:
                'Small steps every day lead to big results.',
                author: 'FocusFlow AI',
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(String dateTime) {
    final date = DateTime.parse(dateTime);

    final hour = date.hour;
    final minute =
    date.minute.toString().padLeft(2, '0');

    final period = hour >= 12 ? 'PM' : 'AM';

    final displayHour =
    hour % 12 == 0 ? 12 : hour % 12;

    return '$displayHour:$minute $period';
  }

  String _formatEndTime(
      String startedAt,
      int durationMinutes,
      ) {
    final start = DateTime.parse(startedAt);

    final end =
    start.add(Duration(minutes: durationMinutes));

    return _formatTime(
      end.toIso8601String(),
    );
  }
}