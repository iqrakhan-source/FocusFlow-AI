import 'package:flutter/material.dart';

import '../../auth/viewmodel/auth_viewmodel.dart';
import '../model/profile_model.dart';

class ProfileViewModel extends ChangeNotifier {
  final AuthViewModel authViewModel;

  ProfileViewModel({
    required this.authViewModel,
  });

  ProfileModel get profile {
    final user = authViewModel.currentUser;

    return ProfileModel(
      name: user?.name ?? '',
      course: user?.course ?? '',
      semester: user?.semester != null
          ? 'Semester ${user!.semester}'
          : '',
      university: user?.university ?? '',
      dailyStudyGoal: 5,
      notificationsEnabled: true,
      aiInsight:
      "Your study insights will appear here as you build your study history.",
    );
  }

  String get name => profile.name;

  String get course => profile.course;

  String get semester => profile.semester;

  String get university => profile.university;

  int get dailyStudyGoal => profile.dailyStudyGoal;

  bool get notificationsEnabled =>
      profile.notificationsEnabled;

  String get aiInsight => profile.aiInsight;

  void setNotifications(bool value) {
    // We'll connect this to SQLite later.
    notifyListeners();
  }

  void updateDailyStudyGoal(int hours) {
    // We'll connect this to SQLite later.
    notifyListeners();
  }
}