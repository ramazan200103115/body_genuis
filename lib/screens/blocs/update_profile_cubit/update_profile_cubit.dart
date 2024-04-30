import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:clients_app/data/api/api_rovider.dart';
import 'package:clients_app/data/models/profile_model.dart';
import 'package:equatable/equatable.dart';

part 'update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  final ApiProvider _apiProvider = ApiProvider();
  UpdateProfileCubit() : super(UpdateProfileInitial());
  void updateProfile(ProfileModel profileModel, File? image) async {
    // print(profileModel);
    emit(UpdateProfileLoading());
    try {
      await _apiProvider.updateProfile(profileModel, image)
          ? emit(UpdateProfileSuccess())
          : emit(UpdateProfileFailure());
    } catch (e) {
      print(e);
      emit(UpdateProfileFailure());
    }
  }
}
