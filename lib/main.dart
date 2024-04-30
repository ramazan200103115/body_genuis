import 'dart:io';

import 'package:clients_app/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clients_app/router/router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'screens/blocs/get_education_tile_bloc/get_education_tile_bloc.dart';
import 'screens/blocs/get_educations_bloc/get_educations_bloc.dart';
import 'screens/blocs/get_find_words_bloc/get_find_words_bloc.dart';
import 'screens/blocs/get_first_aids_cubit/get_first_aids_cubit.dart';
import 'screens/blocs/get_list_quizes_bloc/get_list_quizes_bloc.dart';
import 'screens/blocs/get_profile_bloc/get_profile_bloc.dart';
import 'screens/blocs/get_quiz_by_code_cubit/get_quiz_by_code_cubit.dart';
import 'screens/blocs/get_quiz_questions_bloc/get_quiz_questions_bloc.dart';
import 'screens/blocs/login_cubit/login_cubit.dart';
import 'screens/blocs/update_profile_cubit/update_profile_cubit.dart';
import 'screens/blocs/update_quiz_cubit/update_quiz_cubit.dart';
import 'screens/login_page.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('tokens');
  await Hive.openBox('coins');
  await Hive.openBox('profileId');

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static FMRoute router = FMRoute();

  @override
  Widget build(BuildContext context) {
    var tokenBox = Hive.box('tokens');
    String? _token = tokenBox.get('access');
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LoginCubit>(create: (context) => LoginCubit()),
          BlocProvider<GetProfileBloc>(create: (context) => GetProfileBloc()),
          BlocProvider<UpdateQuizCubit>(create: (context) => UpdateQuizCubit()),
          BlocProvider<GetQuizByCodeCubit>(
              create: (context) => GetQuizByCodeCubit()),
          BlocProvider<GetFindWordsBloc>(
              create: (context) => GetFindWordsBloc()),
          BlocProvider<UpdateProfileCubit>(
              create: (context) => UpdateProfileCubit()),
          BlocProvider<GetFirstAidsCubit>(
              create: (context) => GetFirstAidsCubit()),
          BlocProvider<GetEducationTileBloc>(
              create: (context) => GetEducationTileBloc()),
          BlocProvider<GetEducationsBloc>(
              create: (context) => GetEducationsBloc()),
          BlocProvider<GetQuizQuestionsBloc>(
              create: (context) => GetQuizQuestionsBloc()),
          BlocProvider<GetListQuizesBloc>(
              create: (context) => GetListQuizesBloc()),
        ],
        child: MaterialApp(
          title: 'Body Genuis',
          debugShowCheckedModeBanner: false,
          color: Colors.transparent,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.white,
          ),
          home: _token != null ? const HomePage() : const LoginPage(),
        ),
      ),
    );
  }
}
