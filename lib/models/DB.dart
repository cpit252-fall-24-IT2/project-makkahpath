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
      version: 2, // Update version to 2 for schema migration
      onCreate: (db, version) async {
        // Create users table
        await db.execute(''' 
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            email TEXT NOT NULL,
            phone TEXT NOT NULL, 
            password TEXT NOT NULL
          )
        ''');

        // Create ticket counters table
        await db.execute(''' 
          CREATE TABLE ticket_counters (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            stop_name TEXT NOT NULL,
            time TEXT NOT NULL,
            counter INTEGER NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Add the ticket_counters table in version 2
          await db.execute(''' 
            CREATE TABLE ticket_counters (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              stop_name TEXT NOT NULL,
              time TEXT NOT NULL,
              counter INTEGER NOT NULL
            )
          ''');
        }
      },
    );
  }

  // Insert or update a ticket counter in the database
  Future<void> insertOrUpdateTicketCounter(String stopName, String time, int counter) async {
    final db = await database;

    // Check if the ticket counter already exists
    final existingCounter = await db.query(
      'ticket_counters',
      where: 'stop_name = ? AND time = ?',
      whereArgs: [stopName, time],
    );

    if (existingCounter.isEmpty) {
      // Insert new ticket counter if it doesn't exist
      await db.insert(
        'ticket_counters',
        {
          'stop_name': stopName,
          'time': time,
          'counter': counter,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      // Update the counter if it already exists
      await db.update(
        'ticket_counters',
        {'counter': counter},
        where: 'stop_name = ? AND time = ?',
        whereArgs: [stopName, time],
      );
    }
  }

  // Load the counter for a specific stop_name and time
  Future<int> getTicketCounter(String stopName, String time) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'ticket_counters',
      where: 'stop_name = ? AND time = ?',
      whereArgs: [stopName, time],
    );

    if (result.isNotEmpty) {
      return result.first['counter'];
    }

    // Return 0 if no counter found
    return 0;
  }

  // Insert a new user (for sign-in and registration)
  Future<void> insertUser(String username, String email, String phone, String password) async {
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
  Future<Map<String, dynamic>?> login(String username, String password) async {
    final db = await database;

    // Query the database for matching username and password
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      // Return the first matching user's data
      return result.first;
    }

    // Return null if no match found
    return null;
  }

  // Close the database when not in use
  Future<void> closeDatabase() async {
    if (_database != null && isInitialized) {
      await _database!.close();
      isInitialized = false;
    }
  }
}
