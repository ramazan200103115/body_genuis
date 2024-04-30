class Education {
  final int id;
  final String title;
  final String info;
  final String diseases;
  final List<String> diseasesImages;
  final List<String> infoImages;
  Education({
    required this.id,
    required this.title,
    required this.info,
    required this.diseases,
    required this.diseasesImages,
    required this.infoImages,
  });

  factory Education.fromJson(Map<String, dynamic> map) {
    return Education(
      id: map['id'] ?? -1,
      title: map['title'] ?? '',
      info: map['info'] ?? '',
      diseases: map['diseases'] ?? '',
      diseasesImages: List<String>.from((map['diseasesImages'])),
      infoImages: List<String>.from((map['infoImages'])),
    );
  }
}
