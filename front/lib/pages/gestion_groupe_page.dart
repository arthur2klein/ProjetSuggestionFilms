import 'package:flutter/material.dart';
import 'package:suggestion_films/components/group_management_component.dart';
import 'package:suggestion_films/components/my_scaffold.dart';
import 'package:suggestion_films/models/user.dart';
import 'package:suggestion_films/services/user_service.dart';

class GestionGroupePage extends StatefulWidget {
  const GestionGroupePage({super.key});

  @override
  State<GestionGroupePage> createState() => _GestionGroupePageState();
}

class _GestionGroupePageState extends State<GestionGroupePage> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: FutureBuilder<List<User>>(
        future: UserService().getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading data',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No user found',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            );
          } else {
            List<User> availableUsers = snapshot.data!;
            return GroupManagementComponent(
              availableUsers: availableUsers,
            );
          }
        },
      ),
      title: 'Group Management',
      indexNavBar: 3,
    );
  }
}
