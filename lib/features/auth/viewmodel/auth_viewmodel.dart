import 'package:flutter/material.dart';

import '../model/user_model.dart';
import '../repository/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository;

  AuthViewModel({
    AuthRepository? repository,
  }) : _repository = repository ?? AuthRepository();

  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _currentUser;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  UserModel? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  Future<bool> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final normalizedEmail = email.trim().toLowerCase();

      final exists =
      await _repository.emailExists(normalizedEmail);
      if (exists) {
        _errorMessage =
        'An account with this email already exists.';
        return false;
      }

      final user = UserModel(
        name: name.trim(),
        email: normalizedEmail,
        password: password,
      );

      final id = await _repository.registerUser(user);

      _currentUser = UserModel(
        id: id,
        name: user.name,
        email: user.email,
        password: user.password,
        course: user.course,
        semester: user.semester,
        university: user.university,
        createdAt: DateTime.now(),
      );

      return true;
    } catch (e) {
      _errorMessage =
      'Unable to create your account. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final user = await _repository.loginUser(
        email: email.trim().toLowerCase(),
        password: password,
      );

      if (user == null) {
        _errorMessage = 'Invalid email or password.';
        return false;
      }

      _currentUser = user;

      return true;
    } catch (e, stackTrace) {
      debugPrint('========== LOGIN ERROR ==========');
      debugPrint('Exception type: ${e.runtimeType}');
      debugPrint('Exception: $e');
      debugPrint('StackTrace: $stackTrace');
      debugPrint('==================================');

      _errorMessage = 'Login error: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }


  Future<bool> updateProfile({
    required String course,
    required int semester,
    required String university,
  }) async {
    if (_currentUser == null || _currentUser!.id == null) {
      _errorMessage = 'User information is missing.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.updateUserProfile(
        userId: _currentUser!.id!,
        course: course,
        semester: semester,
        university: university,
      );

      _currentUser = UserModel(
        id: _currentUser!.id,
        name: _currentUser!.name,
        email: _currentUser!.email,
        password: _currentUser!.password,
        course: course,
        semester: semester,
        university: university,
        createdAt: _currentUser!.createdAt,
      );

      return true;
    } catch (e) {
      debugPrint('PROFILE UPDATE ERROR: $e');

      _errorMessage = 'Unable to save your profile.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}