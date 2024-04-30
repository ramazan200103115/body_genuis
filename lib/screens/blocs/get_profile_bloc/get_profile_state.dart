part of 'get_profile_bloc.dart';

sealed class GetProfileState extends Equatable {
  const GetProfileState();

  @override
  List<Object> get props => [];
}

final class GetProfileInitial extends GetProfileState {}

final class GetProfileLoading extends GetProfileState {}

final class GetProfileSuccess extends GetProfileState {
  final ProfileModel profileModel;
  const GetProfileSuccess({required this.profileModel});

  @override
  List<Object> get props => [profileModel];
}

final class GetProfileFailure extends GetProfileState {}
