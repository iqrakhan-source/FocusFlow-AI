import '../../../core/services/database/app_database.dart';
import '../../../core/services/database/database_constant.dart';
import '../model/user_model.dart';

class AuthRepository {
  final AppDatabase _database;

  AuthRepository({
    AppDatabase? database,
  }) : _database = database ?? AppDatabase.instance;

  Future<bool> emailExists(String email) async {
    final db = await _database.database;

    final result = await db.query(
      DatabaseConstants.usersTable,
      columns: ['id'],
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  Future<int> registerUser(UserModel user) async {
    final db = await _database.database;

    final normalizedUser = UserModel(
      id: user.id,
      name: user.name,
      email: user.email.trim().toLowerCase(),
      password: user.password,
      course: user.course,
      semester: user.semester,
      university: user.university,
      createdAt: user.createdAt,
    );

    return db.insert(
      DatabaseConstants.usersTable,
      normalizedUser.toMap(),
    );
  }

  Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    final db = await _database.database;

    final result = await db.query(
      DatabaseConstants.usersTable,
      where: 'email = ? AND password = ?',
      whereArgs: [
        email,
        password,
      ],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return UserModel.fromMap(result.first);
  }


  Future<int> updateUserProfile({
    required int userId,
    required String course,
    required int semester,
    required String university,
  }) async {
    final db = await _database.database;

    return db.update(
      DatabaseConstants.usersTable,
      {
        'course': course,
        'semester': semester,
        'university': university,
      },
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
}