part of 'get_quiz_questions_bloc.dart';

abstract class GetQuizQuestionsState extends Equatable {
  const GetQuizQuestionsState();

  @override
  List<Object> get props => [];
}

final class GetQuizQuestionsInitial extends GetQuizQuestionsState {}

final class GetQuizLoading extends GetQuizQuestionsState {}

final class GetQuizSuccess extends GetQuizQuestionsState {
  final List<QuizQuestionModel> questions;
  const GetQuizSuccess({required this.questions});

  @override
  List<Object> get props => [questions];
}

final class GetQuizFailure extends GetQuizQuestionsState {}
