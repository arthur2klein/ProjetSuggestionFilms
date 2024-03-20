import 'package:flutter/material.dart';
import 'package:suggestion_films/components/my_scaffold.dart';
import 'package:suggestion_films/components/user_login_form_component.dart';

class UserLoginPage extends StatelessWidget {
  const UserLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyScaffold(
      title: 'Login',
      body: UserLoginFormComponent(),
    );
  }
}
