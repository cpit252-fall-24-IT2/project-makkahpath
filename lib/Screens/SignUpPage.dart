import 'package:flutter/material.dart';
import 'package:makkah_app/Screens/SignInPage.dart';
import 'package:makkah_app/Widgets/sign_up_widget.dart';
import 'package:makkah_app/models/users.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool isPasswordValid = false;
  bool isEmailValid = true;

  // Email format validation
  String? validateEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (regex.hasMatch(email)) {
      setState(() => isEmailValid = true);
      return null;
    } else {
      setState(() => isEmailValid = false);
      return null;
    }
  }

  // Password format validation
  String? validatePassword(String password) {
    final regex = RegExp(r'^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[A-Za-z0-9]).{7,}$');
    if (regex.hasMatch(password)) {
      setState(() => isPasswordValid = true);
      return null;
    } else {
      setState(() => isPasswordValid = false);
      return 'Password must contain at least 1 uppercase letter, at least 7 characters (letters and numbers), and 1 special character.';
    }
  }

  Future<void> signUp() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final email = _emailController.text;
    final dbHelper = DatabaseHelper();

    // Validate email and password
    if (validateEmail(email) == null && validatePassword(password) == null) {
      // Attempt to insert the user
      bool success = await dbHelper.insertUser(username, email, password);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User registered successfully! Please sign in.')),
        );
        // Navigate to SignInPage after successful registration
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()),
        );
       
    } else {
      // Show error messages for invalid inputs
      if (!isEmailValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid email format.')),
        );
      }
      if (!isPasswordValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid password format.')),
        );
      }
    }

    await dbHelper.closeDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Burg_Al-Saa background.JPG'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi-transparent overlay
          Container(
            color: Colors.black.withOpacity(0.2),
          ),
          // Sign-Up Form
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Makkah Path',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(color: Colors.black54, blurRadius: 10, offset: Offset(2, 2)),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  SignUpForm(
                    usernameController: _usernameController,
                    passwordController: _passwordController,
                    emailController: _emailController,
                    onSignUp: signUp,
                  ),
                  SizedBox(height: 10),
                  if (!isPasswordValid)
                    Text(
                      'Password must contain at least 1 uppercase letter, at least 7 characters (letters and numbers), and 1 special character.',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  if (!isEmailValid)
                    Text(
                      'Invalid email format.',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'If you already have an account, please ',
                        style: TextStyle(color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}