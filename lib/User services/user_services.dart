class User {
  final String username;
  final String password;

  User({required this.username, required this.password});

  // Validate password
  bool validatePassword() {
    final regex = RegExp(r'^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[A-Za-z0-9]).{7,}$');
    return regex.hasMatch(password);
  }
}