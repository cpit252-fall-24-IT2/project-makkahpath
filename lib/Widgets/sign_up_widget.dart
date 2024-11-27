import 'package:flutter/material.dart';

class SignUpForm extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final Function onSignUp;

  const SignUpForm({
    Key? key,
    required this.usernameController,
    required this.passwordController,
    required this.emailController,
    required this.phoneController,
    required this.onSignUp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Username Input
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              filled: true,
              fillColor: Colors.white.withOpacity(0.8),
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),

          // Email Input
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              filled: true,
              fillColor: Colors.white.withOpacity(0.8),
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 10),

          // Phone Input
          TextField(
            controller: phoneController,
            decoration: InputDecoration(
              labelText: 'Phone',
              filled: true,
              fillColor: Colors.white.withOpacity(0.8),
              prefixIcon: Icon(Icons.phone),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 10),

          // Password Input
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              filled: true,
              fillColor: Colors.white.withOpacity(0.8),
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          SizedBox(height: 20),

          // SignUp Button
          ElevatedButton(
            onPressed: () => onSignUp(),
            child: Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}