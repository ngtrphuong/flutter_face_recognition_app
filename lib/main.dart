import 'package:face_app/providers/attendance.dart';
import 'package:face_app/providers/auth.dart';
import 'package:face_app/screens/attendance_screen.dart';
import 'package:face_app/screens/face_scanner_screen.dart';
import 'package:face_app/screens/home_screen.dart';
import 'package:face_app/screens/intro_screen.dart';
import 'package:face_app/screens/login_screen.dart';
import 'package:face_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Attendance>(
          create: (_) => Attendance(null, null),
          update: (ctx, auth, previousAttendance) => Attendance(
            auth.org,
            auth.emp,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Smart Attendance',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Color.fromRGBO(66, 135, 245, 1),
            accentColor: Color.fromRGBO(53, 53, 53, 1),
            fontFamily: 'Poppins',
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: auth.isAuth
              ? HomeScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : IntroScreen(),
                ),
          routes: {
            HomeScreen.routeName: (ctx) => HomeScreen(),
            AttendanceScreen.routeName: (ctx) => AttendanceScreen(),
            LoginScreen.routeName: (ctx) => LoginScreen(),
            FaceScanner.routeName: (ctx) => FaceScanner(),
          },
        ),
      ),
    );
  }
}
