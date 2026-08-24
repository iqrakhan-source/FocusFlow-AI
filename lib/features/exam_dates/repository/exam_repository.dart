import 'package:flutter/foundation.dart';

import '../../../core/services/database/app_database.dart';
import '../model/exam_model.dart';

class ExamRepository {
  final AppDatabase _database = AppDatabase.instance;

  Future<int> addExam(ExamModel exam) async {
    final db = await _database.database;

    final id = await db.insert(
      'exams',
      exam.toMap(),
    );

    debugPrint('EXAM INSERT RESULT: $id');

    return id;
  }
  Future<List<ExamModel>> getExams(int userId) async {
    final db = await _database.database;

    final result = await db.query(
      'exams',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'exam_date ASC',
    );

    return result
        .map((map) => ExamModel.fromMap(map))
        .toList();
  }

  Future<int> deleteExam(int id) async {
    final db = await _database.database;

    return await db.delete(
      'exams',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}