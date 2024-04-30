import 'package:bloc/bloc.dart';
import 'package:clients_app/data/api/api_rovider.dart';
import 'package:clients_app/data/models/question_model.dart';
import 'package:equatable/equatable.dart';

part 'get_quiz_questions_event.dart';
part 'get_quiz_questions_state.dart';

class GetQuizQuestionsBloc
    extends Bloc<GetQuizQuestionsEvent, GetQuizQuestionsState> {
  final ApiProvider _apiProvider = ApiProvider();
  GetQuizQuestionsBloc() : super(GetQuizQuestionsInitial()) {
    on<GetQuiz>((event, emit) async {
      emit(GetQuizLoading());
      try {
        List<QuizQuestionModel>? questions = await _apiProvider
            .getQuizQuestions(event.quizId, event.isEducation);
        questions != null
            ? emit(GetQuizSuccess(questions: questions))
            : emit(GetQuizFailure());
      } catch (e) {
        print(e);
        emit(GetQuizFailure());
      }
    });
  }
}
