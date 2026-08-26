import 'package:flutter/material.dart';

import '../model/reflection_model.dart';
import '../repository/rflection_repository.dart';

class ReflectionViewModel extends ChangeNotifier {
  final ReflectionRepository _repository =
  ReflectionRepository();

  List<ReflectionModel> _reflections = [];

  bool _isLoading = false;
  String? _errorMessage;

  List<ReflectionModel> get reflections =>
      List.unmodifiable(_reflections);

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<void> loadReflections(int userId) async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      _reflections =
      await _repository.getReflections(userId);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;

    notifyListeners();
  }

  Future<bool> addReflection({
    required int userId,
    required String mood,
    required int stressLevel,
    required double sleepHours,
    required String achievement,
    required String distraction,
  }) async {
    try {
      final reflection = ReflectionModel(
        userId: userId,
        mood: mood,
        stressLevel: stressLevel,
        sleepHours: sleepHours,
        achievement: achievement,
        distraction: distraction,
        createdAt: DateTime.now(),
      );

      final id = await _repository.addReflection(
        reflection,
      );

      _reflections.insert(
        0,
        ReflectionModel(
          id: id,
          userId: reflection.userId,
          mood: reflection.mood,
          stressLevel: reflection.stressLevel,
          sleepHours: reflection.sleepHours,
          achievement: reflection.achievement,
          distraction: reflection.distraction,
          createdAt: reflection.createdAt,
        ),
      );

      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString();

      notifyListeners();

      return false;
    }
  }

  Future<void> deleteReflection(int id) async {
    try {
      await _repository.deleteReflection(id);

      _reflections.removeWhere(
            (reflection) => reflection.id == id,
      );

      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();

      notifyListeners();
    }
  }
}