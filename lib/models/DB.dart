import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
    final path = join(dbPath, 'app_database.db');

    return await openDatabase(
      path,
      version: 3, // Updated version
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

        await db.execute('''
          CREATE TABLE ticket_counters (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            stop_name TEXT NOT NULL,
            time TEXT NOT NULL,
            counter INTEGER NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE tickets (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            stop_name TEXT NOT NULL,
            time TEXT NOT NULL,
            destination TEXT NOT NULL,
            qr_code TEXT NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          await db.execute('''
            CREATE TABLE tickets (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              stop_name TEXT NOT NULL,
              time TEXT NOT NULL,
              destination TEXT NOT NULL,
              qr_code TEXT NOT NULL
            )
          ''');
        }
      },
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

 Future<void> insertTicket(String stopName, String time, String destination, String qrCode) async {
    final db = await database;
    await db.insert(
      'tickets',
      {
        'stop_name': stopName,
        'time': time,
        'destination': destination,
        'qr_code': qrCode,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getTickets() async {
    final db = await database;
    return await db.query('tickets');
  }

  Future<void> clearTickets() async {
    final db = await database;
    await db.delete('tickets');
  }

  // Delete a ticket from the database
 Future<void> deleteTicket(int ticketId) async {
  final db = await database;
  await db.delete(
    'tickets', // Assuming table name is 'tickets'
    where: 'id = ?',
    whereArgs: [ticketId],
  );
}
  
  Future<void> closeDatabase() async {
    if (_database != null && isInitialized) {
      await _database!.close();
      isInitialized = false;
    }
  }


Future<void> decrementCounter(String destination, String time) async {
  final db = await database;

  // Get current counter
  final result = await db.query(
    'ticket_counters', // Assuming table name is 'ticket_counters'
    where: 'destination = ? AND time = ?',
    whereArgs: [destination, time],
  );

  if (result.isNotEmpty) {
    int currentCount = result.first['count'] as int;

    // Decrement the counter
    if (currentCount > 0) {
      await db.update(
        'ticket_counters',
        {'count': currentCount - 1},
        where: 'destination = ? AND time = ?',
        whereArgs: [destination, time],
      );
    }
  }
}
}