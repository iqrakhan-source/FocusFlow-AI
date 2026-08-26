import 'package:flutter/foundation.dart';

import '../../../core/services/database/app_database.dart';
import '../model/study_session.dart';

class StudySessionRepository {
  final AppDatabase _database = AppDatabase.instance;

  Future<int> addSession(StudySessionModel session) async {
    final db = await _database.database;

    final id = await db.insert(
      'study_sessions',
      session.toMap(),
    );

    debugPrint('STUDY SESSION INSERT RESULT: $id');

    return id;
  }

  Future<List<StudySessionModel>> getSessions(int userId) async {
    final db = await _database.database;

    final result = await db.query(
      'study_sessions',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'started_at DESC',
    );

    return result
        .map((map) => StudySessionModel.fromMap(map))
        .toList();
  }

  Future<int> deleteSession(int id) async {
    final db = await _database.database;

    return await db.delete(
      'study_sessions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}