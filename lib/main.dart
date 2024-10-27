import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bus Reservation',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SignInPage(),
    );
  }
}

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

  void signIn() {
    final username = _usernameController.text;

    if (registeredUsers.contains(username)) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username not registered. Please sign up.')),
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
            color: Colors.black.withOpacity(0.3),
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
                  SizedBox(height: 40), // Spacing between title and input fields
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: signIn,
                    child: Text('Sign In'),
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
                        onTap: navigateToSignUp,
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
      Navigator.pop(context); // Go back to SignInPage
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
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          // Sign-Up page
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
                  SizedBox(height: 40), // Spacing between title and input fields
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 10),
                  if (!isPasswordValid)
                    Text(
                      'Password must contain at least 1 uppercase letter, at least 7 characters (letters and numbers), and 1 special character.',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: signUp,
                    child: Text('Sign Up'),
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

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Welcome to the Bus Reservation System')),
    );
  }
}