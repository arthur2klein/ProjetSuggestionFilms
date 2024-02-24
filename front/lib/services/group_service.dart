import 'package:suggestion_films/models/user.dart';

class GroupService {
  GroupService._privateConstructor();
  static final GroupService _instance = GroupService._privateConstructor();
  factory GroupService() {
    return _instance;
  }

  List<User> currentGroup = [];

  bool containsUser(User user) {
    return currentGroup.contains(user);
  }

  void addUser(User user) {
    if (!containsUser(user)) {
      currentGroup.add(user);
    }
  }

  void removeUser(User user) {
    if (containsUser(user)) {
      currentGroup.remove(user);
    }
  }

  void reinitializeGroup() {
    currentGroup = [];
  }
}
