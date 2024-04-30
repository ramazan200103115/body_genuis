import 'package:bloc/bloc.dart';
import 'package:clients_app/data/api/api_rovider.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/quiz_model.dart';

part 'get_list_quizes_event.dart';
part 'get_list_quizes_state.dart';

class GetListQuizesBloc extends Bloc<GetListQuizesEvent, GetListQuizesState> {
  final ApiProvider _apiProvider = ApiProvider();
  GetListQuizesBloc() : super(GetListQuizesInitial()) {
    on<GetQuizes>((event, emit) async {
      emit(GetListQuizesLoading());
      try {
        // Future.delayed(Duration(seconds: 3));
        List<Quiz>? quizesList = await _apiProvider.getQuizes();
        quizesList != null
            ? emit(GetListQuizesSuccess(quizesList: quizesList))
            : emit(GetListQuizesFailure());
      } catch (e) {
        // print(e);
        emit(GetListQuizesFailure());
      }
    });
  }
}
