import 'package:flutter/foundation.dart';

import '../../../core/services/database/app_database.dart';
import '../model/assignment_model.dart';

class AssignmentRepository {
  final AppDatabase _database = AppDatabase.instance;

  Future<int> addAssignment(AssignmentModel assignment) async {
    final db = await _database.database;

    final id = await db.insert(
      'assignments',
      assignment.toMap(),
    );

    debugPrint('ASSIGNMENT INSERT RESULT: $id');

    return id;
  }

  Future<List<AssignmentModel>> getAssignments(int userId) async {
    final db = await _database.database;

    final result = await db.query(
      'assignments',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'due_date ASC',
    );

    return result
        .map((map) => AssignmentModel.fromMap(map))
        .toList();
  }

  Future<int> deleteAssignment(int id) async {
    final db = await _database.database;

    return await db.delete(
      'assignments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}