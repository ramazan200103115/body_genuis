// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_quiz_questions_bloc.dart';

abstract class GetQuizQuestionsEvent extends Equatable {
  const GetQuizQuestionsEvent();

  @override
  List<Object> get props => [];
}

class GetQuiz extends GetQuizQuestionsEvent {
  final int quizId;
  final bool isEducation;
  const GetQuiz({
    required this.quizId,
    required this.isEducation,
  });

  @override
  List<Object> get props => [quizId, isEducation];
}
