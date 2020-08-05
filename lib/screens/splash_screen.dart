import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white70),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Logging you in...',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 25,
                letterSpacing: 1,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
