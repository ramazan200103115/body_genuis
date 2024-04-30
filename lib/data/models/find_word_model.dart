class FindWordModel {
  final int id;
  final String image;
  final String word;
  final List<String> listLetters;

  FindWordModel({
    required this.id,
    required this.image,
    required this.word,
    required this.listLetters,
  });

  factory FindWordModel.fromJson(Map<String, dynamic> json) {
    return FindWordModel(
      id: json['id'] as int,
      image: json['image'] as String,
      word: json['word'] as String,
      listLetters: (json['listLetters'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }
}
