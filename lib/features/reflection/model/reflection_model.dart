class ReflectionModel {
  final int? id;
  final int userId;
  final String mood;
  final int stressLevel;
  final double sleepHours;
  final String achievement;
  final String distraction;
  final DateTime createdAt;

  const ReflectionModel({
    this.id,
    required this.userId,
    required this.mood,
    required this.stressLevel,
    required this.sleepHours,
    required this.achievement,
    required this.distraction,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'mood': mood,
      'stress_level': stressLevel,
      'sleep_hours': sleepHours,
      'achievement': achievement,
      'distraction': distraction,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory ReflectionModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return ReflectionModel(
      id: map['id'],
      userId: map['user_id'],
      mood: map['mood'],
      stressLevel: map['stress_level'],
      sleepHours: (map['sleep_hours'] as num).toDouble(),
      achievement: map['achievement'],
      distraction: map['distraction'],
      createdAt: DateTime.parse(
        map['created_at'],
      ),
    );
  }
}