import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:suggestion_films/models/user.dart';
import 'package:suggestion_films/services/group_service.dart';

class UserService {
  UserService._privateConstructor();
  static final UserService _instance = UserService._privateConstructor();
  factory UserService() {
    return _instance;
  }

  final String apiUrl = 'http://localhost:8000';
  User? currentUser;

  Future<String> createUser(
    String uname,
    String email,
    String password,
  ) async {
    GroupService().reinitializeGroup();
    final response = await http.post(
      Uri.parse('$apiUrl/user/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'uname': uname,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Created
      final jsonResponse = json.decode(response.body);
      print(jsonResponse);
      currentUser = User.fromJson(jsonResponse['user']);
      return '';
    } else {
      final jsonResponse = json.decode(response.body);
      final errorMessage = jsonResponse['error'] ?? 'User creation failed.';
      print('Error: $errorMessage');
      return errorMessage;
    }
  }

  Future<String> loginUser(
    String email,
    String password,
  ) async {
    GroupService().reinitializeGroup();
    final response = await http.post(
      Uri.parse('$apiUrl/user/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Everything OK
      final jsonResponse = json.decode(response.body);
      print(jsonResponse);
      currentUser = User.fromJson(jsonResponse['user']);
      return '';
    } else {
      final jsonResponse = json.decode(response.body);
      final errorMessage = jsonResponse['error'] ?? 'Login failed.';
      print('Error: $errorMessage');
      return errorMessage;
    }
  }

  void logOut() {
    currentUser = null;
    GroupService().reinitializeGroup();
  }

  Future<String> changeUser({
    required String uname,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$apiUrl/user/change'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'uname': uname,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Everything OK
      final jsonResponse = json.decode(response.body);
      currentUser = User.fromJson(jsonResponse['user']);
      return '';
    } else {
      final jsonResponse = json.decode(response.body);
      final errorMessage = jsonResponse['error'] ?? 'Login failed.';
      print('Error: $errorMessage');
      return errorMessage;
    }
  }

  Future<List<User>> getAllUsers() async {
    final response = await http.get(
      Uri.parse('$apiUrl/user/all'),
    );

    if (response.statusCode == 200) {
      // Everything OK
      final jsonResponse = json.decode(response.body);
      final allUsers = jsonResponse['users'].map(
        (userJson) => User.fromJson(userJson),
      );
      return allUsers;
    } else {
      final jsonResponse = json.decode(response.body);
      final errorMessage = jsonResponse['error'] ?? 'Could not get users';
      print('Error: $errorMessage');
      return [];
    }
  }
}
