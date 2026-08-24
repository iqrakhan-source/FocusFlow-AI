class StudySessionModel {
  final String subject;
  final String sessionType;
  final int durationMinutes;
  final DateTime startedAt;
  final DateTime? completedAt;
  final bool isCompleted;

  const StudySessionModel({
    required this.subject,
    required this.sessionType,
    required this.durationMinutes,
    required this.startedAt,
    this.completedAt,
    required this.isCompleted,
  });

  StudySessionModel copyWith({
    String? subject,
    String? sessionType,
    int? durationMinutes,
    DateTime? startedAt,
    DateTime? completedAt,
    bool? isCompleted,
  }) {
    return StudySessionModel(
      subject: subject ?? this.subject,
      sessionType: sessionType ?? this.sessionType,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}