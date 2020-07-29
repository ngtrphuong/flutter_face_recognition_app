import 'package:face_app/screens/login_screen.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  static const routeName = '/intro';

  @override
  Widget build(BuildContext context) {
    // final MediaQuery.of(context).size.height = MediaQuery.of(context).size.height;
    // final MediaQuery.of(context).size.width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.10,
              ),
              Text(
                'Face Attendance',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 33,
                ),
              ),
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.01,
              // ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Easy way to record and track Attendance',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                // width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.45,
                child: Image(
                  image: AssetImage('assets/images/illustration_1.jpeg'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 30.0),
                child: Text(
                  'Fast & easy way to record and track of your employees attendence',
                  style: TextStyle(
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              ButtonTheme(
                minWidth: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.08,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(LoginScreen.routeName);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
