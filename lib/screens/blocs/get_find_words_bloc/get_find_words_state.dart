part of 'get_find_words_bloc.dart';

sealed class GetFindWordsState extends Equatable {
  const GetFindWordsState();

  @override
  List<Object> get props => [];
}

final class GetFindWordsInitial extends GetFindWordsState {}

final class GetFindWordsLoading extends GetFindWordsState {}

final class GetFindWordsSuccess extends GetFindWordsState {
  final List<FindWordModel> words;
  const GetFindWordsSuccess({required this.words});

  @override
  List<Object> get props => [words];
}

final class GetFindWordsFailure extends GetFindWordsState {}
