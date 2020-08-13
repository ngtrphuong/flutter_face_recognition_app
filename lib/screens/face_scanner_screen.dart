import 'package:face_app/widgets/camera_input.dart';
import 'package:flutter/material.dart';

class FaceScanner extends StatelessWidget {
  static const routeName = '/scan-face';

  @override
  Widget build(BuildContext context) {
    final camera = ModalRoute.of(context).settings.arguments;
    // final recognizedFace = Provider.of<Attendance>(context).recognizedFace;
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Your Face'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width * 0.9,
              // alignment: Alignment.center,
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: 20,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: CameraInput(camera),
            ),
            Text(
              'Place your complete face inside the box.',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
