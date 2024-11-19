import 'package:flutter/material.dart';
import 'package:makkah_app/Screens/HomeScreen.dart';
import '../Widgets/sign_in_widget.dart';
import '../Screens/sign_up_page.dart'; 
import 'package:makkah_app/models/users.dart';
//-------------------------------------------------
class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Set<String> registeredUsers = {}; // In-memory storage for users

  void navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignUpPage(registeredUsers: registeredUsers),
      ),
    );
  }

  Future<void> signIn() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final dbHelper = DatabaseHelper();
    bool loginSuccess = await dbHelper.login(username, password);

    if (loginSuccess) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed. Incorrect username or password.')),
      );
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
          // Sign-In Form
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
                  SignInForm(
                    usernameController: _usernameController,
                    passwordController: _passwordController,
                    onSignIn: signIn,
                    onNavigateToSignUp: navigateToSignUp, // Add this line
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'If you do not have an account, please ',
                        style: TextStyle(color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: navigateToSignUp, // Navigate to Sign Up page
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
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