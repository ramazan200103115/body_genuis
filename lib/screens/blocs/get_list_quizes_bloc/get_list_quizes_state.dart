part of 'get_list_quizes_bloc.dart';

sealed class GetListQuizesState extends Equatable {
  const GetListQuizesState();

  @override
  List<Object> get props => [];
}

final class GetListQuizesInitial extends GetListQuizesState {}

final class GetListQuizesLoading extends GetListQuizesState {}

final class GetListQuizesSuccess extends GetListQuizesState {
  final List<Quiz> quizesList;
  const GetListQuizesSuccess({required this.quizesList});

  @override
  List<Object> get props => [quizesList];
}

final class GetListQuizesFailure extends GetListQuizesState {}
