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
        TextField(
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
        ),
        Expanded(
          child: ListView.builder(
            itemCount: searchedUsers.length,
            itemBuilder: (context, index) {
              User user = searchedUsers[index];
              return ListTile(
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
            },
          ),
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
            itemCount: GroupService().currentGroup.length,
            itemBuilder: (context, index) {
              User user = GroupService().currentGroup[index];
              return ListTile(
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
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              GroupService().reinitializeGroup();
            });
          },
          child: const Text('Reinitialize Group'),
        ),
      ],
    );
  }
}
