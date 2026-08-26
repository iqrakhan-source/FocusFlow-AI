class AssignmentModel {
  final int? id;
  final int userId;
  final String title;
  final String subject;
  final DateTime dueDate;

  AssignmentModel({
    this.id,
    required this.userId,
    required this.title,
    required this.subject,
    required this.dueDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'subject': subject,
      'due_date': dueDate.toIso8601String(),
    };
  }

  factory AssignmentModel.fromMap(Map<String, dynamic> map) {
    return AssignmentModel(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'],
      subject: map['subject'],
      dueDate: DateTime.parse(map['due_date']),
    );
  }
}