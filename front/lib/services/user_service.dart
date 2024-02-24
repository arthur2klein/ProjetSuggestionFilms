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

  final String apiUrl = 'api';
  final User testUser = User(
    userid: '0',
    uname: 'test',
    email: 'test@mail.com',
    password: 'tE5!tE5!',
  );
  User? currentUser;

  Future<String> createUser(
    String uname,
    String email,
    String password,
  ) async {
    GroupService().reinitializeGroup();
    final response = await http.post(
      Uri.parse('$apiUrl/user/create'),
      body: {
        'uname': uname,
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 201) {
      // Created
      final jsonResponse = json.decode(response.body);
      currentUser = User.fromJson(jsonResponse['user']);
      return '';
    } else {
      final jsonResponse = json.decode(response.body);
      final errorMessage = jsonResponse['error'] ?? 'User creation failed.';
      debugPrint('Error: $errorMessage');
      return errorMessage;
    }
  }

  Future<String> loginUser(
    String email,
    String password,
  ) async {
    GroupService().reinitializeGroup();
    if (email == testUser.email && password == testUser.password) {
      currentUser = testUser;
      return '';
    } else {
      currentUser = null;
      return 'User not found';
    }
    final response = await http.post(
      Uri.parse('$apiUrl/user/login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      // Everything OK
      final jsonResponse = json.decode(response.body);
      currentUser = User.fromJson(jsonResponse['user']);
      return '';
    } else {
      final jsonResponse = json.decode(response.body);
      final errorMessage = jsonResponse['error'] ?? 'Login failed.';
      debugPrint('Error: $errorMessage');
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
      body: {
        'uname': uname,
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      // Everything OK
      final jsonResponse = json.decode(response.body);
      currentUser = User.fromJson(jsonResponse['user']);
      return '';
    } else {
      final jsonResponse = json.decode(response.body);
      final errorMessage = jsonResponse['error'] ?? 'Login failed.';
      debugPrint('Error: $errorMessage');
      return errorMessage;
    }
  }

  Future<List<User>> getAllUsers() async {
    return [testUser];
    final response = await http.get(
      Uri.parse('$apiUrl/user/get_all'),
    );

    if (response.statusCode == 200) {
      // Everything OK
      final jsonResponse = json.decode(response.body);
      return jsonResponse['data'].map(
        (user) => User.fromJson(user),
      );
    } else {
      final jsonResponse = json.decode(response.body);
      final errorMessage = jsonResponse['error'] ?? 'Login failed.';
      throw Exception('Error while getting users: $errorMessage');
    }
  }
}
