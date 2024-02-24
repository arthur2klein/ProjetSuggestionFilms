import 'package:flutter/material.dart';
import 'package:suggestion_films/services/user_service.dart';

class UserLoginFormComponent extends StatefulWidget {
  const UserLoginFormComponent({super.key});

  @override
  State<UserLoginFormComponent> createState() => _UserLoginFormComponentState();
}

class _UserLoginFormComponentState extends State<UserLoginFormComponent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
            decoration: const InputDecoration(labelText: 'E-mail'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your e-mail';
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
                return 'Please enter your password';
              }
              return null;
            },
            onSaved: (value) {
              _password = value!;
            },
            obscureText: true,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _submitForm();
            },
            child: const Text('Login'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                '/create-account',
              );
            },
            child: const Text('Create your account'),
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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final userService = UserService();
      final loginResponse = await userService.loginUser(
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
