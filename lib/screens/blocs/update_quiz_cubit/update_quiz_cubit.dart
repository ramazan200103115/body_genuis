import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/api/api_rovider.dart';

part 'update_quiz_state.dart';

class UpdateQuizCubit extends Cubit<UpdateQuizState> {
  UpdateQuizCubit() : super(UpdateQuizInitial());
  final ApiProvider _apiProvider = ApiProvider();
  void updateQuiz(int quizId, int score) async {
    emit(UpdateQuizLoading());
    try {
      await _apiProvider.updateQuiz(quizId, score)
          ? emit(UpdateQuizSuccess())
          : emit(UpdateQuizFailure());
    } catch (e) {
      // print(e);
      emit(UpdateQuizFailure());
    }
  }
}
