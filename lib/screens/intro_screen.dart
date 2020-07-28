import 'package:face_app/screens/login_screen.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  static const routeName = '/intro';

  @override
  Widget build(BuildContext context) {
    final responsiveHeight = MediaQuery.of(context).size.height;
    final responsiveWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: responsiveHeight * 0.10,
              ),
              Text(
                'Face Attendance',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 33,
                ),
              ),
              // SizedBox(
              //   height: responsiveHeight * 0.01,
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
                height: responsiveHeight * 0.45,
                child: FittedBox(
                  child: Image(
                    image: AssetImage('assets/images/illustration_1.jpeg'),
                  ),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
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
                minWidth: responsiveWidth * 0.5,
                height: responsiveHeight * 0.08,
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
                    Navigator.of(context).pushNamed(LoginScreen.routeName);
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
