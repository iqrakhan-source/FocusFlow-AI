import 'package:flutter/material.dart';

import '../repository/dashboard_repository.dart';

class DashboardViewModel extends ChangeNotifier {
  final DashboardRepository _repository = DashboardRepository();

  bool _isLoading = false;
  String? _errorMessage;


  // ---------------- STREAK ----------------

  int _dayStreak = 0;

  int get dayStreak => _dayStreak;


  // ---------------- TODAY'S PROGRESS ----------------

  int _todayStudyMinutes = 0;

  int get todayStudyMinutes => _todayStudyMinutes;

  int dailyGoalMinutes = 300;

  double get completedHours => _todayStudyMinutes / 60;

  double get goalHours => dailyGoalMinutes / 60;

  double get remainingHours {
    final remaining =
        dailyGoalMinutes - _todayStudyMinutes;

    return remaining > 0 ? remaining / 60 : 0;
  }

  // ---------------- EXAMS ----------------

  List<Map<String, dynamic>> _exams = [];

  List<Map<String, dynamic>> get exams =>
      List.unmodifiable(_exams);

  // ---------------- ASSIGNMENTS ----------------

  List<Map<String, dynamic>> _assignments = [];

  List<Map<String, dynamic>> get assignments =>
      List.unmodifiable(_assignments);

  // ---------------- STUDY SESSIONS ----------------

  List<Map<String, dynamic>> _todaySessions = [];

  List<Map<String, dynamic>> get todaySessions =>
      List.unmodifiable(_todaySessions);

  // ---------------- GOAL ----------------

  Map<String, dynamic>? _todayGoal;

  Map<String, dynamic>? get todayGoal => _todayGoal;

  // ---------------- STATE ----------------

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  // ---------------- LOAD DASHBOARD ----------------

  Future<void> loadDashboard(int userId) async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      _todayStudyMinutes =
      await _repository.getTodayStudyMinutes(userId);

      _todaySessions =
      await _repository.getTodaySessions(userId);

      _exams =
      await _repository.getUpcomingExams(userId);

      _assignments =
      await _repository.getUpcomingAssignments(userId);

      _todayGoal =
      await _repository.getTodayGoal(userId);

      // If a goal exists, use it.
      if (_todayGoal != null) {
        dailyGoalMinutes =
            (_todayGoal!['target_minutes'] as num).toInt();
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;

    notifyListeners();
  }

  // ---------------- DAY STREAK ----------------

  int _calculateDayStreak(List<String> studyDates) {
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

}