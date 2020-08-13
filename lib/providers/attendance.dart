import 'dart:convert';

import 'package:face_app/models/account.dart';
import 'package:face_app/models/app_exception.dart';
import 'package:face_app/models/org.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:multi_image_picker/multi_image_picker.dart';

class Attendance with ChangeNotifier {
  List<dynamic> fullAttendance = [];
  List<dynamic> fiveDaysAttendance = [];
  final Organization org;
  final Account emp;
  String recFace;
  String recFaceError;
  double recFaceAccuracy;

  Attendance(this.org, this.emp);

  List<dynamic> get attendance {
    return fullAttendance;
  }

  List<dynamic> get latestFiveDaysAttendance {
    return fiveDaysAttendance;
  }

  String get recognizedFace {
    return recFace;
  }

  String get recognizedFaceError {
    return recFaceError;
  }

  double get recognizedFaceAccuracy {
    return recFaceAccuracy;
  }

  dynamic _returnResponse(http.Response response) {
    var responseJson = json.decode(response.body);
    var errorList = [];
    final errorData = responseJson as Map<String, dynamic>;
    errorData.forEach((key, value) {
      if (key == 'field_errors') {
        final errors = errorData[key] as List<dynamic>;
        errors.forEach((err) {
          errorList.add(err);
        });
      }
      if (key == 'non_field_errors') {
        final errors = errorData[key] as List<dynamic>;
        errors.forEach((err) {
          errorList.add(err);
        });
      }
    });
    switch (response.statusCode) {
      case 200:
        return responseJson;
      case 400:
        throw BadRequestException(errorList.join(' '));
      case 401:
      case 403:
        throw UnauthorisedException(errorList.join(' '));
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  Future<void> getAttendanceByMonth(int month) async {
    final url =
        'http://api-detect-admin.herokuapp.com/attendance/api/report?orgId=${org.pk}&month=$month';
    final response = await http.get(url);
    final nonErrorResponse = _returnResponse(response) as Map<String, dynamic>;
    for (var i in nonErrorResponse.keys) {
      if (i == emp.empId.toString()) {
        fullAttendance = nonErrorResponse[i];
      }
    }
  }

  Future<void> getAttendanceByEmpId() async {
    final url =
        'https://api-detect-admin.herokuapp.com/attendance/api/attendance/filter?empId=${emp.empId}';
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as List<dynamic>;
    extractedData.forEach((att) {
      final tempDate = DateTime.parse(att['date']);
      if (tempDate.month == DateTime.now().month &&
          tempDate.day > (DateTime.now().day - 5) &&
          tempDate.day < (DateTime.now().day)) {
        fiveDaysAttendance.add(att);
      }
    });
  }

  Future<void> takeAttendance(String imagePath) async {
    final url = 'https://api-detect-admin.herokuapp.com/attendance/detect/';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    try {
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
      final streamedResponse = await request.send();
      final httpResponse = await http.Response.fromStream(streamedResponse);
      final finalResponse =
          json.decode(httpResponse.body) as Map<String, dynamic>;

      finalResponse.forEach((key, value) {
        if (key == 'result') {
          final responseResult =
              finalResponse['result'] as Map<String, dynamic>;
          if (responseResult['firstName'] != null) {
            recFace =
                responseResult['firstName'] + ' ' + responseResult['lastName'];
          }
          recFaceAccuracy = responseResult['accuracy'];
          recFaceError = responseResult['error'];
          notifyListeners();
          // print(recFace);
          // print(recFaceError);
        }
      });
      // print(json.decode(httpResponse.body));
      // print(streamedResponse.statusCode);
      // print(httpResponse);
    } catch (error) {
      print(error);
    }
  }

  Future<void> trainDataset(List<Asset> images) async {
    final url =
        'https://api-detect-admin.herokuapp.com/attendance/train_dataset/';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['empId'] = emp.empId.toString();
    try {
      for (var image in images) {
        ByteData byteData = await image.getByteData();
        print('aaya');
        List<int> imageData = byteData.buffer.asUint8List();
        // print(imageData);
        http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
          'image',
          imageData,
          filename: image.name,
        );
        print(multipartFile.field);
        request.files.add(multipartFile);
        print(request.files.length);
      }
      print(request.files.length);

      final streamedResponse = await request.send();
      final httpResponse = await http.Response.fromStream(streamedResponse);
      final finalResponse =
          _returnResponse(httpResponse) as Map<String, dynamic>;
      print(finalResponse);
      // print(streamedResponse);
      // print(httpResponse);
    } catch (error) {
      print(error);
    }
  }
}
