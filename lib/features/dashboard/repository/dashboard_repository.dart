import '../../../core/services/database/app_database.dart';
import '../../../core/services/database/database_constant.dart';

class DashboardRepository {
  final AppDatabase _database = AppDatabase.instance;

  // ---------------- TODAY'S STUDY TIME ----------------

  Future<int> getTodayStudyMinutes(int userId) async {
    final db = await _database.database;

    final result = await db.rawQuery('''
      SELECT COALESCE(SUM(duration_minutes), 0) AS total_minutes
      FROM ${DatabaseConstants.studySessionsTable}
      WHERE user_id = ?
        AND is_completed = 1
        AND date(started_at) = date('now', 'localtime')
    ''', [userId]);

    return (result.first['total_minutes'] as num?)?.toInt() ?? 0;
  }

  // ---------------- TODAY'S STUDY SESSIONS ----------------

  Future<List<Map<String, dynamic>>> getTodaySessions(
      int userId,
      ) async {
    final db = await _database.database;

    return db.rawQuery('''
      SELECT *
      FROM ${DatabaseConstants.studySessionsTable}
      WHERE user_id = ?
        AND date(started_at) = date('now', 'localtime')
      ORDER BY started_at ASC
    ''', [userId]);
  }

  // ---------------- UPCOMING EXAMS ----------------

  Future<List<Map<String, dynamic>>> getUpcomingExams(
      int userId,
      ) async {
    final db = await _database.database;

    return db.rawQuery('''
      SELECT *
      FROM ${DatabaseConstants.examsTable}
      WHERE user_id = ?
        AND date(exam_date) >= date('now', 'localtime')
      ORDER BY exam_date ASC
    ''', [userId]);
  }

  // ---------------- UPCOMING ASSIGNMENTS ----------------

  Future<List<Map<String, dynamic>>> getUpcomingAssignments(
      int userId,
      ) async {
    final db = await _database.database;

    return db.rawQuery('''
      SELECT *
      FROM ${DatabaseConstants.assignmentsTable}
      WHERE user_id = ?
        AND date(due_date) >= date('now', 'localtime')
      ORDER BY due_date ASC
    ''', [userId]);
  }

  // ---------------- TODAY'S GOAL ----------------

  Future<Map<String, dynamic>?> getTodayGoal(
      int userId,
      ) async {
    final db = await _database.database;

    final result = await db.rawQuery('''
    SELECT *
    FROM ${DatabaseConstants.goalsTable}
    WHERE user_id = ?
      AND date(goal_date) = date('now', 'localtime')
    ORDER BY created_at DESC
    LIMIT 1
  ''', [userId]);

    if (result.isEmpty) {
      return null;
    }

    return result.first;
  }

  //STREAK
  Future<List<String>> getStudyDates(int userId) async {
    final db = await _database.database;

    final result = await db.rawQuery('''
    SELECT DISTINCT date(started_at) AS study_date
    FROM ${DatabaseConstants.studySessionsTable}
    WHERE user_id = ?
      AND is_completed = 1
    ORDER BY started_at DESC
  ''', [userId]);

    return result
        .map((row) => row['started_at'] as String)
        .toList();
  }


}