class FirstAid {
  final String title;
  final String info;
  final String firstAid;
  final String? videoUrl;

  FirstAid({
    required this.title,
    required this.info,
    required this.firstAid,
    this.videoUrl,
  });

  factory FirstAid.fromJson(Map<String, dynamic> json) {
    return FirstAid(
      title: json['type'],
      info: json['info'],
      firstAid: json['first_aid'],
      videoUrl: json['videoUrl'],
    );
  }
}
