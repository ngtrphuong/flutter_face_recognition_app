import 'package:face_app/providers/attendance.dart';
import 'package:face_app/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

class SetupFaceRecScreen extends StatefulWidget {
  static const routeName = '/setup-faceRecognition';
  @override
  _SetupFaceRecScreenState createState() => _SetupFaceRecScreenState();
}

class _SetupFaceRecScreenState extends State<SetupFaceRecScreen> {
  List<Asset> images = List<Asset>();
  String _error;

  @override
  void initState() {
    super.initState();
  }

  Widget buildGridView() {
    if (images != null)
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.count(
          crossAxisCount: 3,
          children: List.generate(images.length, (index) {
            Asset asset = images[index];
            return Stack(
              overflow: Overflow.visible,
              children: [
                Container(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AssetThumb(
                    asset: asset,
                    width: 300,
                    height: 300,
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: InkResponse(
                    onTap: () {
                      setState(() {
                        images.removeAt(index);
                      });
                    },
                    child: CircleAvatar(
                      maxRadius: 15,
                      child: Icon(
                        Icons.close,
                        size: 20,
                      ),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      );
    else
      return Container(color: Colors.white);
  }

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 50,
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      if (error == null) _error = 'No Error Dectected';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Your Images'),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: <Widget>[
          if (_error != 'No Error Dectected' && _error != null)
            Center(child: Text('Error: $_error')),
          if (images == null)
            Expanded(
              child: Center(
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    "Pick images",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: loadAssets,
                ),
              ),
            ),
          Expanded(
            child: buildGridView(),
          ),
          if (images != null)
            Container(
              padding: EdgeInsets.only(bottom: 20),
              height: 70,
              width: 150,
              child: FlatButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Provider.of<Attendance>(context, listen: false)
                      .trainDataset(images);
                },
                child: Text(
                  'Upload',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
