import 'package:bloc/bloc.dart';
import 'package:clients_app/data/api/api_rovider.dart';
import 'package:clients_app/data/models/quiz_model.dart';
import 'package:equatable/equatable.dart';

part 'get_quiz_by_code_state.dart';

class GetQuizByCodeCubit extends Cubit<GetQuizByCodeState> {
  GetQuizByCodeCubit() : super(GetQuizByCodeInitial());
  final ApiProvider _apiProvider = ApiProvider();
  void getQuiz(String code) async {
    emit(GetQuizByCodeLoading());
    try {
      Quiz? quiz = await _apiProvider.getQuizByCode(code);
      quiz != null
          ? emit(GetQuizByCodeSuccess(quiz: quiz))
          : emit(GetQuizByCodeFailure());
    } catch (e) {
      print(e);
      emit(GetQuizByCodeFailure());
    }
  }
}
