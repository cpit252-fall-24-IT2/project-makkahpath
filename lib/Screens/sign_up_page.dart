import 'package:flutter/material.dart';
import '../Widgets/sign_up_widget.dart';

class SignUpPage extends StatefulWidget {
  final Set<String> registeredUsers;

  SignUpPage({required this.registeredUsers});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isPasswordValid = false;

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

  void signUp() {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (validatePassword(password) == null) {
      widget.registeredUsers.add(username);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User registered successfully! Please sign in.')),
      );
      Navigator.pop(context);
    }
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
                image: AssetImage('assets/Burg_Al-Saa background.JPG'), // Your background image
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
                    'Makkah Path', // App name at the top center
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(color: Colors.black54, blurRadius: 10, offset: Offset(2, 2)),
                      ],
                    ),
                  ),
                  SizedBox(height: 40), // Spacing between title and input fields
                  SignUpForm(
                    usernameController: _usernameController,
                    passwordController: _passwordController,
                    onSignUp: signUp,
                  ),
                  SizedBox(height: 10),
                  if (!isPasswordValid)
                    Text(
                      'Password must contain at least 1 uppercase letter, at least 7 characters (letters and numbers), and 1 special character.',
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
                        onTap: () => Navigator.pop(context), // Navigates back to SignInPage
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