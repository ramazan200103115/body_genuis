import 'package:bloc/bloc.dart';
import 'package:clients_app/data/api/api_rovider.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/education_tile_model.dart';

part 'get_educations_event.dart';
part 'get_educations_state.dart';

class GetEducationsBloc extends Bloc<GetEducationsEvent, GetEducationsState> {
  final ApiProvider _apiProvider = ApiProvider();
  GetEducationsBloc() : super(GetEducationsInitial()) {
    on<GetEducationsEvent>((event, emit) async {
      emit(GetEducationsLoading());
      try {
        List<EducationTile>? educations = await _apiProvider.getEducationList();
        educations != null
            ? emit(GetEducationsSuccess(educations: educations))
            : emit(GetEducationsFailure());
      } catch (e) {
        // print(e);
        emit(GetEducationsFailure());
      }
    });
  }
}
