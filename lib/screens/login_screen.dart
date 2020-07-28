import 'package:face_app/widgets/auth_widget.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.45,
              child: FittedBox(
                child: Image(
                  image: AssetImage('assets/images/illustration_2.jpeg'),
                ),
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
            AuthWidget(),
          ],
        ),
      ),
    );
  }
}
