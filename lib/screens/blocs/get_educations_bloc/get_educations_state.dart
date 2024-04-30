part of 'get_educations_bloc.dart';

sealed class GetEducationsState extends Equatable {
  const GetEducationsState();

  @override
  List<Object> get props => [];
}

final class GetEducationsInitial extends GetEducationsState {}

final class GetEducationsLoading extends GetEducationsState {}

final class GetEducationsSuccess extends GetEducationsState {
  final List<EducationTile> educations;
  const GetEducationsSuccess({required this.educations});

  @override
  List<Object> get props => [educations];
}

final class GetEducationsFailure extends GetEducationsState {}
