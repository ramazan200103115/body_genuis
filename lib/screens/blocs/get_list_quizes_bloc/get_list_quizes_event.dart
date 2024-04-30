part of 'get_list_quizes_bloc.dart';

sealed class GetListQuizesEvent extends Equatable {
  const GetListQuizesEvent();

  @override
  List<Object> get props => [];
}

class GetQuizes extends GetListQuizesEvent {}
