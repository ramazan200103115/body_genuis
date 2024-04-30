// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/ri.dart';

import 'package:clients_app/data/constants/colors.dart';
import 'package:clients_app/screens/blocs/get_quiz_questions_bloc/get_quiz_questions_bloc.dart';

import '../data/api/config.dart';
import '../data/models/profile_model.dart';
import '../data/models/question_model.dart';
import 'blocs/get_profile_bloc/get_profile_bloc.dart';
import 'blocs/update_profile_cubit/update_profile_cubit.dart';
import 'blocs/update_quiz_cubit/update_quiz_cubit.dart';

Duration _time = Duration(minutes: 5);
Timer? timer;
int _minutes = 5;
int _seconds = 0;
bool _isLosing = false;
bool _ended = false;
int _choosedIndex = -1;
int _qIndex = 0;
int _correctAnswers = 0;
int _wrongAnswers = 0;
bool _canChoose = true;

List<Color> _listColors = [
  buttonColor,
  buttonColor,
  buttonColor,
  buttonColor,
];

List<String> _answersList = [
  'S cdsj sdnmsdc dscds cdsm dcsj dsc jdc cdscsdcsdcsdcsd',
  'S cdsj sdnmsdc dscds cdsm dcsj dsc jdc cdscsdcsdcsdcsd',
  'S cdsj sdnmsdc dscds cdsm dcsj dsc jdc cdscsdcsdcsdcsd',
  'S cdsj sdnmsdc dscds cdsm dcsj dsc jdc cdscsdcsdcsdcsd',
];
var coinsBox = Hive.box('coins');
int coins = coinsBox.get('coins');

class OnlineQuizPage extends StatefulWidget {
  final int quizId;
  final String quizTitle;
  final bool isEducation;
  const OnlineQuizPage({
    Key? key,
    required this.quizId,
    required this.quizTitle,
    required this.isEducation,
  }) : super(key: key);

  @override
  State<OnlineQuizPage> createState() => _OnlineQuizPageState();
}

class _OnlineQuizPageState extends State<OnlineQuizPage> {
  double maxWidth(BuildContext context) => MediaQuery.of(context).size.width;
  @override
  void initState() {
    super.initState();
    coins = coinsBox.get('coins');
    _qIndex = 0;
    _correctAnswers = 0;
    _wrongAnswers = 0;
    _choosedIndex = -1;
    _ended = false;
    _listColors = [
      buttonColor,
      buttonColor,
      buttonColor,
      buttonColor,
    ];
    _canChoose = true;
    context
        .read<GetQuizQuestionsBloc>()
        .add(GetQuiz(quizId: widget.quizId, isEducation: widget.isEducation));
    _time = Duration(minutes: 20);
    _isLosing = false;
    startTimer(() {
      _isLosing ? Navigator.of(context).pop() : null;
      times_is_up(
        context,
        () {
          Navigator.of(context).pop();
        },
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void tick(Function onLose) {
    if (mounted) {
      setState(() {
        final seconds = _time.inSeconds - 1;
        _minutes = _time.inSeconds ~/ 60;
        _seconds = seconds - (_minutes * 60);
        _seconds = _seconds < 0 ? 0 : _seconds;
        if (seconds == 0) {
          onLose();
          timer?.cancel();
        }

        _time = Duration(seconds: seconds);
      });
    }
  }

  void startTimer(Function onLose) {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      tick(onLose);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFCA9),
      extendBody: true,
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: BlocConsumer<GetQuizQuestionsBloc, GetQuizQuestionsState>(
          listener: (context, state) {
            if (state is GetQuizSuccess) {
              if (_qIndex == state.questions.length) {
                timer?.cancel();
                if (mounted) {
                  setState(() {
                    _ended = true;
                  });
                }
              }
            }
          },
          builder: (context, state) {
            return state is GetQuizLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: buttonColor,
                    ),
                  )
                : state is GetQuizSuccess
                    ? _qIndex == state.questions.length
                        ? success_body(context, state)
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              appBar(context),
                              top_body(context, state.questions[_qIndex]),
                              SizedBox(height: 8),
                              next_button(state.questions.length),
                              SizedBox(height: 8),
                              answers_list_body(context, state.questions),
                              SizedBox(height: 10),
                            ],
                          )
                    : Center(
                        child: Text(
                          'serverError',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.red,
                          ),
                        ),
                      );
          },
        ),
      ),
    );
  }

  Column success_body(BuildContext context, GetQuizSuccess state) {
    return Column(
      children: [
        appBar(context),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: maxWidth(context),
                      height: maxWidth(context) * 0.75,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                              'assets/images/success_background.png'),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 50, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(200),
                          ),
                          child: Text(
                            '${_correctAnswers * (widget.isEducation ? 10 : 20)}',
                            // '140',
                            style: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff6A3900),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Column(
                  children: [
                    row_info('All', '${state.questions.length}'),
                    SizedBox(height: 16),
                    row_info('Correct', '$_correctAnswers'),
                    SizedBox(height: 16),
                    row_info(
                        'Wrong', '${state.questions.length - _correctAnswers}'),
                    SizedBox(height: 30),
                    ok_back(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Row row_info(String title, String value) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Spacer(),
        SizedBox(
          width: 10,
        ),
        Container(
          width: 150,
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Color(0xff6A3900),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          width: 150,
          padding: EdgeInsets.symmetric(horizontal: 30),
          color: Color(0xffFFFCA9),
          child: Container(
            width: 90,
            padding: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: appBarColor,
              ),
            ),
          ),
        ),
        Spacer(),
      ],
    );
  }

  Padding answers_list_body(BuildContext context, List<QuizQuestionModel> qs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(
          4,
          (index) => InkWell(
            onTap: () {
              if (mounted && _canChoose) {
                setState(() {
                  _choosedIndex = index;
                  index == qs[_qIndex].answerIndex
                      ? _correctAnswers++
                      : _wrongAnswers++;
                  _canChoose = false;
                });
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: _choosedIndex == -1
                    ? buttonColor
                    : index == qs[_qIndex].answerIndex && index == _choosedIndex
                        ? correctColor
                        : index == qs[_qIndex].answerIndex &&
                                index != _choosedIndex
                            ? correctColor
                            : index != qs[_qIndex].answerIndex &&
                                    index == _choosedIndex
                                ? wrongColor
                                : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Iconify(
                    Ri.stethoscope_fill,
                    size: 24,
                    color: _choosedIndex == -1
                        ? Colors.white
                        : index == qs[_qIndex].answerIndex ||
                                index == _choosedIndex
                            ? Colors.white
                            : Colors.black,
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    width: maxWidth(context) - 114,
                    child: Text(
                      qs[_qIndex].options[index],
                      style: TextStyle(
                        fontSize: 14,
                        height: 18 / 14,
                        color: _choosedIndex == -1
                            ? Colors.white
                            : index == qs[_qIndex].answerIndex ||
                                    index == _choosedIndex
                                ? Colors.white
                                : Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.close,
                    color: Colors.red.withOpacity(_choosedIndex != -1
                        ? index == qs[_qIndex].answerIndex &&
                                index != _choosedIndex
                            ? 1
                            : 0
                        : 0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector ok_back() {
    return GestureDetector(
      onTap: () {
        context.read<GetProfileBloc>().add(GetProfileEvent());
        Navigator.of(context).pop();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        decoration: BoxDecoration(
          color: buttonYellowColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'Ok, back to home!',
          style: TextStyle(
            fontSize: 18,
            height: 22 / 18,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  GestureDetector next_button(int length) {
    return GestureDetector(
      onTap: () {
        if (mounted) {
          setState(() {
            _qIndex++;
            _choosedIndex = -1;
            _canChoose = true;
          });
        }
        if (_qIndex == length) {
          context.read<UpdateQuizCubit>().updateQuiz(
              widget.quizId, ((_correctAnswers / (length)) * 100).round());
          context.read<UpdateProfileCubit>().updateProfile(
                ProfileModel(
                  id: -1,
                  urlAvatar: '',
                  name: '',
                  age: -1,
                  medcoins:
                      coins + _correctAnswers * (widget.isEducation ? 10 : 20),
                  email: '',
                  aboutMe: '',
                ),
                null,
              );
          context.read<GetProfileBloc>().add(GetProfileEvent());
          timer?.cancel();
          if (mounted) {
            setState(() {
              _ended = true;
            });
          }
        }
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        decoration: BoxDecoration(
          color: buttonYellowColor.withOpacity(_choosedIndex == -1 ? 0 : 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Next',
              style: TextStyle(
                fontSize: 14,
                height: 18 / 14,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(_choosedIndex == -1 ? 0 : 1),
              ),
            ),
            SizedBox(width: 6),
            Icon(
              Icons.arrow_forward,
              color: Colors.white.withOpacity(_choosedIndex == -1 ? 0 : 1),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Expanded top_body(BuildContext context, QuizQuestionModel question) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 8,
            width: maxWidth(context),
          ),
          SizedBox(
            width: maxWidth(context) - 40,
            child: Text(
              // question,
              '${_qIndex + 1}. ${question.question}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                height: 26 / 20,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 8),
          question.imageUrl != null && question.imageUrl != 'null'
              ? network_image(question.imageUrl!)
              : SizedBox(),
        ],
      ),
    );
  }

  Future<dynamic> show_image(BuildContext context, ImageProvider ip) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          content: Container(
            width: maxWidth(context),
            height: maxWidth(context) / 1.5,
            decoration: BoxDecoration(
              color: Colors.white,
              // borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: ip,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget network_image(String url) {
    return Expanded(
      child: CachedNetworkImage(
        imageUrl: baseUrl + url,
        // baseUrl + (url != '/assets/image/image-not-found.jpg' ? url : ''),
        imageBuilder: (context, imageProvider) => InkWell(
          splashColor: Colors.white,
          highlightColor: Colors.white,
          onTap: () {
            show_image(context, imageProvider);
          },
          child: Container(
            // width: 150,
            // height: 150,
            width: double.infinity,
            height: double.infinity,
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        placeholder: (context, url) => Container(
          // width: 150,
          // height: 150,
          width: double.infinity,
          height: double.infinity,
          margin: EdgeInsets.all(16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const CircularProgressIndicator(
            color: buttonColor,
          ),
        ),
        errorWidget: (context, url, error) => Container(
          // width: 150,
          // height: 150,
          width: double.infinity,
          height: double.infinity,
          margin: EdgeInsets.all(16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: buttonColor, width: 2),
          ),
          child: Iconify(
            MaterialSymbols.wifi_off_rounded,
            color: buttonColor,
            size: 50,
          ),
        ),
      ),
    );
  }

  Container appBar(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xff6A3900),
      ),
      child: Row(
        children: [
          SizedBox(
            width: maxWidth(context) - 140,
            child: Text(
              widget.quizTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 24 / 20,
              ),
            ),
          ),
          Spacer(),
          SizedBox(width: 10),
          Text(
            // '10:00',
            '${_minutes < 10 ? '0$_minutes' : _minutes}:${_seconds < 10 ? '0$_seconds' : _seconds}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          // SizedBox(width: 10),
          _ended
              ? SizedBox(height: 44)
              : IconButton(
                  onPressed: () {
                    if (mounted) {
                      if (!_ended) {
                        setState(() {
                          _isLosing = true;
                        });
                        want_to_lose(
                          context,
                          () {
                            Navigator.of(context).pop();
                          },
                        );
                      }
                    }
                  },
                  icon: Icon(
                    Icons.close_rounded,
                    size: 30,
                    color: Colors.red.withOpacity(_ended ? 0 : 1),
                  ),
                ),
        ],
      ),
    );
  }

  Future<Object?> times_is_up(BuildContext context, Function onYes) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      pageBuilder: (context, animation, secondaryAnimation) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide.none,
        ),
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.all(20),
        // titlePadding: const EdgeInsets.symmetric(
        //     vertical: 16, horizontal: 16),
        // title: Text(
        //   '_language',
        //   // style: tsbl_14_600,
        // ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Time is UP. You losed(',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                height: 28 / 22,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: maxWidth(context) - 40,
              child: Row(
                children: [
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      onYes();
                    },
                    child: Container(
                      // width: (maxWidth(context) - 84) / 2,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: appBarColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'OK, to quizes list',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Object?> want_to_lose(BuildContext context, Function onYes) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "",
      pageBuilder: (context, animation, secondaryAnimation) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide.none,
        ),
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.all(20),
        // titlePadding: const EdgeInsets.symmetric(
        //     vertical: 16, horizontal: 16),
        // title: Text(
        //   '_language',
        //   // style: tsbl_14_600,
        // ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Do you want to lose?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                height: 28 / 22,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (mounted) {
                      setState(() {
                        _isLosing = false;
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                    width: (maxWidth(context) - 84) / 2,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'No',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    onYes();
                  },
                  child: Container(
                    width: (maxWidth(context) - 84) / 2,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: appBarColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Yes',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
