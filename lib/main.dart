import 'package:flutter/material.dart';
import 'package:makkah_app/Screens/SignInPage.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:makkah_app/models/TicketCounterProvider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; 
import 'package:provider/provider.dart'; 

void main() {
  // Initialize the sqflite FFI (for non-web platforms)
  if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.windows || 
                  defaultTargetPlatform == TargetPlatform.macOS || 
                  defaultTargetPlatform == TargetPlatform.linux)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => TicketCounterProvider(), // Provide the TicketCounterProvider
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Makkah Path',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SignInPage(), // Your starting screen, SignInPage
    );
  }
}
