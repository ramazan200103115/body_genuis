part of 'update_quiz_cubit.dart';

sealed class UpdateQuizState extends Equatable {
  const UpdateQuizState();

  @override
  List<Object> get props => [];
}

final class UpdateQuizInitial extends UpdateQuizState {}

final class UpdateQuizLoading extends UpdateQuizState {}

final class UpdateQuizSuccess extends UpdateQuizState {}

final class UpdateQuizFailure extends UpdateQuizState {}
