import 'dart:async';
import 'package:flutter/material.dart';

import '../model/study_session.dart';
import '../repository/study_session_repository.dart';

class StudyViewModel extends ChangeNotifier {
  final StudySessionRepository _repository =
  StudySessionRepository();

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
    required int userId,
  }) {
    _timer?.cancel();

    _currentSession = StudySessionModel(
      userId: userId,
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

  Future<void> _completeSession() async {
    _timer?.cancel();

    if (_currentSession != null) {
      final completedSession = _currentSession!.copyWith(
        completedAt: DateTime.now(),
        isCompleted: true,
      );

      _currentSession = completedSession;

      try {
        final id = await _repository.addSession(
          completedSession,
        );

        _currentSession = completedSession.copyWith(
          id: id,
        );

        debugPrint(
          'STUDY SESSION SAVED: $id',
        );
      } catch (e) {
        debugPrint(
          'SAVE STUDY SESSION ERROR: $e',
        );
      }
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