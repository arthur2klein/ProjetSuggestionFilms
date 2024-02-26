import 'package:flutter/material.dart';
import 'package:suggestion_films/components/my_scaffold.dart';
import 'package:suggestion_films/components/user_change_form_component.dart';
import 'package:suggestion_films/services/user_service.dart';

class GestionUserPage extends StatelessWidget {
  const GestionUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: 'Manage my account',
      body: Center(
        child: Column(
          children: [
            const UserChangeFormComponent(),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                UserService().logOut();
                Navigator.of(context).popUntil(
                  (route) => route.isFirst,
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_off),
                  Text('Disconnect'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
