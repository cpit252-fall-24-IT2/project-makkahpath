import 'package:makkah_app/models/DB.dart';

class User {
  static String? username;
  static String? email;
  static String? phone;
  static String? password;

  /// Retrieve and store user details after successful login
  static Future<bool> signIn({required String username, required String password}) async {
    final dbHelper = DatabaseHelper();

    // Attempt login and fetch user details
    final userData = await dbHelper.login(username, password);

    if (userData != null) {
      // Update static properties
      User.username = userData['username'];
      User.email = userData['email'];
      User.phone = userData['phone'];
      User.password = userData['password'];
      return true; // Login successful
    }

    return false; // Login failed
  }

// Example update operation
Future<void> updateUserProfile(String newEmail, String newPhone) async {
  final db = await DatabaseHelper().database;

  await db.update(
    'users',
    {'email': newEmail, 'phone': newPhone},
    where: 'username = ?',
    whereArgs: [User.username],
  );

  // Update static properties
  User.email = newEmail;
  User.phone = newPhone;

  print('Profile updated successfully!');
}
}