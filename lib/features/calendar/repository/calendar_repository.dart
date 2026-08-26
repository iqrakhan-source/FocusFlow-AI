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
    final sessions = await db.query(
      DatabaseConstants.studySessionsTable,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'started_at ASC',
    );

    for (final session in sessions) {
      events.add(
        CalendarEventModel(
          id: session['id'] as int?,
          userId: userId,
          title: session['subject'] as String,
          eventType: 'study',
          date: DateTime.parse(
            session['started_at'] as String,
          ),
          subject: session['subject'] as String,
          sessionType: session['session_type'] as String,
          isCompleted:
          (session['is_completed'] as int) == 1,
        ),
      );
    }

    // ASSIGNMENTS
    final assignments = await db.query(
      DatabaseConstants.assignmentsTable,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'due_date ASC',
    );

    for (final assignment in assignments) {
      events.add(
        CalendarEventModel(
          id: assignment['id'] as int?,
          userId: userId,
          title: assignment['title'] as String,
          eventType: 'assignment',
          date: DateTime.parse(
            assignment['due_date'] as String,
          ),
          subject: assignment['subject'] as String,
        ),
      );
    }

    // EXAMS
    final exams = await db.query(
      DatabaseConstants.examsTable,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'exam_date ASC',
    );

    for (final exam in exams) {
      events.add(
        CalendarEventModel(
          id: exam['id'] as int?,
          userId: userId,
          title: exam['title'] as String,
          eventType: 'exam',
          date: DateTime.parse(
            exam['exam_date'] as String,
          ),
          subject: exam['subject'] as String,
        ),
      );
    }

    // GOALS
    final goals = await db.query(
      DatabaseConstants.goalsTable,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'goal_date ASC',
    );

    for (final goal in goals) {
      final targetMinutes =
      goal['target_minutes'] as int;

      final completedMinutes =
      goal['completed_minutes'] as int;

      // Only add missed goals.
      if (completedMinutes < targetMinutes) {
        events.add(
          CalendarEventModel(
            id: goal['id'] as int?,
            userId: userId,
            title: goal['title'] as String,
            eventType: 'missed_goal',
            date: DateTime.parse(
              goal['goal_date'] as String,
            ),
          ),
        );
      }
    }

    // Keep calendar events ordered by date.
    events.sort(
          (a, b) => a.date.compareTo(b.date),
    );

    return events;
  }
}