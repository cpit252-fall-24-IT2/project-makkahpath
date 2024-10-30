import 'package:flutter/material.dart'; 


class SignInForm extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final Function onSignIn;
  final Function onNavigateToSignUp;

  // Constructor
  const SignInForm({
    Key? key,
    required this.usernameController,
    required this.passwordController,
    required this.onSignIn,
    required this.onNavigateToSignUp,
  }) : super(key: key); // Correctly call the superclass constructor

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              filled: true,
              fillColor: Colors.white.withOpacity(0.8),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              filled: true,
              fillColor: Colors.white.withOpacity(0.8),
            ),
            obscureText: true,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => onSignIn(),
            child: Text('Sign In'),
          ),
        ],
      ),
    );
  }
}