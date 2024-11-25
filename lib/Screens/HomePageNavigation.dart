import 'package:flutter/material.dart';
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
  Widget AccountButton() {
    return buttonRenderer.renderButton('Account', Icons.account_box, () {
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AccountScreen()),
      );
    });
  }
}