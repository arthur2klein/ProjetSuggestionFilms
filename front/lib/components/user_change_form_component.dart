import 'package:flutter/material.dart';
import 'package:suggestion_films/models/user.dart';
import 'package:suggestion_films/services/user_service.dart';

class UserChangeFormComponent extends StatefulWidget {
  const UserChangeFormComponent({super.key});

  @override
  State<UserChangeFormComponent> createState() =>
      _UserChangeFormComponentState();
}

class _UserChangeFormComponentState extends State<UserChangeFormComponent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  String _uname = '';
  String _email = '';
  String _password = '';
  User currentUser = UserService().currentUser!;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            initialValue: currentUser.uname,
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
            initialValue: currentUser.email,
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
              if (value != _passwordController.text) {
                return 'Password do not match';
              }
              return null;
            },
            obscureText: true,
          ),
          ElevatedButton(
            onPressed: () {
              _submitForm();
            },
            child: const Text('Apply changes'),
          ),
        ],
      ),
    );
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(email);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      UserService().changeUser(
        uname: _uname,
        email: _email,
        password: _password,
      );
    }
  }
}
