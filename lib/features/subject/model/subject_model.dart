class SubjectModel {
  final int? id;
  final int userId;
  final String name;
  final String courseCode;
  final int colorValue;
  final DateTime createdAt;

  const SubjectModel({
    this.id,
    required this.userId,
    required this.name,
    required this.courseCode,
    required this.colorValue,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'course_code': courseCode,
      'color': colorValue,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      name: map['name'] as String,
      courseCode: map['course_code'] as String,
      colorValue: map['color'] as int,
      createdAt: DateTime.parse(
        map['created_at'] as String,
      ),
    );
  }

  SubjectModel copyWith({
    int? id,
    int? userId,
    String? name,
    String? courseCode,
    int? colorValue,
    DateTime? createdAt,
  }) {
    return SubjectModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      courseCode: courseCode ?? this.courseCode,
      colorValue: colorValue ?? this.colorValue,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}