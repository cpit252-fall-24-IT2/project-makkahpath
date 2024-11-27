import 'package:flutter/material.dart';
import 'package:makkah_app/Screens/SignInPage.dart';
import 'package:makkah_app/Widgets/sign_up_widget.dart';
import 'package:makkah_app/models/DB.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  bool isPasswordValid = false;
  bool isEmailValid = true;
  bool isPhoneValid = true;
  
  // snack Bar error message
   void showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String? validateEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (regex.hasMatch(email)) {
      setState(() => isEmailValid = true);
      return null;
    } else {
      setState(() => isEmailValid = false);
      showErrorSnackbar('Invalid email format.');
      return 'Invalid email format.';
    }
  }

  String? validatePhone(String phone) {
    final regex = RegExp(r'^0[0-9]{9}$');
    if (regex.hasMatch(phone)) {
      setState(() => isPhoneValid = true);
      return null;
    } else {
      setState(() => isPhoneValid = false);
      showErrorSnackbar('Invalid phone format.');
      return 'Invalid phone format.';
    }
  }

  String? validatePassword(String password) {
    final regex = RegExp(r'^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[a-zA-Z0-9]).{7,}$');
    if (regex.hasMatch(password)) {
      setState(() => isPasswordValid = true);
      return null;
    } else {
      setState(() => isPasswordValid = false);
      showErrorSnackbar(
          'Password must contain at least 1 uppercase letter, at least 7 characters (letters and numbers), and 1 special character.');
      return 'Invalid password format.';
    }
  }

  Future<void> signUp() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final email = _emailController.text;
    final phone = _phoneController.text;
    final dbHelper = DatabaseHelper();

    // Validate email, phone, and password
    if (validateEmail(email) == null &&
        validatePhone(phone) == null &&
        validatePassword(password) == null) {
      // Proceed with user registration
      await dbHelper.insertUser(username, email, phone, password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User registered successfully! Please sign in.')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
      );
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
                    phoneController: _phoneController,
                    onSignUp: signUp,
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