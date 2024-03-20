class Viewed {
  final String visioid;
  final String userid;
  final String movieid;

  Viewed({
    required this.visioid,
    required this.userid,
    required this.movieid,
  });

  factory Viewed.fromJson(Map<String, dynamic> json) {
    return Viewed(
      visioid: json['visioid'],
      userid: json['userid'],
      movieid: json['movieid'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'visioid': visioid,
      'userid': userid,
      'movieid': movieid,
    };
  }
}
