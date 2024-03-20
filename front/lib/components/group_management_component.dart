import 'package:flutter/material.dart';
import 'package:suggestion_films/models/user.dart';
import 'package:suggestion_films/services/group_service.dart';

class GroupManagementComponent extends StatefulWidget {
  final List<User> availableUsers;
  const GroupManagementComponent({super.key, required this.availableUsers});

  @override
  State<GroupManagementComponent> createState() =>
      _GroupManagementComponentState();
}

class _GroupManagementComponentState extends State<GroupManagementComponent> {
  List<User> searchedUsers = [];

  TextEditingController searchController = TextEditingController();

  void searchUsers(String query) {
    setState(() {
      searchedUsers = widget.availableUsers
          .where((user) => user.uname.toLowerCase().contains(
                query.toLowerCase(),
              ))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      searchUserWidget(),
        Expanded(child: listViewSearchedUsers()),
        const Divider(),
        const Text(
          'Current group members',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        Expanded(child: listViewUsersInGroup()),
        buttonReinitialize(),
      ],
    );
  }

  Widget searchUserWidget() {
    return TextField(
      controller: searchController,
      onChanged: searchUsers,
      decoration: InputDecoration(
        labelText: 'Search by username',
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            searchController.clear();
            searchUsers('');
          },
        ),
      ),
    );
  }

  ListView listViewSearchedUsers() {
    return ListView.builder(
      itemCount: searchedUsers.length,
      itemBuilder: (context, index) {
        User user = searchedUsers[index];
        return Padding(
          padding: const EdgeInsets.all(1.0),
          child: listTileUser(
            user: user,
            color: Theme.of(context).colorScheme.background,
          ),
        );
      },
    );
  }

  ListView listViewUsersInGroup() {
    return ListView.builder(
      itemCount: GroupService().currentGroup.length,
      itemBuilder: (context, index) {
        User user = GroupService().currentGroup[index];
        return Padding(
          padding: const EdgeInsets.all(1.0),
          child: listTileUser(
            user: user,
            color: Theme.of(context).colorScheme.surfaceVariant,
          ),
        );
      },
    );
  }

  ListTile listTileUser({
    required User user,
    required Color color,
  }) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      tileColor: color,
      title: Text(user.uname),
      trailing: (GroupService().containsUser(user))
          ? IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                setState(() {
                  GroupService().removeUser(user);
                });
              },
            )
          : IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                setState(() {
                  GroupService().addUser(user);
                });
              },
            ),
    );
  }

  Widget buttonReinitialize() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          GroupService().reinitializeGroup();
        });
      },
      child: const Text('Reinitialize Group'),
    );
  }
}
