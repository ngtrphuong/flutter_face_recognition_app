import 'package:face_app/providers/attendance.dart';
import 'package:face_app/widgets/attendance_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AttendanceScreen extends StatefulWidget {
  static const routeName = '/attendance';

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final List<String> _months = [
    '',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  final int _currentMonth = DateTime.now().month;
  bool _init = true;
  bool _loading = false;
  List<dynamic> att;

  @override
  void didChangeDependencies() {
    if (_init) {
      att = Provider.of<Attendance>(context, listen: false)
          .latestFiveDaysAttendance;
      if (att.isEmpty) {
        loadAttendance();
      }
    }
    _init = false;
    super.didChangeDependencies();
  }

  void loadAttendance() async {
    setState(() {
      _loading = true;
    });
    try {
      await Provider.of<Attendance>(context, listen: false)
          .getAttendanceByEmpId();
      att = Provider.of<Attendance>(context, listen: false)
          .latestFiveDaysAttendance;
    } catch (error) {
      print(error);
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Attendance'),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          MonthName(
                            month: _months[_currentMonth - 1],
                          ),
                          MonthName(
                            month: _months[_currentMonth],
                            active: true,
                          ),
                          MonthName(
                            month: _months[_currentMonth + 1],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: att.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  'Your attendance has not been recorded since 5 days.',
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemBuilder: (_, index) =>
                                  AttendanceWidget(att[index]),
                              itemCount: att.length,
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class MonthName extends StatelessWidget {
  final String month;
  final bool active;

  MonthName({this.month, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      month,
      style: TextStyle(
        fontWeight: active ? FontWeight.w600 : FontWeight.w300,
        fontSize: active ? 22 : 18,
        color: active ? Color.fromRGBO(255, 72, 127, 1) : Colors.grey,
      ),
    );
  }
}
