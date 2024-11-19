import 'package:flutter/material.dart';

abstract class BottomButton {
  Widget renderButton(String label, IconData icon, VoidCallback onClick);
}

class BasicButtonRenderer implements BottomButton {
  @override
  Widget renderButton(String label, IconData icon, VoidCallback onClick) {
    return GestureDetector(
      onTap: onClick,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.grey),
          Text(label, style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
