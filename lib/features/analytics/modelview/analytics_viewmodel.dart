import 'package:flutter/material.dart';

import '../model/analytics_model.dart';
import '../repository/analytics_repository.dart';

class AnalyticsViewModel extends ChangeNotifier {
  final AnalyticsRepository _repository =
  AnalyticsRepository();

  AnalyticsModel _analytics = const AnalyticsModel(
    dayStreak: 0,
    monthlyStudyHours: 0,
    goalsMet: 0,
    weeklyStudyHours: [],
    subjectDistribution: {},
    consistencyData: [],
    focusTrend: [],
    goalCompletion: 0,
    aiInsights: [],
  );

  bool _isLoading = false;
  String? _errorMessage;

  AnalyticsModel get analytics => _analytics;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

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

  Future<void> loadAnalytics(int userId) async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final fiveWeekData =
      await _repository.getFiveWeekStudyData(userId);

      final totalMinutes =
      await _repository.getTotalStudyMinutes(userId);

      final totalSessions =
      await _repository.getTotalSessions(userId);

      final subjectData =
      await _repository.getStudyTimeBySubject(userId);

      final weeklyData =
      await _repository.getWeeklyStudyData(userId);

      final studyDates =
      await _repository.getStudyDates(userId);

      final focusData =
      await _repository.getFocusTrendData(userId);
      final focusTrend =
      _buildFocusTrend(focusData);

      final goalCompletion =
      await _repository.getGoalCompletionPercentage(userId);

      // SUBJECT DISTRIBUTION

      final subjectDistribution = <String, double>{};

      for (final row in subjectData) {
        final subject = row['subject'] as String;

        final minutes =
            (row['total_minutes'] as num?)?.toDouble() ?? 0;

        subjectDistribution[subject] = minutes;
      }

      // WEEKLY STUDY HOURS

      final weeklyStudyHours = List<double>.filled(7, 0);

      final now = DateTime.now();

      final today = DateTime(
        now.year,
        now.month,
        now.day,
      );

      final consistencyData =
      _buildConsistencyData(fiveWeekData);


// Monday = 1, Sunday = 7
      final monday = today.subtract(
        Duration(days: today.weekday - 1),
      );

      for (final row in weeklyData) {
        final startedAt =
        DateTime.parse(row['started_at'] as String);

        final studyDate = DateTime(
          startedAt.year,
          startedAt.month,
          startedAt.day,
        );

        final difference =
            studyDate.difference(monday).inDays;

        if (difference >= 0 && difference < 7) {
          final minutes =
          (row['duration_minutes'] as num).toDouble();

          weeklyStudyHours[difference] += minutes / 60;
        }
      }
      // DAY STREAK

      final dayStreak =
      _calculateDayStreak(studyDates);

      _analytics = AnalyticsModel(
        dayStreak: dayStreak,

        monthlyStudyHours:
        totalMinutes / 60,

        // Goals .
        goalsMet: goalCompletion,

        weeklyStudyHours:
        weeklyStudyHours,

        subjectDistribution:
        subjectDistribution,

        consistencyData: consistencyData,


        // Focus trend needs a defined metric.
        focusTrend: focusTrend,

        goalCompletion: goalCompletion / 100,
        aiInsights: [
          'You have completed $totalSessions study sessions.',
        ],
      );
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;

    notifyListeners();
  }

  int _calculateDayStreak(
      List<String> studyDates,
      ) {
    if (studyDates.isEmpty) {
      return 0;
    }

    final dates = studyDates
        .map(DateTime.parse)
        .map(
          (date) => DateTime(
        date.year,
        date.month,
        date.day,
      ),
    )
        .toSet();

    DateTime current = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    // If the user hasn't studied today,
    // start checking from yesterday.
    if (!dates.contains(current)) {
      current = current.subtract(
        const Duration(days: 1),
      );
    }

    int streak = 0;

    while (dates.contains(current)) {
      streak++;

      current = current.subtract(
        const Duration(days: 1),
      );
    }

    return streak;
  }

  List<List<int>> _buildConsistencyData(
      List<Map<String, dynamic>> data,
      ) {
    final studyMinutes = <DateTime, int>{};

    for (final row in data) {
      final startedAt =
      DateTime.parse(row['started_at'] as String);

      final date = DateTime(
        startedAt.year,
        startedAt.month,
        startedAt.day,
      );

      final minutes =
      (row['duration_minutes'] as num).toInt();

      studyMinutes[date] =
          (studyMinutes[date] ?? 0) + minutes;
    }

    final today = DateTime.now();

    final startOfToday = DateTime(
      today.year,
      today.month,
      today.day,
    );

    final startDate = startOfToday.subtract(
      const Duration(days: 34),
    );

    final result = <List<int>>[];

    for (int week = 0; week < 5; week++) {
      final weekData = <int>[];

      for (int day = 0; day < 7; day++) {
        final date = startDate.add(
          Duration(days: week * 7 + day),
        );

        final minutes = studyMinutes[date] ?? 0;

        int intensity;

        if (minutes == 0) {
          intensity = 0;
        } else if (minutes <= 30) {
          intensity = 1;
        } else if (minutes <= 60) {
          intensity = 2;
        } else {
          intensity = 3;
        }

        weekData.add(intensity);
      }

      result.add(weekData);
    }

    return result;
  }

  List<double> _buildFocusTrend(
      List<Map<String, dynamic>> data,
      ) {
    final dailyMinutes = <DateTime, int>{};

    for (final row in data) {
      final startedAt =
      DateTime.parse(row['started_at'] as String);

      final date = DateTime(
        startedAt.year,
        startedAt.month,
        startedAt.day,
      );

      final minutes =
      (row['duration_minutes'] as num).toInt();

      dailyMinutes[date] =
          (dailyMinutes[date] ?? 0) + minutes;
    }

    final today = DateTime.now();

    final result = <double>[];

    for (int i = 11; i >= 0; i--) {
      final date = DateTime(
        today.year,
        today.month,
        today.day,
      ).subtract(
        Duration(days: i),
      );

      final minutes = dailyMinutes[date] ?? 0;

      // Convert study time into the chart's 50–90 range.
      final focusScore =
          50 + (minutes / 120 * 40);

      result.add(
        focusScore.clamp(50, 90),
      );
    }

    return result;
  }

}