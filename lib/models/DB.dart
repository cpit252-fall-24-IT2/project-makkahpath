import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;
  bool isInitialized = false;

  Future<Database> get database async {
    if (_database != null && isInitialized) return _database!;
    _database = await _initDatabase();
    isInitialized = true;
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'user_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            email TEXT NOT NULL,
            phone TEXT NOT NULL, 
            password TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // Insert data 
  Future<void> insertUser(
    String username, String email, String phone, String password) async {
    final db = await database;
    await db.insert(
      'users',
      {
        'username': username,
        'email': email,
        'phone': phone,
        'password': password,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Check login credentials
  Future<bool> login(String username, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    return false;
  }

  // Close database when not in use
  Future<void> closeDatabase() async {
    if (_database != null && isInitialized) {
      await _database!.close();
      isInitialized = false;
    }
  }
}