import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
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
            password TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // Insert new user and return a bool indicating success or failure
Future<bool> insertUser(String username, String email, String password) async {
  final db = await database;
  try {
    final result = await db.insert(
      'users',
      {'username': username, 'email': email, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    // If the result is greater than 0, the insert was successful
    return result > 0;
  } catch (e) {
    return false;
  }
}

  // Check login
  Future<bool> login(String username, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty;
  }

  // Close the database
  Future<void> closeDatabase() async {
    if (_database != null && isInitialized) {
      await _database!.close();
      isInitialized = false;
    }
  }

  
}