part of 'get_quiz_by_code_cubit.dart';

sealed class GetQuizByCodeState extends Equatable {
  const GetQuizByCodeState();

  @override
  List<Object> get props => [];
}

final class GetQuizByCodeInitial extends GetQuizByCodeState {}

final class GetQuizByCodeLoading extends GetQuizByCodeState {}

final class GetQuizByCodeSuccess extends GetQuizByCodeState {
  final Quiz quiz;
  const GetQuizByCodeSuccess({required this.quiz});

  @override
  List<Object> get props => [quiz];
}

final class GetQuizByCodeFailure extends GetQuizByCodeState {}
