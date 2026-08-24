class ProfileModel {
  final String name;
  final String course;
  final String semester;
  final String university;
  final int dailyStudyGoal;
  final bool notificationsEnabled;
  final String aiInsight;

  const ProfileModel({
    required this.name,
    required this.course,
    required this.semester,
    required this.university,
    required this.dailyStudyGoal,
    required this.notificationsEnabled,
    required this.aiInsight,
  });
}