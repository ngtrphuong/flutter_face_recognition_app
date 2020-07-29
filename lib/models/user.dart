import 'dart:convert';

class User {
  final int id;
  final String password;
  final DateTime last_login;
  final bool is_superuser;
  final String first_name;
  final String last_name;
  final bool is_active;
  final bool is_staff;
  final DateTime date_joined;
  final String username;
  final String email;
  final List<dynamic> groups;
  final List<dynamic> permissions;

  User({
    this.id,
    this.password,
    this.last_login,
    this.is_superuser,
    this.first_name,
    this.last_name,
    this.is_active,
    this.is_staff,
    this.date_joined,
    this.username,
    this.email,
    this.groups,
    this.permissions,
  });

  Map toJson() => {
        'id': id,
        'password': password,
        'last_login': last_login.toIso8601String(),
        'is_superuser': is_superuser,
        'first_name': first_name,
        'last_name': last_name,
        'is_active': is_active,
        'is_staff': is_staff,
        'date_joined': date_joined.toIso8601String(),
        'username': username,
        'email': email,
        'groups': json.encode(groups),
        'permissions': json.encode(permissions),
      };
}
