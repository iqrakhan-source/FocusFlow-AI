import '../../../core/services/database/app_database.dart';
import '../../../core/services/database/database_constant.dart';
import '../model/subject_model.dart';

class SubjectRepository {
  final AppDatabase _database;

  SubjectRepository({
    AppDatabase? database,
  }) : _database = database ?? AppDatabase.instance;

  Future<List<SubjectModel>> getSubjects(
      int userId,
      ) async {
    final db = await _database.database;

    final result = await db.query(
      DatabaseConstants.subjectsTable,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );

    return result
        .map((map) => SubjectModel.fromMap(map))
        .toList();
  }

  Future<int> addSubject(
      SubjectModel subject,
      ) async {
    final db = await _database.database;

    return db.insert(
      DatabaseConstants.subjectsTable,
      subject.toMap(),
    );
  }

  Future<int> deleteSubject(
      int subjectId,
      ) async {
    final db = await _database.database;

    return db.delete(
      DatabaseConstants.subjectsTable,
      where: 'id = ?',
      whereArgs: [subjectId],
    );
  }

  /*Future<bool> colorAlreadyUsed({
    required int userId,
    required String color,
  }) async {
    final db = await _database.database;

    final result = await db.query(
      DatabaseConstants.subjectsTable,
      columns: ['id'],
      where: 'user_id = ? AND color = ?',
      whereArgs: [userId, color],
      limit: 1,
    );

    return result.isNotEmpty;
  }*/
}