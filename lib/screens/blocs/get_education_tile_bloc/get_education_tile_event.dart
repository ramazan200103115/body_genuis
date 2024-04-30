part of 'get_education_tile_bloc.dart';

sealed class GetEducationTileEvent extends Equatable {
  const GetEducationTileEvent();

  @override
  List<Object> get props => [];
}

class GetEducationTile extends GetEducationTileEvent {
  final int educationId;

  const GetEducationTile({required this.educationId});

  @override
  List<Object> get props => [educationId];
}
