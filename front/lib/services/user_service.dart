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
    return [
      User(
        userid: '1',
        uname: 'James',
        email: 'email1@test.com',
        password: 'password1',
      ),
      User(
        userid: '2',
        uname: 'Robert',
        email: 'email2@test.com',
        password: 'password2',
      ),
      User(
        userid: '3',
        uname: 'John',
        email: 'email3@test.com',
        password: 'password3',
      ),
      User(
        userid: '4',
        uname: 'Michael',
        email: 'email4@test.com',
        password: 'password4',
      ),
      User(
        userid: '5',
        uname: 'David',
        email: 'email5@test.com',
        password: 'password5',
      ),
      User(
        userid: '6',
        uname: 'Mary',
        email: 'email6@test.com',
        password: 'password6',
      ),
      User(
        userid: '7',
        uname: 'Patricia',
        email: 'email7@test.com',
        password: 'password7',
      ),
      User(
        userid: '8',
        uname: 'Linda',
        email: 'email8@test.com',
        password: 'password8',
      ),
      User(
        userid: '9',
        uname: 'Elizabeth',
        email: 'email9@test.com',
        password: 'password9',
      ),
      User(
        userid: '10',
        uname: 'Jennifer',
        email: 'email10@test.com',
        password: 'password10',
      ),
      User(
        userid: '11',
        uname: 'name11',
        email: 'email11@test.com',
        password: 'password11',
      ),
      User(
        userid: '12',
        uname: 'name12',
        email: 'email12@test.com',
        password: 'password12',
      ),
      User(
        userid: '13',
        uname: 'name13',
        email: 'email13@test.com',
        password: 'password13',
      ),
      User(
        userid: '14',
        uname: 'name14',
        email: 'email14@test.com',
        password: 'password14',
      ),
      User(
        userid: '15',
        uname: 'name15',
        email: 'email15@test.com',
        password: 'password15',
      ),
      User(
        userid: '16',
        uname: 'name16',
        email: 'email16@test.com',
        password: 'password16',
      ),
      User(
        userid: '17',
        uname: 'name17',
        email: 'email17@test.com',
        password: 'password17',
      ),
    ];
  }
}
