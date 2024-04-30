import 'package:bloc/bloc.dart';
import 'package:clients_app/data/api/api_rovider.dart';
import 'package:clients_app/data/models/profile_model.dart';
import 'package:equatable/equatable.dart';

part 'get_profile_event.dart';
part 'get_profile_state.dart';

class GetProfileBloc extends Bloc<GetProfileEvent, GetProfileState> {
  final ApiProvider _apiProvider = ApiProvider();
  GetProfileBloc() : super(GetProfileInitial()) {
    on<GetProfileEvent>((event, emit) async {
      emit(GetProfileLoading());
      try {
        ProfileModel? profileModel = await _apiProvider.getProfile();
        profileModel != null
            ? emit(GetProfileSuccess(profileModel: profileModel))
            : emit(GetProfileFailure());
      } catch (e) {
        // print(e);
        emit(GetProfileFailure());
      }
    });
  }
}
