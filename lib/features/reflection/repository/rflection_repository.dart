import 'package:flutter/foundation.dart';

import '../../../core/services/database/app_database.dart';
import '../../../core/services/database/database_constant.dart';
import '../model/reflection_model.dart';

class ReflectionRepository {
  final AppDatabase _database = AppDatabase.instance;

  Future<int> addReflection(
      ReflectionModel reflection,
      ) async {
    final db = await _database.database;

    final id = await db.insert(
      DatabaseConstants.reflectionsTable,
      reflection.toMap(),
    );

    debugPrint(
      'REFLECTION INSERT RESULT: $id',
    );

    return id;
  }

  Future<List<ReflectionModel>> getReflections(
      int userId,
      ) async {
    final db = await _database.database;

    final result = await db.query(
      DatabaseConstants.reflectionsTable,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );

    return result
        .map(
          (map) => ReflectionModel.fromMap(map),
    )
        .toList();
  }

  Future<int> deleteReflection(int id) async {
    final db = await _database.database;

    return db.delete(
      DatabaseConstants.reflectionsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}