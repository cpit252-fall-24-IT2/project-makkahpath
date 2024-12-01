import 'package:flutter/material.dart';
import 'package:makkah_app/Screens/SignInPage.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; 

void main() {
  // Initialize the sqflite FFI (for non-web platforms)
  if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.windows || 
                  defaultTargetPlatform == TargetPlatform.macOS || 
                  defaultTargetPlatform == TargetPlatform.linux)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Makkah Path',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SignInPage(),
    );
  }
}
