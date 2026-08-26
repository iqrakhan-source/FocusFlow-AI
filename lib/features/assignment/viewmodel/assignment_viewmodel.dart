import 'package:flutter/material.dart';

import '../model/assignment_model.dart';
import '../repository/assignment_repository.dart';

class AssignmentViewModel extends ChangeNotifier {
  final AssignmentRepository _repository = AssignmentRepository();

  final List<AssignmentModel> _assignments = [];

  List<AssignmentModel> get assignments =>
      List.unmodifiable(_assignments);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Temporary subjects for now.
  // We will connect this to SQLite subjects later.
  final List<String> subjects = [
    'Data Structures',
    'Operating Systems',
    'Flutter',
    'Data Science',
  ];

  Future<void> loadAssignments(int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final assignments =
      await _repository.getAssignments(userId);

      _assignments
        ..clear()
        ..addAll(assignments);

      _assignments.sort(
            (a, b) => a.dueDate.compareTo(b.dueDate),
      );
    } catch (e) {
      debugPrint('LOAD ASSIGNMENTS ERROR: $e');
      _errorMessage = 'Failed to load assignments.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addAssignment({
    required String title,
    required String subject,
    required DateTime dueDate,
    required int userId,
  }) async {
    try {
      final assignment = AssignmentModel(
        id: null,
        userId: userId,
        title: title,
        subject: subject,
        dueDate: dueDate,
      );

      final id =
      await _repository.addAssignment(assignment);

      final savedAssignment = AssignmentModel(
        id: id,
        userId: userId,
        title: title,
        subject: subject,
        dueDate: dueDate,
      );

      _assignments.add(savedAssignment);

      _assignments.sort(
            (a, b) => a.dueDate.compareTo(b.dueDate),
      );

      notifyListeners();
    } catch (e) {
      debugPrint('ADD ASSIGNMENT ERROR: $e');
      _errorMessage = 'Failed to add assignment.';
      notifyListeners();
    }
  }

  Future<void> deleteAssignment(int id) async {
    try {
      await _repository.deleteAssignment(id);

      _assignments.removeWhere(
            (assignment) => assignment.id == id,
      );

      notifyListeners();
    } catch (e) {
      debugPrint('DELETE ASSIGNMENT ERROR: $e');
      _errorMessage = 'Failed to delete assignment.';
      notifyListeners();
    }
  }
}