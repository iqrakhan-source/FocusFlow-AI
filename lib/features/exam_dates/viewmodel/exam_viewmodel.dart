import 'package:flutter/material.dart';

import '../model/exam_model.dart';
import '../repository/exam_repository.dart';
import 'package:provider/provider.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';

class ExamViewModel extends ChangeNotifier {
  final ExamRepository _repository = ExamRepository();

  final List<ExamModel> _exams = [];

  List<ExamModel> get exams => List.unmodifiable(_exams);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Load exams for the logged-in user
  Future<void> loadExams(int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final exams = await _repository.getExams(userId);

      _exams
        ..clear()
        ..addAll(exams);

      // Keep nearest exam first.
      _exams.sort(
            (a, b) => a.examDate.compareTo(b.examDate),
      );
    } catch (e) {
      _errorMessage = 'Failed to load exams.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add exam to SQLite
  Future<void> addExam({
    required String title,
    required String subject,
    required DateTime examDate,
    required int userId,
  }) async {
    try {
      final exam = ExamModel(
        id: null,
        userId: userId,
        title: title,
        subject: subject,
        examDate: examDate,
      );

      final id = await _repository.addExam(exam);

      final savedExam = ExamModel(
        id: id,
        userId: userId,
        title: title,
        subject: subject,
        examDate: examDate,
      );

      _exams.add(savedExam);

      _exams.sort(
            (a, b) => a.examDate.compareTo(b.examDate),
      );

      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to add exam.';
      notifyListeners();
    }
  }

  // Delete exam from SQLite
  Future<void> deleteExam(int id) async {
    try {
      await _repository.deleteExam(id);

      _exams.removeWhere(
            (exam) => exam.id == id,
      );

      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to delete exam.';
      notifyListeners();
    }
  }
}