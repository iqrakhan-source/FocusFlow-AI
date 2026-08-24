import 'package:flutter/material.dart';

import '../model/subject_model.dart';
import '../repository/subject_repository.dart';

class SubjectViewModel extends ChangeNotifier {
  final SubjectRepository _repository;

  SubjectViewModel({
    SubjectRepository? repository,
  }) : _repository = repository ?? SubjectRepository();

  final List<SubjectModel> _subjects = [];
  SubjectModel? _selectedSubject;

  SubjectModel? get selectedSubject => _selectedSubject;

  bool _isLoading = false;
  String? _errorMessage;

  List<SubjectModel> get subjects =>
      List.unmodifiable(_subjects);

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  // Available colors for subjects.
  final List<Color> subjectColors = const [
    Color(0xFF5B4BCF),
    Color(0xFF38B887),
    Color(0xFFF4B547),
    Color(0xFFE76F51),
    Color(0xFF4A90E2),
    Color(0xFF9B59B6),
  ];

  // Only return colors that have not been used.
  List<Color> get availableColors {
    final usedColors = _subjects
        .map((subject) => subject.colorValue)
        .toSet();

    return subjectColors
        .where(
          (color) => !usedColors.contains(color.value),
    )
        .toList();
  }

  // -----------------------------
  // LOAD SUBJECTS
  // -----------------------------

  Future<void> loadSubjects(int userId) async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final subjects =
      await _repository.getSubjects(userId);

      _subjects
        ..clear()
        ..addAll(subjects);
    } catch (e) {
      _errorMessage = 'Unable to load subjects.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // -----------------------------
  // ADD SUBJECT
  // -----------------------------

  Future<bool> addSubject({
    required int userId,
    required String name,
    required String courseCode,
    required Color color,
  }) async {
    _errorMessage = null;

    // Check if color is already used.
    final colorAlreadyUsed = _subjects.any(
          (subject) => subject.colorValue == color.value,
    );

    if (colorAlreadyUsed) {
      _errorMessage =
      'This color is already being used.';
      notifyListeners();
      return false;
    }

    try {
      final subject = SubjectModel(
        userId: userId,
        name: name,
        courseCode: courseCode,
        colorValue: color.value,
        createdAt: DateTime.now(),
      );

      final id = await _repository.addSubject(subject);

      _subjects.add(
        subject.copyWith(id: id),
      );

      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = 'Unable to add subject.';
      notifyListeners();

      return false;
    }
  }

  // -----------------------------
// SELECT SUBJECT
// -----------------------------

  void selectSubject(SubjectModel subject) {
    _selectedSubject = subject;
    notifyListeners();
  }

  void clearSelectedSubject() {
    _selectedSubject = null;
    notifyListeners();
  }


  // -----------------------------
  // DELETE SUBJECT
  // -----------------------------

  Future<void> deleteSubject(int id) async {
    try {
      await _repository.deleteSubject(id);

      _subjects.removeWhere(
            (subject) => subject.id == id,
      );

      if (_selectedSubject?.id == id) {
        _selectedSubject = null;
      }

      notifyListeners();
    } catch (e) {
      _errorMessage = 'Unable to delete subject.';
      notifyListeners();
    }
  }

  // -----------------------------
  // ERROR
  // -----------------------------

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
