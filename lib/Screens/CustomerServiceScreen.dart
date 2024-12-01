import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:makkah_app/Screens/HomeScreen.dart';
import 'package:makkah_app/models/User.dart';
import 'package:makkah_app/models/env.dart';  
import 'package:http/http.dart' as http;

class CustomerServiceScreen extends StatelessWidget {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  // Function to send email using EmailJS
  Future sendEmail({
    required BuildContext context,
    required String subject,
    required String message,
    required String name,
    required String email,
  }) async {
    final serviceId = Env.serviceId; // Use the value from Env class
    final templateId = Env.templateId; // Use the value from Env class
    final userId = Env.userId; // Use the value from Env class
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    // Send request to EmailJS API
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'user_name': name,
          'user_email': email,
          'user_subject': subject,
          'user_message': message,
        },
      }),
    );

    if (response.statusCode == 200) {
      // Navigate to HomeScreen after successful email send
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email sent successfully')),
      );
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send email: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve User name and email from the User class
    String userName = User.username ?? 'Guest';
    String userEmail = User.email ?? 'Guest@gmail.com';

    return Scaffold(
      appBar: AppBar(title: Text('Customer Service')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: TextEditingController(text: userName),
              decoration: InputDecoration(labelText: 'Name'),
              enabled: false,
            ),
            TextFormField(
              controller: TextEditingController(text: userEmail),
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              enabled: false,
            ),
            TextFormField(
              controller: _subjectController,
              decoration: InputDecoration(labelText: 'Subject'),
            ),
            TextFormField(
              controller: _messageController,
              decoration: InputDecoration(labelText: 'Message'),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_subjectController.text.isNotEmpty &&
                    _messageController.text.isNotEmpty) {
                  sendEmail(
                    context: context,
                    name: userName,
                    email: userEmail,
                    subject: _subjectController.text,
                    message: _messageController.text,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill in all fields')),
                  );
                }
              },
              child: Text('Send Email'),
            ),
          ],
        ),
      ),
    );
  }
}
