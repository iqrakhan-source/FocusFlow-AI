class AnalyticsModel {
  final int dayStreak;
  final double monthlyStudyHours;
  final int goalsMet;

  final List<double> weeklyStudyHours;

  final Map<String, double> subjectDistribution;

  final List<List<int>> consistencyData;

  final List<double> focusTrend;

  final double goalCompletion;

  final List<String> aiInsights;

  const AnalyticsModel({
    required this.dayStreak,
    required this.monthlyStudyHours,
    required this.goalsMet,
    required this.weeklyStudyHours,
    required this.subjectDistribution,
    required this.consistencyData,
    required this.focusTrend,
    required this.goalCompletion,
    required this.aiInsights,
  });
}