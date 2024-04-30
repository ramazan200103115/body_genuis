part of 'get_first_aids_cubit.dart';

sealed class GetFirstAidsState extends Equatable {
  const GetFirstAidsState();

  @override
  List<Object> get props => [];
}

final class GetFirstAidsInitial extends GetFirstAidsState {}

final class GetFirstAidsLoading extends GetFirstAidsState {}

final class GetFirstAidsSuccess extends GetFirstAidsState {
  final List<FirstAid> firstAids;
  const GetFirstAidsSuccess({required this.firstAids});

  @override
  List<Object> get props => [firstAids];
}

final class GetFirstAidsFailure extends GetFirstAidsState {}
