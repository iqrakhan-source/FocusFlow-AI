import 'package:flutter/material.dart';

import '../model/assignment_model.dart';

class AssignmentViewModel extends ChangeNotifier {
  final List<AssignmentModel> _assignments = [];

  List<AssignmentModel> get assignments =>
      List.unmodifiable(_assignments);

  // Temporary subjects.
  // Later these will come from the SQLite subjects table.
  final List<String> subjects = [
    'Data Structures',
    'Operating Systems',
    'Flutter',
    'Data Science',
  ];

  void addAssignment({
    required String title,
    required String subject,
    required DateTime dueDate,
  }) {
    final assignment = AssignmentModel(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      subject: subject,
      dueDate: dueDate,
    );

    _assignments.add(assignment);

    // Show earliest due assignment first.
    _assignments.sort(
          (a, b) => a.dueDate.compareTo(b.dueDate),
    );

    notifyListeners();
  }

  void deleteAssignment(int id) {
    _assignments.removeWhere(
          (assignment) => assignment.id == id,
    );

    notifyListeners();
  }
}