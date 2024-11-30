import 'package:flutter/material.dart';
import 'package:makkah_app/Screens/HomePageNavigation.dart';
import 'package:makkah_app/Widgets/BottomButton.dart';
import 'package:makkah_app/models/User.dart';


class EditAccountInfoScreen extends StatefulWidget {
  @override
  _EditAccountInfoScreenState createState() => _EditAccountInfoScreenState();
}

class _EditAccountInfoScreenState extends State<EditAccountInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _newUsername;
  String? _newPassword;
  String? _newEmail;
  String? _newPhone;

    
  @override
  Widget build(BuildContext context) {
    // Objects for bottom buttons
    final BottomButton renderer = BasicButtonRenderer();
    final HomePageNavigation pageNavigation =HomePageNavigation(context, renderer);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Account Information'),
      ),
      // bottom bar navigation
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            pageNavigation.HomeButton(),
            pageNavigation.TicketsButton(),
            pageNavigation.SettingsButton(),
          ],
        ),
      ),
      //------------
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: User.username,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
                onSaved: (value) {
                  _newUsername = value;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
                onSaved: (value) {
                  _newPassword = value;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: User.email,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _newEmail = value;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: User.phone,
                decoration: InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _newPhone = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Call the updated updateUserProfile method
                    await User().updateUserProfile(
                      username: _newUsername,
                      password: _newPassword,
                      email: _newEmail,
                      phone: _newPhone,
                    );

                    Navigator.pop(context);
                  }
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}