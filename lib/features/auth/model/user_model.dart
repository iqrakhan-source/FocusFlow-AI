class UserModel {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String? course;
  final int? semester;
  final String? university;
  final DateTime? createdAt;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.course,
    this.semester,
    this.university,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'course': course,
      'semester': semester,
      'university': university,
      'created_at':
      (createdAt ?? DateTime.now()).toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      course: map['course'] as String?,
      semester: map['semester'] as int?,
      university: map['university'] as String?,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
    );
  }
}