class Quiz {
  final int id;
  final String title;
  final String author;
  final int questionsCount;
  final String? imageUrl;

  Quiz({
    required this.id,
    required this.title,
    required this.author,
    required this.questionsCount,
    required this.imageUrl,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      questionsCount: json['questions_count'] ?? 0,
      imageUrl: json['image_url'],
    );
  }
}
