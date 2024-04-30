import 'package:bloc/bloc.dart';
import 'package:clients_app/data/api/api_rovider.dart';
import 'package:clients_app/data/models/profile_model.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final ApiProvider _apiProvider = ApiProvider();
  LoginCubit() : super(LoginInitial());
  void login(String email, String password) {
    emit(LoginLoading());
    try {
      Future.delayed(Duration(seconds: 1)).then((value) async {
        await _apiProvider.loginUser(email, password)
            ? emit(LoginSuccess())
            : emit(LoginFailure());
      });
    } catch (e) {
      print(e);
      emit(LoginFailure());
    }
  }

  void register(ProfileModel profileModel, String password) {
    emit(LoginLoading());
    try {
      Future.delayed(Duration(seconds: 1)).then((value) async {
        await _apiProvider.registerUser(profileModel, password)
            ? emit(LoginSuccess())
            : emit(LoginFailure());
      });
    } catch (e) {
      print(e);
      emit(LoginFailure());
    }
  }
}
