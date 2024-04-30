// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:clients_app/data/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/models/profile_model.dart';
import 'blocs/get_profile_bloc/get_profile_bloc.dart';
import 'blocs/update_profile_cubit/update_profile_cubit.dart';

// https://trener59.ru/trenirovki-2/trenirovki/
List<String> _questions = [
  // muscles
  'The calf muscle',
  'Biceps muscle',
  'The tailor\'s muscle',
  'Rectus abdominis muscle',
  'Trapezius muscle',
  // mind
  'Frontal Lobe',
  'Parietal lobe',
  'Occipital lobe',
  'Cerebellum',
  'Temporal lobe',
  // skeleton
  'Pelvis',
  'Sternum',
  'Skull',
  'Rib',
  'Femur',
];
List<int> _correctIndexes = [
  // muscles
  5, 2, 4, 3, 1,
  // mind
  2, 1, 3, 5, 4,
  // skeleton
  4, 2, 1, 3, 5,
];
int _choosedIndex = -1;
int _stepIndex = 0;
int _questionIndex = 0;
int _correctAnswers = 0;
var coinsBox = Hive.box('coins');
int coins = coinsBox.get('coins');
bool _canChoose = true;

class EducationDiagramPage extends StatefulWidget {
  const EducationDiagramPage({super.key});

  @override
  State<EducationDiagramPage> createState() => _EducationDiagramPageState();
}

class _EducationDiagramPageState extends State<EducationDiagramPage> {
  @override
  void initState() {
    super.initState();
    _choosedIndex = -1;
    _stepIndex = 0;
    _questionIndex = 0;
    _correctAnswers = 0;
    coins = coinsBox.get('coins');
  }

  double maxWidth(BuildContext ct) => MediaQuery.of(ct).size.width;
  @override
  Widget build(BuildContext context) {
    var _listPages = [
      muscle_quizes(context),
      mind_quizes(context),
      skeleton_quizes(context),
    ];
    return Scaffold(
      backgroundColor: Color(0xffFFFCA9),
      extendBody: true,
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color(0xff6A3900),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: Text(
          'What is it?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: _stepIndex != 3
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        '${_questionIndex + 1}. ${_questions[_questionIndex]}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 40),
                      // mind_quizes(context),
                      _listPages[_stepIndex],
                      SizedBox(height: 20),
                      next_button(0)
                    ],
                  ),
                ),
              )
            : success_body(context),
      ),
    );
  }

  Column success_body(BuildContext context) {
    return Column(
      children: [
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
                            '${_correctAnswers * 10}',
                            // '140',
                            style: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.w700,
                              color: backgroundColor,
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
                    row_info('All', '${20}'),
                    SizedBox(height: 16),
                    row_info('Correct', '$_correctAnswers'),
                    SizedBox(height: 16),
                    row_info('Wrong', '${20 - _correctAnswers}'),
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

  Row row_info(String title, String value) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: 150,
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: appBarColor,
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
          color: backgroundColor,
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
      ],
    );
  }

  Stack mind_quizes(BuildContext context) {
    return Stack(
      // alignment: Alignment.centerLeft,
      children: [
        Image.asset(
          'assets/images/mind.png',
          height: ((maxWidth(context) - 32) / 568) * 439,
          width: maxWidth(context) - 32,
          fit: BoxFit.contain,
        ),
        SizedBox(width: maxWidth(context) - 32),
        Positioned(
          left: 120,
          top: 50,
          child: InkWell(
            radius: 0,
            onTap: () {
              if (mounted && _canChoose) {
                setState(() {
                  _choosedIndex = 1;
                  1 == _correctIndexes[_questionIndex]
                      ? _correctAnswers++
                      : null;
                });
              }
            },
            child: CircleAvatar(
              radius: 24,
              backgroundColor: _choosedIndex == -1
                  ? buttonColor
                  : 1 == _correctIndexes[_questionIndex] && 1 == _choosedIndex
                      ? correctColor
                      : 1 == _correctIndexes[_questionIndex] &&
                              1 != _choosedIndex
                          ? correctColor
                          : 1 != _correctIndexes[_questionIndex] &&
                                  1 == _choosedIndex
                              ? wrongColor
                              : Colors.white,
              child: Text(
                'A',
                style: TextStyle(
                  fontSize: 20,
                  color: _choosedIndex == -1
                      ? Colors.white
                      : 1 == _correctIndexes[_questionIndex] ||
                              1 == _choosedIndex
                          ? Colors.white
                          : Colors.black,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 80,
          top: 60,
          child: InkWell(
            radius: 0,
            onTap: () {
              if (mounted && _canChoose) {
                setState(() {
                  _choosedIndex = 2;
                  2 == _correctIndexes[_questionIndex]
                      ? _correctAnswers++
                      : null;
                });
              }
            },
            child: CircleAvatar(
              radius: 24,
              backgroundColor: _choosedIndex == -1
                  ? buttonColor
                  : 2 == _correctIndexes[_questionIndex] && 2 == _choosedIndex
                      ? correctColor
                      : 2 == _correctIndexes[_questionIndex] &&
                              2 != _choosedIndex
                          ? correctColor
                          : 2 != _correctIndexes[_questionIndex] &&
                                  2 == _choosedIndex
                              ? wrongColor
                              : Colors.white,
              child: Text(
                'B',
                style: TextStyle(
                  fontSize: 20,
                  color: _choosedIndex == -1
                      ? Colors.white
                      : 2 == _correctIndexes[_questionIndex] ||
                              2 == _choosedIndex
                          ? Colors.white
                          : Colors.black,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 45,
          bottom: 85,
          child: InkWell(
            radius: 0,
            onTap: () {
              if (mounted && _canChoose) {
                setState(() {
                  _choosedIndex = 3;
                  3 == _correctIndexes[_questionIndex]
                      ? _correctAnswers++
                      : null;
                });
              }
            },
            child: CircleAvatar(
              radius: 24,
              backgroundColor: _choosedIndex == -1
                  ? buttonColor
                  : 3 == _correctIndexes[_questionIndex] && 3 == _choosedIndex
                      ? correctColor
                      : 3 == _correctIndexes[_questionIndex] &&
                              3 != _choosedIndex
                          ? correctColor
                          : 3 != _correctIndexes[_questionIndex] &&
                                  3 == _choosedIndex
                              ? wrongColor
                              : Colors.white,
              child: Text(
                'С',
                style: TextStyle(
                  fontSize: 20,
                  color: _choosedIndex == -1
                      ? Colors.white
                      : 3 == _correctIndexes[_questionIndex] ||
                              3 == _choosedIndex
                          ? Colors.white
                          : Colors.black,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 130,
          bottom: 80,
          child: InkWell(
            radius: 0,
            onTap: () {
              if (mounted && _canChoose) {
                setState(() {
                  _choosedIndex = 4;
                  4 == _correctIndexes[_questionIndex]
                      ? _correctAnswers++
                      : null;
                });
              }
            },
            child: CircleAvatar(
              radius: 24,
              backgroundColor: _choosedIndex == -1
                  ? buttonColor
                  : 4 == _correctIndexes[_questionIndex] && 4 == _choosedIndex
                      ? correctColor
                      : 4 == _correctIndexes[_questionIndex] &&
                              4 != _choosedIndex
                          ? correctColor
                          : 4 != _correctIndexes[_questionIndex] &&
                                  4 == _choosedIndex
                              ? wrongColor
                              : Colors.white,
              child: Text(
                'D',
                style: TextStyle(
                  fontSize: 20,
                  color: _choosedIndex == -1
                      ? Colors.white
                      : 4 == _correctIndexes[_questionIndex] ||
                              4 == _choosedIndex
                          ? Colors.white
                          : Colors.black,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 100,
          bottom: 20,
          child: InkWell(
            radius: 0,
            onTap: () {
              if (mounted && _canChoose) {
                setState(() {
                  _choosedIndex = 5;
                  5 == _correctIndexes[_questionIndex]
                      ? _correctAnswers++
                      : null;
                });
              }
            },
            child: CircleAvatar(
              radius: 24,
              backgroundColor: _choosedIndex == -1
                  ? buttonColor
                  : 5 == _correctIndexes[_questionIndex] && 5 == _choosedIndex
                      ? correctColor
                      : 5 == _correctIndexes[_questionIndex] &&
                              5 != _choosedIndex
                          ? correctColor
                          : 5 != _correctIndexes[_questionIndex] &&
                                  5 == _choosedIndex
                              ? wrongColor
                              : Colors.white,
              child: Text(
                'E',
                style: TextStyle(
                  fontSize: 20,
                  color: _choosedIndex == -1
                      ? Colors.white
                      : 5 == _correctIndexes[_questionIndex] ||
                              5 == _choosedIndex
                          ? Colors.white
                          : Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Stack skeleton_quizes(BuildContext context) {
    return Stack(
      // alignment: Alignment.centerLeft,
      children: [
        Image.asset(
          'assets/images/skeleton.png',
          height: ((maxWidth(context) / 1.5) / 393) * 634,
          width: maxWidth(context) / 1.5,
          fit: BoxFit.contain,
        ),
        SizedBox(width: maxWidth(context) - 32),
        Positioned(
          right: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  if (mounted && _canChoose) {
                    setState(() {
                      _canChoose = false;
                      _choosedIndex = 1;
                      1 == _correctIndexes[_questionIndex]
                          ? _correctAnswers++
                          : null;
                    });
                  }
                },
                child: Row(
                  children: [
                    Container(
                      width: maxWidth(context) / 1.5 - 138,
                      height: 4,
                      color: _choosedIndex == -1
                          ? buttonColor
                          : 1 == _correctIndexes[_questionIndex] &&
                                  1 == _choosedIndex
                              ? correctColor
                              : 1 == _correctIndexes[_questionIndex] &&
                                      1 != _choosedIndex
                                  ? correctColor
                                  : 1 != _correctIndexes[_questionIndex] &&
                                          1 == _choosedIndex
                                      ? wrongColor
                                      : Colors.white,
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: _choosedIndex == -1
                          ? buttonColor
                          : 1 == _correctIndexes[_questionIndex] &&
                                  1 == _choosedIndex
                              ? correctColor
                              : 1 == _correctIndexes[_questionIndex] &&
                                      1 != _choosedIndex
                                  ? correctColor
                                  : 1 != _correctIndexes[_questionIndex] &&
                                          1 == _choosedIndex
                                      ? wrongColor
                                      : Colors.white,
                      child: Text(
                        '1',
                        style: TextStyle(
                          fontSize: 16,
                          color: _choosedIndex == -1
                              ? Colors.white
                              : 1 == _correctIndexes[_questionIndex] ||
                                      1 == _choosedIndex
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(width: 50),
                  ],
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  if (mounted && _canChoose) {
                    setState(() {
                      _canChoose = false;
                      _choosedIndex = 2;
                      2 == _correctIndexes[_questionIndex]
                          ? _correctAnswers++
                          : null;
                    });
                  }
                },
                child: Row(
                  children: [
                    Container(
                      width: maxWidth(context) / 1.5 - 168,
                      height: 4,
                      color: _choosedIndex == -1
                          ? buttonColor
                          : 2 == _correctIndexes[_questionIndex] &&
                                  2 == _choosedIndex
                              ? correctColor
                              : 2 == _correctIndexes[_questionIndex] &&
                                      2 != _choosedIndex
                                  ? correctColor
                                  : 2 != _correctIndexes[_questionIndex] &&
                                          2 == _choosedIndex
                                      ? wrongColor
                                      : Colors.white,
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: _choosedIndex == -1
                          ? buttonColor
                          : 2 == _correctIndexes[_questionIndex] &&
                                  2 == _choosedIndex
                              ? correctColor
                              : 2 == _correctIndexes[_questionIndex] &&
                                      2 != _choosedIndex
                                  ? correctColor
                                  : 2 != _correctIndexes[_questionIndex] &&
                                          2 == _choosedIndex
                                      ? wrongColor
                                      : Colors.white,
                      child: Text(
                        '2',
                        style: TextStyle(
                          fontSize: 16,
                          color: _choosedIndex == -1
                              ? Colors.white
                              : 2 == _correctIndexes[_questionIndex] ||
                                      2 == _choosedIndex
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(width: 100),
                  ],
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  if (mounted && _canChoose) {
                    setState(() {
                      _canChoose = false;
                      _choosedIndex = 3;
                      3 == _correctIndexes[_questionIndex]
                          ? _correctAnswers++
                          : null;
                    });
                  }
                },
                child: Row(
                  children: [
                    Container(
                      width: maxWidth(context) / 1.5 - 127,
                      height: 4,
                      color: _choosedIndex == -1
                          ? buttonColor
                          : 3 == _correctIndexes[_questionIndex] &&
                                  3 == _choosedIndex
                              ? correctColor
                              : 3 == _correctIndexes[_questionIndex] &&
                                      3 != _choosedIndex
                                  ? correctColor
                                  : 3 != _correctIndexes[_questionIndex] &&
                                          3 == _choosedIndex
                                      ? wrongColor
                                      : Colors.white,
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: _choosedIndex == -1
                          ? buttonColor
                          : 3 == _correctIndexes[_questionIndex] &&
                                  3 == _choosedIndex
                              ? correctColor
                              : 3 == _correctIndexes[_questionIndex] &&
                                      3 != _choosedIndex
                                  ? correctColor
                                  : 3 != _correctIndexes[_questionIndex] &&
                                          3 == _choosedIndex
                                      ? wrongColor
                                      : Colors.white,
                      child: Text(
                        '3',
                        style: TextStyle(
                          fontSize: 16,
                          color: _choosedIndex == -1
                              ? Colors.white
                              : 3 == _correctIndexes[_questionIndex] ||
                                      3 == _choosedIndex
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
              ),
              SizedBox(height: 0),
              GestureDetector(
                onTap: () {
                  if (mounted && _canChoose) {
                    setState(() {
                      _canChoose = false;
                      _choosedIndex = 4;
                      4 == _correctIndexes[_questionIndex]
                          ? _correctAnswers++
                          : null;
                    });
                  }
                },
                child: Row(
                  children: [
                    Container(
                      width: maxWidth(context) / 1.5 - 168,
                      height: 4,
                      color: _choosedIndex == -1
                          ? buttonColor
                          : 4 == _correctIndexes[_questionIndex] &&
                                  4 == _choosedIndex
                              ? correctColor
                              : 4 == _correctIndexes[_questionIndex] &&
                                      4 != _choosedIndex
                                  ? correctColor
                                  : 4 != _correctIndexes[_questionIndex] &&
                                          4 == _choosedIndex
                                      ? wrongColor
                                      : Colors.white,
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: _choosedIndex == -1
                          ? buttonColor
                          : 4 == _correctIndexes[_questionIndex] &&
                                  4 == _choosedIndex
                              ? correctColor
                              : 4 == _correctIndexes[_questionIndex] &&
                                      4 != _choosedIndex
                                  ? correctColor
                                  : 4 != _correctIndexes[_questionIndex] &&
                                          4 == _choosedIndex
                                      ? wrongColor
                                      : Colors.white,
                      child: Text(
                        '4',
                        style: TextStyle(
                          fontSize: 16,
                          color: _choosedIndex == -1
                              ? Colors.white
                              : 4 == _correctIndexes[_questionIndex] ||
                                      4 == _choosedIndex
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(width: 70),
                  ],
                ),
              ),
              SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  if (mounted && _canChoose) {
                    setState(() {
                      _canChoose = false;
                      _choosedIndex = 5;
                      5 == _correctIndexes[_questionIndex]
                          ? _correctAnswers++
                          : null;
                    });
                  }
                },
                child: Row(
                  children: [
                    Container(
                      width: maxWidth(context) / 1.5 - 103,
                      height: 4,
                      color: _choosedIndex == -1
                          ? buttonColor
                          : 5 == _correctIndexes[_questionIndex] &&
                                  5 == _choosedIndex
                              ? correctColor
                              : 5 == _correctIndexes[_questionIndex] &&
                                      5 != _choosedIndex
                                  ? correctColor
                                  : 5 != _correctIndexes[_questionIndex] &&
                                          5 == _choosedIndex
                                      ? wrongColor
                                      : Colors.white,
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: _choosedIndex == -1
                          ? buttonColor
                          : 5 == _correctIndexes[_questionIndex] &&
                                  5 == _choosedIndex
                              ? correctColor
                              : 5 == _correctIndexes[_questionIndex] &&
                                      5 != _choosedIndex
                                  ? correctColor
                                  : 5 != _correctIndexes[_questionIndex] &&
                                          5 == _choosedIndex
                                      ? wrongColor
                                      : Colors.white,
                      child: Text(
                        '5',
                        style: TextStyle(
                          fontSize: 16,
                          color: _choosedIndex == -1
                              ? Colors.white
                              : 5 == _correctIndexes[_questionIndex] ||
                                      5 == _choosedIndex
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(width: 50),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Stack muscle_quizes(BuildContext context) {
    return Stack(
      // alignment: Alignment.centerLeft,
      children: [
        Image.asset(
          'assets/images/muscles.png',
          height: ((maxWidth(context) / 1.5) / 393) * 634,
          width: maxWidth(context) / 1.5,
          fit: BoxFit.contain,
        ),
        SizedBox(width: maxWidth(context) - 32),
        Positioned(
          right: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: 45),
              GestureDetector(
                onTap: () {
                  if (mounted && _canChoose) {
                    setState(() {
                      _canChoose = false;
                      _choosedIndex = 1;
                      1 == _correctIndexes[_questionIndex]
                          ? _correctAnswers++
                          : null;
                    });
                  }
                },
                child: Row(
                  children: [
                    Container(
                      width: maxWidth(context) / 1.5 - 114,
                      height: 4,
                      color: _choosedIndex == -1
                          ? buttonColor
                          : 1 == _correctIndexes[_questionIndex] &&
                                  1 == _choosedIndex
                              ? correctColor
                              : 1 == _correctIndexes[_questionIndex] &&
                                      1 != _choosedIndex
                                  ? correctColor
                                  : 1 != _correctIndexes[_questionIndex] &&
                                          1 == _choosedIndex
                                      ? wrongColor
                                      : Colors.white,
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: _choosedIndex == -1
                          ? buttonColor
                          : 1 == _correctIndexes[_questionIndex] &&
                                  1 == _choosedIndex
                              ? correctColor
                              : 1 == _correctIndexes[_questionIndex] &&
                                      1 != _choosedIndex
                                  ? correctColor
                                  : 1 != _correctIndexes[_questionIndex] &&
                                          1 == _choosedIndex
                                      ? wrongColor
                                      : Colors.white,
                      child: Text(
                        '1',
                        style: TextStyle(
                          fontSize: 16,
                          color: _choosedIndex == -1
                              ? Colors.white
                              : 1 == _correctIndexes[_questionIndex] ||
                                      1 == _choosedIndex
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(width: 30),
                  ],
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  if (mounted && _canChoose) {
                    setState(() {
                      _canChoose = false;
                      _choosedIndex = 2;
                      2 == _correctIndexes[_questionIndex]
                          ? _correctAnswers++
                          : null;
                    });
                  }
                },
                child: Row(
                  children: [
                    Container(
                      width: maxWidth(context) / 1.5 - 118,
                      height: 4,
                      color: _choosedIndex == -1
                          ? buttonColor
                          : 2 == _correctIndexes[_questionIndex] &&
                                  2 == _choosedIndex
                              ? correctColor
                              : 2 == _correctIndexes[_questionIndex] &&
                                      2 != _choosedIndex
                                  ? correctColor
                                  : 2 != _correctIndexes[_questionIndex] &&
                                          2 == _choosedIndex
                                      ? wrongColor
                                      : Colors.white,
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: _choosedIndex == -1
                          ? buttonColor
                          : 2 == _correctIndexes[_questionIndex] &&
                                  2 == _choosedIndex
                              ? correctColor
                              : 2 == _correctIndexes[_questionIndex] &&
                                      2 != _choosedIndex
                                  ? correctColor
                                  : 2 != _correctIndexes[_questionIndex] &&
                                          2 == _choosedIndex
                                      ? wrongColor
                                      : Colors.white,
                      child: Text(
                        '2',
                        style: TextStyle(
                          fontSize: 16,
                          color: _choosedIndex == -1
                              ? Colors.white
                              : 2 == _correctIndexes[_questionIndex] ||
                                      2 == _choosedIndex
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 0),
              GestureDetector(
                onTap: () {
                  if (mounted && _canChoose) {
                    setState(() {
                      _canChoose = false;
                      _choosedIndex = 3;
                      3 == _correctIndexes[_questionIndex]
                          ? _correctAnswers++
                          : null;
                    });
                  }
                },
                child: Row(
                  children: [
                    Container(
                      width: maxWidth(context) / 1.5 - 123,
                      height: 4,
                      color: _choosedIndex == -1
                          ? buttonColor
                          : 3 == _correctIndexes[_questionIndex] &&
                                  3 == _choosedIndex
                              ? correctColor
                              : 3 == _correctIndexes[_questionIndex] &&
                                      3 != _choosedIndex
                                  ? correctColor
                                  : 3 != _correctIndexes[_questionIndex] &&
                                          3 == _choosedIndex
                                      ? wrongColor
                                      : Colors.white,
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: _choosedIndex == -1
                          ? buttonColor
                          : 3 == _correctIndexes[_questionIndex] &&
                                  3 == _choosedIndex
                              ? correctColor
                              : 3 == _correctIndexes[_questionIndex] &&
                                      3 != _choosedIndex
                                  ? correctColor
                                  : 3 != _correctIndexes[_questionIndex] &&
                                          3 == _choosedIndex
                                      ? wrongColor
                                      : Colors.white,
                      child: Text(
                        '3',
                        style: TextStyle(
                          fontSize: 16,
                          color: _choosedIndex == -1
                              ? Colors.white
                              : 3 == _correctIndexes[_questionIndex] ||
                                      3 == _choosedIndex
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(width: 50),
                  ],
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  if (mounted && _canChoose) {
                    setState(() {
                      _canChoose = false;
                      _choosedIndex = 4;
                      4 == _correctIndexes[_questionIndex]
                          ? _correctAnswers++
                          : null;
                    });
                  }
                },
                child: Row(
                  children: [
                    Container(
                      width: maxWidth(context) / 1.5 - 100,
                      height: 4,
                      color: _choosedIndex == -1
                          ? buttonColor
                          : 4 == _correctIndexes[_questionIndex] &&
                                  4 == _choosedIndex
                              ? correctColor
                              : 4 == _correctIndexes[_questionIndex] &&
                                      4 != _choosedIndex
                                  ? correctColor
                                  : 4 != _correctIndexes[_questionIndex] &&
                                          4 == _choosedIndex
                                      ? wrongColor
                                      : Colors.white,
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: _choosedIndex == -1
                          ? buttonColor
                          : 4 == _correctIndexes[_questionIndex] &&
                                  4 == _choosedIndex
                              ? correctColor
                              : 4 == _correctIndexes[_questionIndex] &&
                                      4 != _choosedIndex
                                  ? correctColor
                                  : 4 != _correctIndexes[_questionIndex] &&
                                          4 == _choosedIndex
                                      ? wrongColor
                                      : Colors.white,
                      child: Text(
                        '4',
                        style: TextStyle(
                          fontSize: 16,
                          color: _choosedIndex == -1
                              ? Colors.white
                              : 4 == _correctIndexes[_questionIndex] ||
                                      4 == _choosedIndex
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
              ),
              SizedBox(height: 45),
              GestureDetector(
                onTap: () {
                  if (mounted && _canChoose) {
                    setState(() {
                      _canChoose = false;
                      _choosedIndex = 5;
                      5 == _correctIndexes[_questionIndex]
                          ? _correctAnswers++
                          : null;
                    });
                  }
                },
                child: Row(
                  children: [
                    Container(
                      width: maxWidth(context) / 1.5 - 108,
                      height: 4,
                      color: _choosedIndex == -1
                          ? buttonColor
                          : 5 == _correctIndexes[_questionIndex] &&
                                  5 == _choosedIndex
                              ? correctColor
                              : 5 == _correctIndexes[_questionIndex] &&
                                      5 != _choosedIndex
                                  ? correctColor
                                  : 5 != _correctIndexes[_questionIndex] &&
                                          5 == _choosedIndex
                                      ? wrongColor
                                      : Colors.white,
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: _choosedIndex == -1
                          ? buttonColor
                          : 5 == _correctIndexes[_questionIndex] &&
                                  5 == _choosedIndex
                              ? correctColor
                              : 5 == _correctIndexes[_questionIndex] &&
                                      5 != _choosedIndex
                                  ? correctColor
                                  : 5 != _correctIndexes[_questionIndex] &&
                                          5 == _choosedIndex
                                      ? wrongColor
                                      : Colors.white,
                      child: Text(
                        '5',
                        style: TextStyle(
                          fontSize: 16,
                          color: _choosedIndex == -1
                              ? Colors.white
                              : 5 == _correctIndexes[_questionIndex] ||
                                      5 == _choosedIndex
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(width: 50),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  GestureDetector next_button(int length) {
    return GestureDetector(
      onTap: () {
        if (_questionIndex == 4 ||
            _questionIndex == 9 ||
            _questionIndex == 14) {
          if (mounted) {
            setState(() {
              _stepIndex++;
            });
            if (_stepIndex == 3) {
              context.read<UpdateProfileCubit>().updateProfile(
                    ProfileModel(
                      id: -1,
                      urlAvatar: '',
                      name: '',
                      age: -1,
                      medcoins: coins + _correctAnswers * 10,
                      email: '',
                      aboutMe: '',
                    ),
                    null,
                  );
              context.read<GetProfileBloc>().add(GetProfileEvent());
            }
          }
        }
        if (mounted) {
          setState(() {
            _questionIndex++;
            _choosedIndex = -1;
            _canChoose = true;
          });
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
}
