import 'dart:convert';

import 'package:face_app/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  User _user;

  bool get is_Auth {
    return token != null;
  }

  String get token {
    return _token;
  }

  Future<void> authenticate(String email, String password) async {
    const url = 'https://api-detect-admin.herokuapp.com/attendance/auth/login/';
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      _token = extractedData['token'];
      final extractedUser = extractedData['user'] as Map<String, dynamic>;
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
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
