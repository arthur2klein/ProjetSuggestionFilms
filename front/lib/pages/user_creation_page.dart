import 'package:flutter/material.dart';
import 'package:suggestion_films/components/my_scaffold.dart';
import 'package:suggestion_films/components/user_creation_form_component.dart';

class UserCreationPage extends StatelessWidget {
  const UserCreationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyScaffold(
      title: 'User Creation',
      body: UserCreationFormComponent(),
    );
  }
}
