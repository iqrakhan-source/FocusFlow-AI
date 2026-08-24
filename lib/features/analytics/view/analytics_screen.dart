import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return ChangeNotifierProvider(
      create: (_) => AnalyticsViewModel(),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            16,
            20,
            32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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

              Consumer<AnalyticsViewModel>(
                builder: (context, analytics, child) {
                  return Column(
                    children: [
                      for (int i = 0; i < analytics.aiInsights.length; i++) ...[
                        AiInsightCard(
                          insight: analytics.aiInsights[i],
                        ),

                        if (i < analytics.aiInsights.length - 1)
                          const SizedBox(height: 12),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}