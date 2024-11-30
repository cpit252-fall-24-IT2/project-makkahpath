import 'package:flutter/material.dart';
import 'package:makkah_app/Screens/AccountInfoScreen.dart';
import 'package:makkah_app/Screens/CustomerServiceScreen.dart';
import 'package:makkah_app/Screens/SignInPage.dart';
import 'package:makkah_app/Widgets/BottomButton.dart';
import '../models/PageNavigation.dart';
import 'TicketsScreen.dart';
import 'AccountScreen.dart';
import 'HomeScreen.dart';

class HomePageNavigation implements PageNavigation {
  final BuildContext context;
  final BottomButton buttonRenderer;

  HomePageNavigation(this.context, this.buttonRenderer);

  @override
  Widget HomeButton() {
    return buttonRenderer.renderButton('Home', Icons.home, () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget TicketsButton() {
    return buttonRenderer.renderButton('My Tickets', Icons.directions_bus, () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TicketsScreen()),
      );
    });
  }

  @override
  Widget SettingsButton() {
    return buttonRenderer.renderButton('Settings', Icons.settings, () {
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AccountScreen()),
      );
    });
  }

 @override
Widget AccountInfo() {
  return SizedBox(
    width: 250, // button width
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Rounded corners
        ),
        padding: EdgeInsets.symmetric(vertical: 25), // height
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AccountInfoScreen()),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Center the content
        children: [
          Icon(Icons.account_box, size: 25), // Account icon
          SizedBox(width: 10), // Space between icon and text
          Text(
            'Account Information',
            style: TextStyle(fontSize: 17),
          ),
        ],
      ),
    ),
  );
}

  @override
  Widget CustomerService(){
    return SizedBox(
    width: 250, // button width
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Rounded corners
        ),
        padding: EdgeInsets.symmetric(vertical: 25), // height
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CustomerServiceScreen()),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Center the content
        children: [
          Icon(Icons.support_agent, size: 25), // Customer service icon
          SizedBox(width: 10), // Space between icon and text
          Text(
            'Customer Service',
            style: TextStyle(fontSize: 17),
          ),
        ],
      ),
    ),
  );
 }

  @override 
  Widget SignOut(){
    return SizedBox(
    width: 250, // button width
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Rounded corners
        ),
        padding: EdgeInsets.symmetric(vertical: 25), // height
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Center the content
        children: [
          Icon(Icons.logout, size: 25), // Sign out icon
          SizedBox(width: 10), // Space between icon and text
          Text(
            'Sign Out',
            style: TextStyle(fontSize: 17),
          ),
        ],
      ),
    ),
  );
 }
}