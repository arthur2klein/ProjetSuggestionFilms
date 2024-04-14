import 'package:flutter/material.dart';
import 'package:suggestion_films/services/user_service.dart';

class UserCreationFormComponent extends StatefulWidget {
  const UserCreationFormComponent({super.key});

  @override
  State<UserCreationFormComponent> createState() =>
      _UserCreationFormComponentState();
}

class _UserCreationFormComponentState extends State<UserCreationFormComponent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  String _uname = '';
  String _email = '';
  String _password = '';
  String _loginMessage = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Username'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a username';
              }
              return null;
            },
            onSaved: (value) {
              _uname = value!;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'E-mail'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an e-mail';
              }
              if (!isValidEmail(value)) {
                return 'E-mail not valid';
              }
              return null;
            },
            onSaved: (value) {
              _email = value!;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Password'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters long';
              }
              return null;
            },
            obscureText: true,
            onSaved: (value) {
              _password = value!;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Confirm Password'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              print('Password is $_password and value is $value');
              /* if (value != _password) {
                return 'Password do not match';
              } */
              return null;
            },
            obscureText: true,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _submitForm();
            },
            child: const Text('Create an account'),
          ),
          if (_loginMessage.isNotEmpty)
            Text(
              _loginMessage,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
        ],
      ),
    );
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(email);
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final String loginResponse = await UserService().createUser(
        _uname,
        _email,
        _password,
      );
      if (loginResponse == '') {
        setState(() {
          _loginMessage = '';
        });
        _navigateToHome();
      } else {
        setState(() {
          _loginMessage = loginResponse;
        });
      }
    }
  }

  void _navigateToHome() {
    if (mounted) {
      Navigator.pushReplacementNamed(
        context,
        '/',
      );
    }
  }
}
