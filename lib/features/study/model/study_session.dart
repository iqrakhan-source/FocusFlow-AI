class StudySessionModel {
  final int? id;
  final int userId;
  final String subject;
  final String sessionType;
  final int durationMinutes;
  final DateTime startedAt;
  final DateTime? completedAt;
  final bool isCompleted;

  const StudySessionModel({
    this.id,
    required this.userId,
    required this.subject,
    required this.sessionType,
    required this.durationMinutes,
    required this.startedAt,
    this.completedAt,
    required this.isCompleted,
  });

  StudySessionModel copyWith({
    int? id,
    int? userId,
    String? subject,
    String? sessionType,
    int? durationMinutes,
    DateTime? startedAt,
    DateTime? completedAt,
    bool? isCompleted,
  }) {
    return StudySessionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      subject: subject ?? this.subject,
      sessionType: sessionType ?? this.sessionType,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'subject': subject,
      'session_type': sessionType,
      'duration_minutes': durationMinutes,
      'started_at': startedAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'is_completed': isCompleted ? 1 : 0,
    };
  }

  factory StudySessionModel.fromMap(Map<String, dynamic> map) {
    return StudySessionModel(
      id: map['id'],
      userId: map['user_id'],
      subject: map['subject'],
      sessionType: map['session_type'],
      durationMinutes: map['duration_minutes'],
      startedAt: DateTime.parse(map['started_at']),
      completedAt: map['completed_at'] != null
          ? DateTime.parse(map['completed_at'])
          : null,
      isCompleted: map['is_completed'] == 1,
    );
  }
}