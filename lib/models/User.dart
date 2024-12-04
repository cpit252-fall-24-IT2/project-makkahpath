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
Future<void> updateUserProfile({
    String? username,
    String? password,
    String? email,
    String? phone,
  }) async {
    final db = await DatabaseHelper().database;

    final Map<String, dynamic> updates = {};
    if (username != null) updates['username'] = username;
    if (password != null) updates['password'] = password;
    if (email != null) updates['email'] = email;
    if (phone != null) updates['phone'] = phone;

    await db.update(
      'users',
      updates,
      where: 'username = ?',
      whereArgs: [User.username],
    );

    // Update static properties
    if (username != null) User.username = username;
    if (password != null) User.password = password;
    if (email != null) User.email = email;
    if (phone != null) User.phone = phone;

    print('Profile updated successfully!');
  }

  static String? getUsername() {
    return User.username; 
  }
}
