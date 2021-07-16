import 'dart:convert';
import 'dart:io';

import 'package:face_app/models/account.dart';
import 'package:face_app/models/app_exception.dart';
import 'package:face_app/models/org.dart';
import 'package:face_app/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  User _user;
  Organization _org;
  Account _emp;
  String djangoBaseURL = "http://192.168.28.45:8000"; //"https://api-detect-admin.herokuapp.com"

  bool get isAuth {
    return token != null;
  }

  String get token {
    return _token;
  }

  User get user {
    if (isAuth) {
      return _user;
    }
  }

  Organization get org {
    if (isAuth) {
      return _org;
    }
  }

  Account get emp {
    if (isAuth) {
      return _emp;
    }
  }

  void setUser(Map<String, dynamic> extractedUser) {
    final newUser = User(
      id: extractedUser['id'],
      email: extractedUser['email'],
      date_joined: DateTime.parse(extractedUser['date_joined']),
      first_name: extractedUser['first_name'],
      last_name: extractedUser['last_name'],
      last_login: DateTime.parse(extractedUser['last_login']),
      is_superuser: extractedUser['is_superuser'],
      is_staff: extractedUser['is_staff'],
      is_active: extractedUser['is_active'],
      username: extractedUser['username'],
      groups: extractedUser['groups'],
      permissions: extractedUser['permissions'],
      password: extractedUser['password'],
    );
    _user = newUser;
  }

  void setOrg(extractedOrg) {
    final newOrg = Organization(
      url: extractedOrg['url'],
      pk: extractedOrg['pk'],
      name: extractedOrg['Name'],
      contact: extractedOrg['contact'],
      logo: extractedOrg['logo'],
      orgType: extractedOrg['orgType'],
      staffcount: extractedOrg['staffcount'],
    );
    _org = newOrg;
  }

  void setEmp(Map<String, dynamic> extractedEmp) {
    final newEmp = Account(
      url: extractedEmp['url'],
      pk: extractedEmp['pk'],
      empId: extractedEmp['empId'],
      emailId: extractedEmp['emailId'],
      username: extractedEmp['username'],
      firstName: extractedEmp['firstName'],
      lastName: extractedEmp['lastName'],
      gender: extractedEmp['gender'],
      phone: extractedEmp['phone'],
      readEmp: extractedEmp['readEmp'],
      addEmp: extractedEmp['addEmp'],
      readAtt: extractedEmp['readAtt'],
      addAtt: extractedEmp['addAtt'],
      readDept: extractedEmp['readDept'],
      addDept: extractedEmp['addDept'],
      orgId: extractedEmp['orgId'],
      deptId: extractedEmp['deptId'],
      client: extractedEmp['client'],
      idType: extractedEmp['idType'],
      idProof: extractedEmp['idProof'],
      profileImg: extractedEmp['profileImg'],
    );
    _emp = newEmp;
  }

  dynamic _returnResponse(http.Response response) {
    var responseJson = json.decode(response.body);
    var errorList = [];
    if (responseJson is List<dynamic>) {
      responseJson = responseJson as List<dynamic>;
      if (responseJson.length != 0) {
        responseJson = responseJson[0];
      } else {
        errorList.add('You are not yet registered to any organization.');
        throw BadRequestException(errorList.join(' '));
      }
    }
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

  Future<void> authenticate(String email, String password) async {
    var finalResponse;
    final prefs = await SharedPreferences.getInstance();
    String url = djangoBaseURL +
        '/attendance/auth/login/';
    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );
      finalResponse = _returnResponse(response);
      final extractedData = finalResponse as Map<String, dynamic>;
      _token = extractedData['token'];
      final extractedUser = extractedData['user'] as Map<String, dynamic>;
      setUser(extractedUser);
      if (!prefs.containsKey('userAcc')) {
        url = djangoBaseURL +
            '/attendance/api/accounts/filter?email=${_user.email}';
        response = await http.get(url);
        finalResponse = _returnResponse(response);
        final extractedEmp = finalResponse;
        setEmp(extractedEmp);
      } else {
        setEmp(jsonDecode(prefs.getString('userAcc')));
      }
      if (!prefs.containsKey('userOrg')) {
        url = djangoBaseURL +
            '/attendance/api/org/${_emp.orgId}/';
        response = await http.get(url);
        finalResponse = _returnResponse(response);
        final extractedOrg = finalResponse;
        setOrg(extractedOrg);
      } else {
        setOrg(jsonDecode(prefs.getString('userOrg')));
      }
      final userLogin = json.encode({
        'email': email,
        'password': password,
      });
      prefs.setString('userCredential', userLogin);
      notifyListeners();
      if (!prefs.containsKey('userAcc')) {
        saveDataLocally();
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> saveDataLocally() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userOrg', jsonEncode(_org));
    prefs.setString('userAcc', jsonEncode(_emp));
    prefs.setString('userDetail', jsonEncode(_user));
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userCredential')) {
      return false;
    }
    final loginInfo = json.decode(prefs.getString('userCredential'));
    await authenticate(loginInfo['email'], loginInfo['password']);
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _org = null;
    _emp = null;
    _user = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
