class EducationTile {
  final int id;
  final String title;

  EducationTile({
    required this.id,
    required this.title,
  });

  factory EducationTile.fromJson(Map<String, dynamic> json) {
    return EducationTile(
      id: json['id'],
      title: json['title'],
    );
  }
}
