import 'package:bloc/bloc.dart';
import 'package:clients_app/data/api/api_rovider.dart';
import 'package:clients_app/data/models/education_model.dart';
import 'package:equatable/equatable.dart';

part 'get_education_tile_event.dart';
part 'get_education_tile_state.dart';

class GetEducationTileBloc
    extends Bloc<GetEducationTileEvent, GetEducationTileState> {
  final ApiProvider _apiProvider = ApiProvider();
  GetEducationTileBloc() : super(GetEducationTileInitial()) {
    on<GetEducationTile>((event, emit) async {
      emit(GetEducationTileLoading());
      try {
        Education? education =
            await _apiProvider.getEducation(event.educationId);
        education != null
            ? emit(GetEducationTileSuccess(education: education))
            : emit(GetEducationTileFailure());
      } catch (e) {
        print(e);
        emit(GetEducationTileFailure());
      }
    });
  }
}
