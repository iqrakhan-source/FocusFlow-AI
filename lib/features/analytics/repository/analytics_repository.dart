
import '../../../core/services/database/app_database.dart';
import '../../../core/services/database/database_constant.dart';

class AnalyticsRepository {
  final AppDatabase _database = AppDatabase.instance;

  Future<int> getTotalStudyMinutes(int userId) async {
    final db = await _database.database;

    final result = await db.rawQuery('''
      SELECT COALESCE(SUM(duration_minutes), 0) AS total_minutes
      FROM ${DatabaseConstants.studySessionsTable}
      WHERE user_id = ?
        AND is_completed = 1
    ''', [userId]);

    return (result.first['total_minutes'] as num?)?.toInt() ?? 0;
  }

  Future<int> getTotalSessions(int userId) async {
    final db = await _database.database;

    final result = await db.rawQuery('''
      SELECT COUNT(*) AS total_sessions
      FROM ${DatabaseConstants.studySessionsTable}
      WHERE user_id = ?
        AND is_completed = 1
    ''', [userId]);

    return (result.first['total_sessions'] as num?)?.toInt() ?? 0;
  }

  Future<List<Map<String, dynamic>>> getStudyTimeBySubject(
      int userId,
      ) async {
    final db = await _database.database;

    return db.rawQuery('''
      SELECT
        subject,
        SUM(duration_minutes) AS total_minutes
      FROM ${DatabaseConstants.studySessionsTable}
      WHERE user_id = ?
        AND is_completed = 1
      GROUP BY subject
      ORDER BY total_minutes DESC
    ''', [userId]);
  }

  Future<List<Map<String, dynamic>>> getWeeklyStudyData(
      int userId,
      ) async {
    final db = await _database.database;

    return db.rawQuery('''
    SELECT
      started_at,
      duration_minutes
    FROM ${DatabaseConstants.studySessionsTable}
    WHERE user_id = ?
      AND is_completed = 1
      AND started_at >= ?
    ORDER BY started_at ASC
  ''', [
      userId,
      DateTime.now()
          .subtract(const Duration(days: 6))
          .toIso8601String(),
    ]);
  }

  Future<List<Map<String, dynamic>>> getMonthlyStudyData(
      int userId,
      ) async {
    final db = await _database.database;

    return db.rawQuery('''
    SELECT
      started_at,
      duration_minutes
    FROM ${DatabaseConstants.studySessionsTable}
    WHERE user_id = ?
      AND is_completed = 1
      AND started_at >= ?
    ORDER BY started_at ASC
  ''', [
      userId,
      DateTime(
        DateTime.now().year,
        DateTime.now().month,
        1,
      ).toIso8601String(),
    ]);
  }

  Future<List<String>> getStudyDates(int userId) async {
    final db = await _database.database;

    final result = await db.rawQuery('''
    SELECT DISTINCT started_at
    FROM ${DatabaseConstants.studySessionsTable}
    WHERE user_id = ?
      AND is_completed = 1
    ORDER BY started_at DESC
  ''', [userId]);

    return result
        .map((row) => row['started_at'] as String)
        .toList();
  }
  Future<List<Map<String, dynamic>>> getFiveWeekStudyData(
      int userId,
      ) async {
    final db = await _database.database;

    final startDate = DateTime.now().subtract(
      const Duration(days: 34),
    );

    return db.rawQuery('''
    SELECT
      started_at,
      duration_minutes
    FROM ${DatabaseConstants.studySessionsTable}
    WHERE user_id = ?
      AND is_completed = 1
      AND started_at >= ?
    ORDER BY started_at ASC
  ''', [
      userId,
      DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
      ).toIso8601String(),
    ]);
  }

  Future <List<Map<String,dynamic>>> getFocusTrendData(
      int userId,
      )async{
    final db = await _database.database;

    return db.rawQuery('''
    SELECT 
    started_at,
    duration_minutes
    FROM ${DatabaseConstants.studySessionsTable}
    WHERE user_id = ?
    AND is_completed = 1
    AND started_at >= ?
    ORDER BY started_at ASC
    ''',[
      userId,
      DateTime.now()
      .subtract(const Duration(days: 11))
      .toIso8601String(),
    ]);
  }

  Future<int> getCompletedGoals(int userId) async {
    final db = await _database.database;

    final result = await db.rawQuery('''
    SELECT COUNT(*) AS completed_goals
    FROM ${DatabaseConstants.goalsTable}
    WHERE user_id = ?
      AND completed_minutes >= target_minutes
  ''', [userId]);

    return (result.first['completed_goals'] as num?)?.toInt() ?? 0;
  }

  Future<int> getGoalCompletionPercentage(int userId) async {
    final db = await _database.database;

    final result = await db.rawQuery('''
    SELECT
      COUNT(*) AS total_goals,
      SUM(
        CASE
          WHEN completed_minutes >= target_minutes THEN 1
          ELSE 0
        END
      ) AS completed_goals
    FROM ${DatabaseConstants.goalsTable}
    WHERE user_id = ?
  ''', [userId]);

    final total =
        (result.first['total_goals'] as num?)?.toInt() ?? 0;

    final completed =
        (result.first['completed_goals'] as num?)?.toInt() ?? 0;

    if (total == 0) {
      return 0;
    }

    return ((completed / total) * 100).round();
  }



}