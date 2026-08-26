import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/viewmodel/auth_viewmodel.dart';
import '../modelview/analytics_viewmodel.dart';
import '../widgets/analytics_header.dart';
import '../widgets/analytics_summary.dart';
import '../widgets/weekly_study_card.dart';
import '../widgets/subject_distribution_card.dart';
import '../widgets/consistency_heatmap.dart';
import '../widgets/focus_trend_card.dart';
import '../widgets/goal_completion_card.dart';
import '../widgets/ai_insight_card.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId =
        context.read<AuthViewModel>().currentUser?.id;

    return ChangeNotifierProvider(
      create: (_) {
        final viewModel = AnalyticsViewModel();

        if (userId != null) {
          viewModel.loadAnalytics(userId);
        }

        return viewModel;
      },
      child: const _AnalyticsView(),
    );
  }
}

class _AnalyticsView extends StatelessWidget {
  const _AnalyticsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: Consumer<AnalyticsViewModel>(
        builder: (context, analytics, child) {
          if (analytics.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (analytics.errorMessage != null) {
            return Center(
              child: Text(
                analytics.errorMessage!,
                //'Unable to load analytics.',
              ),
            );
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                20,
                16,
                20,
                32,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const AnalyticsHeader(),

                  const SizedBox(height: 20),

                  const AnalyticsSummary(),

                  const SizedBox(height: 16),

                  const WeeklyStudyCard(),

                  const SizedBox(height: 16),

                  const SubjectDistributionCard(),

                  const SizedBox(height: 16),

                  const ConsistencyHeatmap(),

                  const SizedBox(height: 16),

                  const FocusTrendCard(),

                  const SizedBox(height: 16),

                  const GoalCompletionCard(),

                  const SizedBox(height: 16),

                  for (
                  int i = 0;
                  i < analytics.aiInsights.length;
                  i++
                  ) ...[
                    AiInsightCard(
                      insight: analytics.aiInsights[i],
                    ),

                    if (
                    i <
                        analytics.aiInsights.length - 1
                    )
                      const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}