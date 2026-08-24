import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proviers/core/routers/app_routes.dart';
import '../widgets/ai_insight_card.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/exam_countdown_card.dart';
import '../widgets/quick_action.dart';
import '../widgets/start_study_card.dart';
import '../widgets/study_quote_card.dart';
import '../widgets/todays_progress.dart';
import '../widgets/todays_schedule.dart';
import '../widgets/upcoming_assignment.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DashboardHeader(
                name: 'Ananya',
                streak: 7,
              ),

              const SizedBox(height: 24),

              TodayProgressCard(
                goalHours: 5,
                completedHours: 3.2,
                remainingHours: 1.8,
              ),

              const SizedBox(height: 16),

              StartStudyCard(
                onStart: () {
                  context.push(AppRoutes.study);
                },
              ),

              const SizedBox(height: 16),

              ExamCountdownCard(
                exams: [
                  ExamItem(
                    title: 'Mid-Sem: DSA',
                    examDate: DateTime(2026, 8, 16),
                  ),
                  ExamItem(
                    title: 'Mid-Sem: DBMS',
                    examDate: DateTime(2026, 8, 21),
                  ),
                ],
                onExamTap: (exam) {
                  context.push(AppRoutes.calendar);
                },
              ),

              const SizedBox(height: 16),

              TodaySchedule(
                sessions: [
                  ScheduleItem(
                    subject: 'Flutter',
                    startTime: '10:00 AM',
                    endTime: '11:00 AM',
                    type: 'Deep Work',
                  ),
                  ScheduleItem(
                    subject: 'DBMS',
                    startTime: '02:00 PM',
                    endTime: '03:00 PM',
                    type: 'Revision',
                  ),
                  ScheduleItem(
                    subject: 'DSA',
                    startTime: '06:00 PM',
                    endTime: '7:00 PM',
                    type: 'Practice',
                  ),
                ],
                onSessionTap: (session) {},
              ),

              const SizedBox(height: 16),

              QuickActions(
                subject: 'Flutter',
                remainingMinutes: 18,
                onContinueSession: () {
                  context.push(AppRoutes.study);
                },
                onDailyReflection: () {
                  context.push(AppRoutes.reflection);
                },
              ),

              const SizedBox(height: 16),

              UpcomingAssignments(
                assignments: [

                  AssignmentItem(
                    title: 'Flutter UI Project',
                    subject: 'Flutter',
                    dueDate: DateTime(2026, 8, 14),
                  ),
                  AssignmentItem(
                    title: 'Normalization Assignment',
                    subject: 'DBMS',
                    dueDate: DateTime(2026, 8, 17),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              AiInsightCard(
                insight:
                'You focus best in the morning. Consider scheduling your hardest subject before noon.',
                onTap: () {},
              ),

              const SizedBox(height: 16),

              StudyQuoteCard(
                quote: 'Small steps every day lead to big results.',
                author: 'FocusFlow AI',
              ),

              const SizedBox(height: 24),

            ],
          ),
        ),
      ),
    );
  }
}