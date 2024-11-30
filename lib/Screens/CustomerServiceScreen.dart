import 'package:flutter/material.dart';
import 'package:makkah_app/Screens/HomePageNavigation.dart';
import 'package:makkah_app/Widgets/BottomButton.dart';

class CustomerServiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Objects for bottom buttons
    final BottomButton renderer = BasicButtonRenderer();
    final HomePageNavigation pageNavigation = HomePageNavigation(context, renderer);

    return Scaffold(
      appBar: AppBar(title: Text('Customer Service')),
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
    );
  }
}
