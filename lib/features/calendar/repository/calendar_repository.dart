import '../../../core/services/database/app_database.dart';
import '../../../core/services/database/database_constant.dart';
import '../model/calendar_event_model.dart';

class CalendarRepository {
  final AppDatabase _database = AppDatabase.instance;

  Future<List<CalendarEventModel>> getEvents(
    int userId,
  ) async {
    final db = await _database.database;

    final events = <CalendarEventModel>[];

    // STUDY SESSIONS
    try {
      final sessions = await db.query(
        DatabaseConstants.studySessionsTable,
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'started_at ASC',
      );

      for (final session in sessions) {
        final dateStr = session['started_at'] as String?;
        if (dateStr != null) {
          events.add(
            CalendarEventModel(
              id: session['id'] as int?,
              userId: userId,
              title: session['subject'] as String? ?? 'Study Session',
              eventType: 'study',
              date: DateTime.parse(dateStr).toLocal(),
              subject: session['subject'] as String?,
              sessionType: session['session_type'] as String?,
              isCompleted: session['is_completed'] == 1,
            ),
          );
        }
      }
    } catch (_) {}

    // ASSIGNMENTS
    try {
      final assignments = await db.query(
        DatabaseConstants.assignmentsTable,
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'due_date ASC',
      );

      for (final assignment in assignments) {
        final dateStr = assignment['due_date'] as String?;
        if (dateStr != null) {
          events.add(
            CalendarEventModel(
              id: assignment['id'] as int?,
              userId: userId,
              title: assignment['title'] as String? ?? 'Assignment',
              eventType: 'assignment',
              date: DateTime.parse(dateStr).toLocal(),
              subject: assignment['subject'] as String?,
            ),
          );
        }
      }
    } catch (_) {}

    // EXAMS
    try {
      final exams = await db.query(
        DatabaseConstants.examsTable,
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'exam_date ASC',
      );

      for (final exam in exams) {
        final dateStr = exam['exam_date'] as String?;
        if (dateStr != null) {
          events.add(
            CalendarEventModel(
              id: exam['id'] as int?,
              userId: userId,
              title: exam['title'] as String? ?? 'Exam',
              eventType: 'exam',
              date: DateTime.parse(dateStr).toLocal(),
              subject: exam['subject'] as String?,
            ),
          );
        }
      }
    } catch (_) {}

    // GOALS
    try {
      final goals = await db.query(
        DatabaseConstants.goalsTable,
        where: 'user_id = ?',
        whereArgs: [userId],
      );

      for (final goal in goals) {
        final targetMinutes = (goal['target_minutes'] as num?)?.toInt() ?? 0;
        final completedMinutes = (goal['completed_minutes'] as num?)?.toInt() ?? 0;
        final goalDateStr = (goal['goal_date'] ?? goal['created_at']) as String?;

        if (completedMinutes < targetMinutes && goalDateStr != null) {
          events.add(
            CalendarEventModel(
              id: goal['id'] as int?,
              userId: userId,
              title: goal['title'] as String? ?? 'Goal',
              eventType: 'missed_goal',
              date: DateTime.parse(goalDateStr).toLocal(),
            ),
          );
        }
      }
    } catch (_) {}

    // Keep calendar events ordered by date.
    events.sort(
      (a, b) => a.date.compareTo(b.date),
    );

    return events;
  }
}