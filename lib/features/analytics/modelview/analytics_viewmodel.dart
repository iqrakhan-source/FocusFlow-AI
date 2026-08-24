import 'package:flutter/material.dart';

import '../model/analytics_model.dart';

class AnalyticsViewModel extends ChangeNotifier {
  AnalyticsModel _analytics = const AnalyticsModel(
    dayStreak: 12,
    monthlyStudyHours: 29.3,
    goalsMet: 82,

    weeklyStudyHours: [
      4.2,
      5.1,
      3.4,
      6.0,
      4.7,
      2.9,
      3.3,
    ],

    subjectDistribution: {
      'DSA': 38,
      'DBMS': 22,
      'OS': 21,
      'CN': 19,
    },

    consistencyData: [
      [1, 2, 3, 1, 3, 2, 0],
      [1, 3, 3, 3, 2, 1, 0],
      [2, 3, 3, 3, 2, 1, 2],
      [3, 3, 3, 2, 1, 0, 3],
      [3, 2, 3, 1, 2, 3, 3],
    ],

    focusTrend: [
      58,
      62,
      60,
      68,
      66,
      73,
      71,
      79,
      77,
      83,
      81,
      86,
    ],

    goalCompletion: 0.82,

    aiInsights: [
      'You are most productive during evening study sessions.',
      'Your DSA study consistency has improved this month.',
      'Shorter focused sessions seem to work best for you.',
    ],
  );

  AnalyticsModel get analytics => _analytics;

  int get dayStreak => _analytics.dayStreak;

  double get monthlyStudyHours =>
      _analytics.monthlyStudyHours;

  int get goalsMet => _analytics.goalsMet;

  List<double> get weeklyStudyHours =>
      _analytics.weeklyStudyHours;

  Map<String, double> get subjectDistribution =>
      _analytics.subjectDistribution;

  List<List<int>> get consistencyData =>
      _analytics.consistencyData;

  List<double> get focusTrend =>
      _analytics.focusTrend;

  double get goalCompletion =>
      _analytics.goalCompletion;

  List<String> get aiInsights =>
      _analytics.aiInsights;
}