import 'package:flutter/material.dart';

class AcceptedScreen extends StatelessWidget {
  static const routeName = '/accepted-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width * 0.9,
        margin: EdgeInsets.symmetric(
            vertical: 20, horizontal: MediaQuery.of(context).size.width * 0.05),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Accepted',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Text(
              'Your Attendance Registered',
              style: TextStyle(
                fontSize: 25,
                color: Colors.grey,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                border:
                    Border.all(color: Theme.of(context).primaryColor, width: 2),
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.35),
              ),
              child: Center(
                child: Icon(
                  Icons.done,
                  color: Theme.of(context).primaryColor,
                  size: 150,
                ),
              ),
            ),
            Text(
              'Shubham Jain',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              'Entry Time - 10:00',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
            Container(
              constraints: BoxConstraints(minHeight: 50, minWidth: 150),
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  // Navigator.of(context)
                  //     .popUntil(ModalRoute.withName(HomeScreen.routeName));
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Okay',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
