import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'database_constant.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(
      databasePath,
      DatabaseConstants.databaseName,
    );

    return openDatabase(
      path,
      version: DatabaseConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(
      Database db,
      int version,
      ) async {
    // USERS
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.usersTable} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        course TEXT,
        semester INTEGER,
        university TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // SUBJECTS
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.subjectsTable} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        course_code TEXT,
        color INTEGER NOT NULL,
        created_at TEXT NOT NULL,

        FOREIGN KEY (user_id)
          REFERENCES ${DatabaseConstants.usersTable} (id)
          ON DELETE CASCADE
      )
    ''');

    // EXAMS
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.examsTable} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        subject TEXT NOT NULL,
        exam_date TEXT NOT NULL,

        FOREIGN KEY (user_id)
          REFERENCES ${DatabaseConstants.usersTable} (id)
          ON DELETE CASCADE
      )
    ''');

    //ASSIGNMENT

    await db.execute('''
  CREATE TABLE ${DatabaseConstants.assignmentsTable} (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    title TEXT NOT NULL,
    subject TEXT NOT NULL,
    due_date TEXT NOT NULL,

    FOREIGN KEY (user_id)
      REFERENCES ${DatabaseConstants.usersTable} (id)
      ON DELETE CASCADE
  )
''');


    //SESSION

    await db.execute('''
  CREATE TABLE ${DatabaseConstants.studySessionsTable} (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    subject TEXT NOT NULL,
    session_type TEXT NOT NULL,
    duration_minutes INTEGER NOT NULL,
    started_at TEXT NOT NULL,
    completed_at TEXT,
    is_completed INTEGER NOT NULL,

    FOREIGN KEY (user_id)
      REFERENCES ${DatabaseConstants.usersTable} (id)
      ON DELETE CASCADE
  )
''');

    //GOALS

    await db.execute('''
  CREATE TABLE ${DatabaseConstants.goalsTable} (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    title TEXT NOT NULL,
    target_minutes INTEGER NOT NULL,
    completed_minutes INTEGER NOT NULL DEFAULT 0,
    created_at TEXT NOT NULL,

    FOREIGN KEY (user_id)
      REFERENCES ${DatabaseConstants.usersTable} (id)
      ON DELETE CASCADE
  )
''');

    //REFLECTION

    await db.execute('''
  CREATE TABLE ${DatabaseConstants.reflectionsTable} (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    mood TEXT NOT NULL,
    stress_level INTEGER NOT NULL,
    sleep_hours REAL NOT NULL,
    achievement TEXT NOT NULL,
    distraction TEXT NOT NULL,
    created_at TEXT NOT NULL,

    FOREIGN KEY (user_id)
      REFERENCES ${DatabaseConstants.usersTable} (id)
      ON DELETE CASCADE
  )
''');

  }

  Future<void> _onUpgrade(
      Database db,
      int oldVersion,
      int newVersion,
      ) async {
    if (oldVersion < 5) {
      await db.execute('''
        CREATE TABLE ${DatabaseConstants.examsTable} (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          title TEXT NOT NULL,
          subject TEXT NOT NULL,
          exam_date TEXT NOT NULL,

          FOREIGN KEY (user_id)
            REFERENCES ${DatabaseConstants.usersTable} (id)
            ON DELETE CASCADE
        )
      ''');
    }
    if (oldVersion < 6) {
      await db.execute('''
    CREATE TABLE ${DatabaseConstants.assignmentsTable} (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      title TEXT NOT NULL,
      subject TEXT NOT NULL,
      due_date TEXT NOT NULL,

      FOREIGN KEY (user_id)
        REFERENCES ${DatabaseConstants.usersTable} (id)
        ON DELETE CASCADE
    )
  ''');
    }
    if (oldVersion < 7) {
      await db.execute('''
    CREATE TABLE ${DatabaseConstants.studySessionsTable} (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      subject TEXT NOT NULL,
      session_type TEXT NOT NULL,
      duration_minutes INTEGER NOT NULL,
      started_at TEXT NOT NULL,
      completed_at TEXT,
      is_completed INTEGER NOT NULL,

      FOREIGN KEY (user_id)
        REFERENCES ${DatabaseConstants.usersTable} (id)
        ON DELETE CASCADE
    )
  ''');
    }

    if (oldVersion < 8) {
      // GOALS
      await db.execute('''
  CREATE TABLE ${DatabaseConstants.goalsTable} (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    title TEXT NOT NULL,
    target_minutes INTEGER NOT NULL,
    completed_minutes INTEGER NOT NULL DEFAULT 0,
    goal_date TEXT NOT NULL,
    created_at TEXT NOT NULL,

    FOREIGN KEY (user_id)
      REFERENCES ${DatabaseConstants.usersTable} (id)
      ON DELETE CASCADE
  )
''');
    }

    if (oldVersion < 9) {
      await db.execute('''
    CREATE TABLE ${DatabaseConstants.reflectionsTable} (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      mood TEXT NOT NULL,
      stress_level INTEGER NOT NULL,
      sleep_hours REAL NOT NULL,
      achievement TEXT NOT NULL,
      distraction TEXT NOT NULL,
      created_at TEXT NOT NULL,

      FOREIGN KEY (user_id)
        REFERENCES ${DatabaseConstants.usersTable} (id)
        ON DELETE CASCADE
    )
  ''');
    }
  }
}