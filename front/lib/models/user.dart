class User {
  final String userid;
  final String uname;
  final String email;
  final String password;

  User({
    required this.userid,
    required this.uname,
    required this.email,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userid: json['userid'],
      uname: json['uname'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userid': userid,
      'uname': uname,
      'email': email,
      'password': password,
    };
  }
}
