import 'package:flutter/material.dart';
import 'package:makkah_app/Screens/EditAccountInfoScreen.dart';
import 'package:makkah_app/Screens/HomePageNavigation.dart';
import 'package:makkah_app/Widgets/BottomButton.dart';
import 'package:makkah_app/models/User.dart';

class AccountInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Replace these with the actual user details from your User class.
    final String? username = User.username;
    final String? email = User.email;
    final String? phone = User.phone;
    // Objects for bottom buttons
    final BottomButton renderer = BasicButtonRenderer();
    final HomePageNavigation pageNavigation =HomePageNavigation(context, renderer);

    return Scaffold(
      appBar: AppBar(
        title: Text('Account Information'),
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
      //---------
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Username: $username',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Email: $email',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Phone: $phone',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the Edit Info screen.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditAccountInfoScreen(),
                    ),
                  );
                },
                child: Text('Edit Information'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
