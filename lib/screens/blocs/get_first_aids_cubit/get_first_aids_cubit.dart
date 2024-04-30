import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

import '../../../data/models/first_aid_model.dart';

part 'get_first_aids_state.dart';

class GetFirstAidsCubit extends Cubit<GetFirstAidsState> {
  GetFirstAidsCubit() : super(GetFirstAidsInitial());

  void getFirstAids() async {
    emit(GetFirstAidsLoading());
    try {
      final String jsonData =
          await rootBundle.loadString('assets/first_aids.json');
      final Map<String, dynamic> parsedJson = json.decode(jsonData);
      final List<FirstAid> firstAidList = List<FirstAid>.from(
          parsedJson['aids'].map((question) => FirstAid.fromJson(question)));
      emit(GetFirstAidsSuccess(firstAids: firstAidList));
    } catch (e) {
      print(e);
      emit(GetFirstAidsFailure());
    }
  }
}
