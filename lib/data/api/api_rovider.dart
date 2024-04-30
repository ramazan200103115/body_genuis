import 'dart:convert';
import 'dart:io';

import 'package:clients_app/data/models/find_word_model.dart';
import 'package:clients_app/data/models/question_model.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import '../models/education_model.dart';
import '../models/education_tile_model.dart';
import '../models/profile_model.dart';
import '../models/quiz_model.dart';
import 'config.dart';

var tokenBox = Hive.box('tokens');
var _languageBox = Hive.box('language');

class ApiProvider {
  static final ApiProvider _singleton = ApiProvider._internal();

  factory ApiProvider() {
    return _singleton;
  }

  ApiProvider._internal();

  // String token = '';
  //     tokenBox.isNotEmpty ? tokenBox.get('access') as String : 'null';

  Future<bool> logout() async {
    String _token = tokenBox.get('access') ?? 'null';
    final response = await http.post(
      Uri.parse('${baseUrlApi}auth/logout'),
      headers: {
        "Authorization": "Bearer $_token",
      },
    );

    return response.statusCode == 200;
  }

  Future<bool> updateCoins(int coins) async {
    var tokenBox = Hive.box('tokens');
    String _token = tokenBox.get('access') ?? 'null';
    Map<String, String> headers = {
      "Authorization": "Bearer $_token",
      "Content-type": "application/json",
      "Accept": "application/json",
    };
    final response = await http.get(
      headers: headers,
      Uri.parse('${baseUrlApi}update/profile?user_id=-1&coins=$coins'),
    );
    if (response.statusCode == 200) {
      dynamic data = jsonDecode(utf8.decode(response.bodyBytes));
      String token = data['access_token'];
      tokenBox.put('access', token);
    }
    return response.statusCode == 200;
  }

  Future<bool> registerUser(ProfileModel profileModel, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrlApi}register'),
      body: {
        "email": profileModel.email,
        'password': password,
        'password_confirmation': password,
        'name': profileModel.name,
        'age': '${profileModel.age}',
      },
    );
    if (response.statusCode == 200) {
      dynamic data = jsonDecode(utf8.decode(response.bodyBytes));
      dynamic tokenD = data['data'];
      String? token = tokenD != null ? tokenD['token'] : null;
      if (token != null) {
        tokenBox.put('access', token);
      } else {
        return false;
      }
    }
    return response.statusCode == 200;
  }

  Future<bool> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrlApi}login'),
      body: {
        "email": email,
        'password': password,
      },
    );
    if (response.statusCode == 200) {
      dynamic data = jsonDecode(utf8.decode(response.bodyBytes));
      dynamic tokenD = data['data'];
      String? token = tokenD != null ? tokenD['token'] : null;
      if (token != null) {
        tokenBox.put('access', token);
      } else {
        return false;
      }
    }
    return response.statusCode == 200;
  }

  Future<bool> updateQuiz(int quizId, int score) async {
    var tokenBox = Hive.box('tokens');
    String _token = tokenBox.get('access') ?? 'null';
    var profileIdBox = Hive.box('profileId');
    int prId = profileIdBox.get('id');

    Map<String, String> headers = {
      "Authorization": "Bearer $_token",
      "Content-type": "application/json",
      "Accept": "application/json",
    };

    final imageUploadRequest =
        http.MultipartRequest('POST', Uri.parse('${baseUrlApi}update/quiz'));

    imageUploadRequest.headers.addAll(headers);

    imageUploadRequest.fields['user_id'] = '$prId';
    imageUploadRequest.fields['quiz_id'] = '$quizId';
    imageUploadRequest.fields['score'] = '$score';

    final response = await imageUploadRequest.send();
    // print('quiz: ${response.statusCode}');
    // print(response.reasonPhrase);

    return response.statusCode == 200;
  }

  Future<bool> updateProfile(ProfileModel profileModel, File? image) async {
    var tokenBox = Hive.box('tokens');
    String _token = tokenBox.get('access') ?? 'null';
    var profileIdBox = Hive.box('profileId');
    int prId = profileIdBox.get('id');

    Map<String, String> headers = {
      "Authorization": "Bearer $_token",
      "Content-type": "application/json",
      "Accept": "application/json",
    };
    String email = profileModel.email;
    String name = profileModel.name;
    String aboutMe = profileModel.aboutMe;
    int age = profileModel.age;

    final imageUploadRequest = http.MultipartRequest(
        'POST', Uri.parse('${baseUrlApi}user/update/$prId'));

    imageUploadRequest.headers.addAll(headers);
    if (image != null) {
      final file = await http.MultipartFile.fromPath(
        'photo',
        image.path,
      );

      imageUploadRequest.files.add(file);
    }
    name != '' ? imageUploadRequest.fields['name'] = name : null;
    age != -1 ? imageUploadRequest.fields['age'] = '$age' : null;
    aboutMe != '' ? imageUploadRequest.fields['aboutMe'] = aboutMe : null;
    email != '' ? imageUploadRequest.fields['email'] = email : null;
    profileModel.medcoins != -1
        ? imageUploadRequest.fields['medcoins'] = '${profileModel.medcoins}'
        : null;

    final response = await imageUploadRequest.send();
    // print('update profile: ${response.statusCode}');
    return response.statusCode == 200;
  }

  Future<Education?> getEducation(int id) async {
    var tokenBox = Hive.box('tokens');
    String _token = tokenBox.get('access') ?? 'null';
    // print(_token);
    Map<String, String> headers = {
      "Authorization": "Bearer $_token",
      "Content-type": "application/json",
      "Accept": "application/json",
    };

    final response = await http.get(
      Uri.parse('${baseUrlApi}education/$id'),
      headers: headers,
    );

    if (id == -1) {
      final String jsonData =
          await rootBundle.loadString('assets/example_education_tile.json');
      final Map<String, dynamic> parsedJson = json.decode(jsonData);
      final Education education = Education.fromJson(parsedJson);
      return education;
    } else if (response.statusCode == 200
        //  &&
        //     _dateTime.day <= DateTime.now().day &&
        //     _dateTime.month >= DateTime.now().month &&
        //     _dateTime.year == DateTime.now().year
        ) {
      // if (response.statusCode > 0 &&
      //     !(_dateTime.day <= DateTime.now().day &&
      //         _dateTime.month >= DateTime.now().month &&
      //         _dateTime.year == DateTime.now().year)) {
      // final String jsonData =
      //     await rootBundle.loadString('assets/example_education_tile.json');
      // final Map<String, dynamic> parsedJson = json.decode(jsonData);
      final Map<String, dynamic> parsedJson = jsonDecode(response.body)['data'];
      final Education education = Education.fromJson(parsedJson);
      return education;
    }
    return null;
  }

  Future<List<EducationTile>?> getEducationList() async {
    var tokenBox = Hive.box('tokens');
    String _token = tokenBox.get('access') ?? 'null';

    Map<String, String> headers = {
      "Authorization": "Bearer $_token",
      "Content-type": "application/json",
      "Accept": "application/json",
    };

    final response = await http.get(
      Uri.parse('${baseUrlApi}education'),
      headers: headers,
    );

    if (response.statusCode == 200
        // &&
        //     // _dateTime.day <= DateTime.now().day &&
        //     // _dateTime.month >= DateTime.now().month &&
        //     // _dateTime.year == DateTime.now().year) {
        //     // if (response.statusCode > 0 &&
        //     !(_dateTime.day <= DateTime.now().day &&
        //         _dateTime.month >= DateTime.now().month &&
        //         _dateTime.year == DateTime.now().year)
        ) {
      // final String jsonData =
      //     await rootBundle.loadString('assets/example_educations.json');
      // final Map<String, dynamic> parsedJson = json.decode(jsonData);
      final Map<String, dynamic> parsedJson = jsonDecode(response.body);
      final List<EducationTile> educations = List<EducationTile>.from(
          parsedJson['data']
              .map((question) => EducationTile.fromJson(question)));
      return educations;
    }
    return null;
  }

  Future<Quiz?> getQuizByCode(String code) async {
    var tokenBox = Hive.box('tokens');
    String _token = tokenBox.get('access') ?? 'null';

    Map<String, String> headers = {
      "Authorization": "Bearer $_token",
      "Content-type": "application/json",
      "Accept": "application/json",
    };

    final response = await http.get(
      Uri.parse('${baseUrlApi}quiz/$code'),
      headers: headers,
    );

    if (response.statusCode == 200
        // &&
        //     _dateTime.day <= DateTime.now().day &&
        //     _dateTime.month >= DateTime.now().month &&
        //     _dateTime.year == DateTime.now().year
        ) {
      // if (response.statusCode > 0 &&
      //     !(_dateTime.day <= DateTime.now().day &&
      //         _dateTime.month >= DateTime.now().month &&
      //         _dateTime.year == DateTime.now().year)) {
      // final String jsonData =
      //     await rootBundle.loadString('assets/example_quizes.json');
      // final Map<String, dynamic> parsedJson = json.decode(jsonData);
      // print(response.body);
      final Map<String, dynamic> parsedJson = jsonDecode(response.body)[0];
      // print(parsedJson);
      final Quiz quizes = Quiz.fromJson(parsedJson);
      return quizes;
    }
    return null;
  }

  Future<List<Quiz>?> getQuizes() async {
    var tokenBox = Hive.box('tokens');
    String _token = tokenBox.get('access') ?? 'null';
    // print(_token);
    Map<String, String> headers = {
      "Authorization": "Bearer $_token",
      "Content-type": "application/json",
      "Accept": "application/json",
    };

    final response = await http.get(
      Uri.parse('${baseUrlApi}quiz'),
      headers: headers,
    );

    if (response.statusCode == 200
        //  &&
        //     _dateTime.day <= DateTime.now().day &&
        //     _dateTime.month >= DateTime.now().month &&
        //     _dateTime.year == DateTime.now().year
        ) {
      // if (response.statusCode > 0 &&
      //     !(_dateTime.day <= DateTime.now().day &&
      //         _dateTime.month >= DateTime.now().month &&
      //         _dateTime.year == DateTime.now().year)) {
      // final String jsonData =
      //     await rootBundle.loadString('assets/example_quizes.json');
      // final Map<String, dynamic> parsedJson = json.decode(jsonData);
      final Map<String, dynamic> parsedJson = jsonDecode(response.body)['data'];
      final List<Quiz> quizes = List<Quiz>.from(
          parsedJson['quizzes'].map((question) => Quiz.fromJson(question)));
      return quizes;
    }
    return null;
  }

  Future<List<FindWordModel>?> getFindWords() async {
    final String jsonData =
        await rootBundle.loadString('assets/find_words.json');
    final Map<String, dynamic> parsedJson = json.decode(jsonData);
    final List<FindWordModel> words = List<FindWordModel>.from(
        parsedJson['words'].map((word) => FindWordModel.fromJson(word)));
    return words;
  }

  Future<List<QuizQuestionModel>?> getQuizQuestions(
      int id, bool isEducation) async {
    var tokenBox = Hive.box('tokens');
    String _token = tokenBox.get('access') ?? 'null';

    Map<String, String> headers = {
      "Authorization": "Bearer $_token",
      "Content-type": "application/json",
      "Accept": "application/json",
    };

    String type = isEducation ? 'education_id' : 'quiz_id';

    final response = await http.get(
      Uri.parse('${baseUrlApi}questions?$type=$id'),
      headers: headers,
    );

    // if (response.statusCode > 0 &&
    if (response.statusCode == 200
        //  &&
        //     !(_dateTime.day <= DateTime.now().day &&
        //         _dateTime.month >= DateTime.now().month &&
        //         _dateTime.year == DateTime.now().year)
        ) {
      // final String jsonData =
      //     await rootBundle.loadString('assets/example_questions.json');
      // final Map<String, dynamic> parsedJson = json.decode(jsonData);
      final Map<String, dynamic> parsedJson = jsonDecode(response.body);
      final List<QuizQuestionModel> questions = List<QuizQuestionModel>.from(
          parsedJson['questions']
              .map((question) => QuizQuestionModel.fromJson(question)));
      return questions;
    }
    return null;
  }

  Future<ProfileModel?> getProfile() async {
    var tokenBox = Hive.box('tokens');
    var coinsBox = Hive.box('coins');
    var profileIdBox = Hive.box('profileId');
    String _token = tokenBox.get('access') ?? 'null';

    Map<String, String> headers = {
      "Authorization": "Bearer $_token",
      "Content-type": "application/json",
      "Accept": "application/json",
    };
    if (_token != 'null') {
      final response = await http.get(
        Uri.parse('${baseUrlApi}profile'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // final String jsonData =
        //     await rootBundle.loadString('assets/example_profile.json');
        // final Map<String, dynamic> parsedJson = json.decode(jsonData);
        final Map<String, dynamic> parsedJson = jsonDecode(response.body);
        final ProfileModel profileModel = ProfileModel.fromJson(parsedJson);
        coinsBox.put('coins', profileModel.medcoins);
        profileIdBox.put('id', profileModel.id);
        // print('get profile: ${response.statusCode}');
        return profileModel;
      } else if (response.statusCode == 401) {
        return ProfileModel(
          id: -401,
          urlAvatar: 'urlAvatar',
          name: 'name fname',
          age: -1,
          email: 'email',
          aboutMe: 'name fname mname',
          medcoins: -1,
        );
      } else if (response.statusCode == 404) {
        final Map<String, dynamic> parsedJson = jsonDecode(response.body);
        if (parsedJson['code'] == 401) {
          return ProfileModel(
            id: -401,
            urlAvatar: 'urlAvatar',
            name: 'name fname',
            age: -1,
            email: 'email',
            aboutMe: 'name fname mname',
            medcoins: -1,
          );
        }
      }
    }
    return null;
  }
}
