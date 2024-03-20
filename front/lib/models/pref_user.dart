class PrefUser {
  final String prefid;
  final String userid;
  final String genreid;
  final String preflevel;

  PrefUser({
    required this.prefid,
    required this.userid,
    required this.genreid,
    required this.preflevel,
  });

  factory PrefUser.fromJson(Map<String, dynamic> json) {
    return PrefUser(
      prefid: json['prefid'],
      userid: json['userid'],
      genreid: json['genreid'],
      preflevel: json['preflevel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prefid': prefid,
      'userid': userid,
      'genreid': genreid,
      'preflevel': preflevel,
    };
  }
}
