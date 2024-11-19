import 'package:flutter/material.dart';
import 'package:makkah_app/Widgets/BottomButton.dart';
import '../models/PageNavigation.dart';
import 'TicketsScreen.dart';
import 'SettingsScreen.dart';
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
    return buttonRenderer.renderButton('Tickets', Icons.directions_bus, () {
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
        MaterialPageRoute(builder: (context) => SettingsScreen()),
      );
    });
  }
}