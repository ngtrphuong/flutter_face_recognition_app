import 'package:face_app/screens/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Attendance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.purple[800],
        accentColor: Colors.blue[900],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
    );
  }
}
