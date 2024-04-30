class QuizQuestionModel {
  final String question;
  final List<String> options;
  final int answerIndex;
  final String? imageUrl;

  QuizQuestionModel({
    required this.question,
    required this.options,
    required this.answerIndex,
    required this.imageUrl,
  });

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    return QuizQuestionModel(
      question: json['question'],
      options: List<String>.from(json['options']),
      answerIndex: json['answer_index'],
      imageUrl: json['imageUrl'],
    );
  }
}
