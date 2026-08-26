class CalendarEventModel {
  final int? id;
  final int userId;
  final String title;
  final String eventType;
  final DateTime date;
  final String? subject;
  final String? sessionType;
  final bool? isCompleted;

  const CalendarEventModel({
    this.id,
    required this.userId,
    required this.title,
    required this.eventType,
    required this.date,
    this.subject,
    this.sessionType,
    this.isCompleted,
  });
}