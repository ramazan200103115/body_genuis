part of 'get_education_tile_bloc.dart';

sealed class GetEducationTileState extends Equatable {
  const GetEducationTileState();

  @override
  List<Object> get props => [];
}

final class GetEducationTileInitial extends GetEducationTileState {}

final class GetEducationTileLoading extends GetEducationTileState {}

final class GetEducationTileSuccess extends GetEducationTileState {
  final Education education;
  const GetEducationTileSuccess({required this.education});

  @override
  List<Object> get props => [education];
}

final class GetEducationTileFailure extends GetEducationTileState {}
