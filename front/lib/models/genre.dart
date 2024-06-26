class Genre {
  final String genreid;
  final String genrename;

  Genre({
    required this.genreid,
    required this.genrename,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      genreid: json['genreid'],
      genrename: json['genrename'],
    );
  }

  factory Genre.fromName(String name) {
    return Genre(
      genreid: "",
      genrename: name,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'genreid': genreid,
      'genrename': genrename,
    };
  }
}
