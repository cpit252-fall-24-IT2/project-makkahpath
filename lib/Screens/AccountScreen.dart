import 'package:flutter/material.dart';
import 'package:makkah_app/Screens/HomePageNavigation.dart';
import 'package:makkah_app/Widgets/BottomButton.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BottomButton renderer = BasicButtonRenderer();
    final HomePageNavigation pageNavigation = HomePageNavigation(context, renderer);
    
    return Scaffold(
      appBar: AppBar(title: Text('Account')),
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Account Info Button
            pageNavigation.AccountInfo(),
            
            SizedBox(height: 16), // Add spacing between buttons

            // Customer Service Button
            pageNavigation.CustomerService(),
          ],
        ),
      ),
      
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
            pageNavigation.AccountButton(),
          ],
        ),
      ),
    );
  }
}