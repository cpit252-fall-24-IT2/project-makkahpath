import 'package:flutter/material.dart';
import 'package:makkah_app/Widgets/BottomButton.dart';
import '../models/PageNavigation.dart';
import '../widgets/BottomButton.dart';


class HomePageNavigation implements PageNavigation {
  final BuildContext context;
  final BottomButton buttonRenderer;

  HomePageNavigation(this.context, this.buttonRenderer);

  @override
  Widget HomeButton() {
    return buttonRenderer.renderButton('Home', Icons.home, () {
      // push to screeen
    });
  }

  @override
  Widget TicketsButton() {
    return buttonRenderer.renderButton('Tickets', Icons.directions_bus, () {
      // push to screeen
    });
  }

  @override
  Widget SettingsButton() {
    return buttonRenderer.renderButton('Settings', Icons.settings, () {
      // push to screeen
    });
  }
}