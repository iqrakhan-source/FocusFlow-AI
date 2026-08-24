import 'dart:async';

import 'package:flutter/material.dart';
import '../model/study_session.dart';

class StudyViewModel extends ChangeNotifier {
  StudySessionModel? _currentSession;

  Timer? _timer;

  int _remainingSeconds = 0;

  bool _isRunning = false;
  bool _isPaused = false;

  StudySessionModel? get currentSession => _currentSession;

  int get remainingSeconds => _remainingSeconds;

  bool get isRunning => _isRunning;

  bool get isPaused => _isPaused;

  int get remainingMinutes =>
      (_remainingSeconds / 60).ceil();

  String get formattedTime {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  void startSession({
    required String subject,
    required String sessionType,
    required int durationMinutes,
  }) {
    _timer?.cancel();

    _currentSession = StudySessionModel(
      subject: subject,
      sessionType: sessionType,
      durationMinutes: durationMinutes,
      startedAt: DateTime.now(),
      isCompleted: false,
    );

    _remainingSeconds = durationMinutes * 60;

    _isRunning = true;
    _isPaused = false;

    notifyListeners();

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (_) {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          notifyListeners();
        } else {
          _completeSession();
        }
      },
    );
  }

  void pauseSession() {
    if (!_isRunning || _isPaused) return;

    _timer?.cancel();

    _isPaused = true;

    notifyListeners();
  }

  void resumeSession() {
    if (!_isRunning || !_isPaused) return;

    _isPaused = false;

    notifyListeners();

    _startTimer();
  }

  void stopSession() {
    _timer?.cancel();

    _isRunning = false;
    _isPaused = false;

    notifyListeners();
  }

  void _completeSession() {
    _timer?.cancel();

    if (_currentSession != null) {
      _currentSession = _currentSession!.copyWith(
        completedAt: DateTime.now(),
        isCompleted: true,
      );
    }

    _remainingSeconds = 0;
    _isRunning = false;
    _isPaused = false;

    notifyListeners();
  }

  void disposeTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}