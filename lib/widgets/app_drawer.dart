import 'package:face_app/providers/auth.dart';
import 'package:face_app/screens/attendance_screen.dart';
import 'package:face_app/screens/home_screen.dart';
import 'package:face_app/screens/setup_faceRec_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  final TextStyle itemStyle = TextStyle(
    fontSize: 20,
  );
  @override
  Widget build(BuildContext context) {
    final emp = Provider.of<Auth>(context).emp;
    return SafeArea(
      child: Drawer(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: double.infinity,
              color: Theme.of(context).primaryColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: ClipRRect(
                      child: Image.network(emp.profileImg),
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                  Text(
                    '${emp.firstName} ${emp.lastName}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      letterSpacing: 1.0,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            Divider(),
            ListTile(
              trailing: Icon(Icons.home),
              title: Text(
                'Home',
                style: itemStyle,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pushReplacementNamed(HomeScreen.routeName);
              },
            ),
            ListTile(
              trailing: Icon(Icons.dashboard),
              title: Text(
                'Setup Face Recognition',
                style: itemStyle,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(SetupFaceRecScreen.routeName);
              },
            ),
            ListTile(
              trailing: Icon(Icons.dashboard),
              title: Text(
                'My Attendance',
                style: itemStyle,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(AttendanceScreen.routeName);
              },
            ),
            ListTile(
              trailing: Icon(Icons.person),
              title: Text(
                'Profile',
                style: itemStyle,
              ),
              onTap: () {},
            ),
            ListTile(
              trailing: Icon(Icons.person),
              title: Text(
                'Leave',
                style: itemStyle,
              ),
              onTap: () {},
            ),
            ListTile(
              trailing: Icon(Icons.dashboard),
              title: Text(
                'Report & Analytics',
                style: itemStyle,
              ),
              onTap: () {},
            ),
            ListTile(
              trailing: Icon(Icons.exit_to_app),
              title: Text(
                'Sign Out',
                style: itemStyle,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<Auth>(context, listen: false).logout();
              },
            ),
            Divider(),
            ListTile(
              trailing: Icon(Icons.settings),
              title: Text(
                'Settings',
                style: itemStyle,
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
