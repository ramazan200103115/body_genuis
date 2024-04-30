import 'package:bloc/bloc.dart';
import 'package:clients_app/data/api/api_rovider.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/find_word_model.dart';

part 'get_find_words_event.dart';
part 'get_find_words_state.dart';

class GetFindWordsBloc extends Bloc<GetFindWordsEvent, GetFindWordsState> {
  final ApiProvider _apiProvider = ApiProvider();
  GetFindWordsBloc() : super(GetFindWordsInitial()) {
    on<GetFindWordsEvent>((event, emit) async {
      emit(GetFindWordsLoading());
      try {
        Future.delayed(Duration(seconds: 2));
        List<FindWordModel>? words = await _apiProvider.getFindWords();
        words != null
            ? emit(GetFindWordsSuccess(words: words))
            : emit(GetFindWordsFailure());
      } catch (e) {
        print(e);
        emit(GetFindWordsFailure());
      }
    });
  }
}
