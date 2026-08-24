class ExamModel {
  final int? id;
  final int userId;
  final String title;
  final String subject;
  final DateTime examDate;

  ExamModel({
    this.id,
    required this.userId,
    required this.title,
    required this.subject,
    required this.examDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'subject': subject,
      'exam_date': examDate.toIso8601String(),
    };
  }

  factory ExamModel.fromMap(Map<String, dynamic> map) {
    return ExamModel(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'],
      subject: map['subject'],
      examDate: DateTime.parse(map['exam_date']),
    );
  }
}