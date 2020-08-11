import 'dart:io';

import 'package:camera/camera.dart';
import 'package:face_app/providers/attendance.dart';
import 'package:face_app/widgets/accepted_screen.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class CameraInput extends StatefulWidget {
  static const routename = '/open-camera';
  final CameraDescription camera;

  CameraInput(this.camera);
  @override
  _CameraInputState createState() => _CameraInputState();
}

class _CameraInputState extends State<CameraInput> {
  String _imagePath = '';
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  Future<void> onSubmitImage() async {
    await Provider.of<Attendance>(context, listen: false)
        .takeAttendance(_imagePath);
    final recognisedFace =
        Provider.of<Attendance>(context, listen: false).recFace;
    print('idhar aaya');
    print(recognisedFace);
    if (recognisedFace != null) {
      await showDialog(
        context: context,
        builder: (context) => AcceptedScreen(),
      );
      Navigator.of(context).pop();
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An Error Occurred!'),
          content: Text('Can\'t Able to recognise Face'),
          actions: <Widget>[
            FlatButton(
              child: Text('Retry'),
              onPressed: () {
                setState(() {
                  _imagePath = '';
                });
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: _imagePath != ''
          ? Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Image.file(File(_imagePath)),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FloatingActionButton(
                          backgroundColor: Colors.green[700],
                          onPressed: onSubmitImage,
                          child: Icon(Icons.done),
                        ),
                        FloatingActionButton(
                          backgroundColor: Colors.red[700],
                          onPressed: () {
                            setState(() {
                              _imagePath = '';
                            });
                          },
                          child: Icon(Icons.refresh),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the Future is complete, display the preview.
                  return CameraPreview(_controller);
                } else {
                  // Otherwise, display a loading indicator.
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
      floatingActionButton: _imagePath != ''
          ? null
          : FloatingActionButton(
              child: Icon(Icons.camera_alt),
              // Provide an onPressed callback.
              onPressed: () async {
                // Take the Picture in a try / catch block. If anything goes wrong,
                // catch the error.
                try {
                  // Ensure that the camera is initialized.
                  await _initializeControllerFuture;

                  // Construct the path where the image should be saved using the
                  // pattern package.

                  final path = join(
                    // Store the picture in the temp directory.
                    // Find the temp directory using the `path_provider` plugin.
                    (await getTemporaryDirectory()).path,
                    '${DateTime.now()}.png',
                  );

                  // Attempt to take a picture and log where it's been saved.
                  await _controller.takePicture(path);

                  setState(() {
                    _imagePath = path;
                  });
                } catch (e) {
                  // If an error occurs, log the error to the console.
                  print(e);
                }
              },
            ),
    );
  }
}
