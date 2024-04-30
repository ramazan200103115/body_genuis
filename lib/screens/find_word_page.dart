// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:clients_app/data/models/find_word_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:clients_app/data/constants/colors.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/models/profile_model.dart';
import 'blocs/get_find_words_bloc/get_find_words_bloc.dart';
import 'blocs/get_profile_bloc/get_profile_bloc.dart';
import 'blocs/update_profile_cubit/update_profile_cubit.dart';

int _wordIndex = 0;
int _correctAnswers = 0;
bool _goNext = false;
List<int> _choosedLetterIndexes = [];
List<String> _choosedLetters = [];
var coinsBox = Hive.box('coins');
int coins = coinsBox.get('coins');

class FindWordPage extends StatefulWidget {
  const FindWordPage({Key? key}) : super(key: key);

  @override
  State<FindWordPage> createState() => _FindWordPageState();
}

class _FindWordPageState extends State<FindWordPage> {
  double maxWidth(BuildContext context) => MediaQuery.of(context).size.width;
  @override
  void initState() {
    super.initState();
    _wordIndex = 0;
    _correctAnswers = 0;
    _goNext = false;
    _choosedLetters = [];
    _choosedLetterIndexes = [];
    coins = coinsBox.get('coins');
    context.read<GetFindWordsBloc>().add(GetFindWordsEvent());
  }

  @override
  Widget build(BuildContext context) {
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
          'Find Word',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<GetFindWordsBloc, GetFindWordsState>(
          builder: (context, state) {
            return state is GetFindWordsLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: buttonColor,
                    ),
                  )
                : state is GetFindWordsSuccess
                    ? _wordIndex == state.words.length
                        ? success_body(context, state)
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              top_body(context, state.words[_wordIndex]),
                              // SizedBox(height: 37),
                              Spacer(),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 36),
                                child: Wrap(
                                  spacing: 4,
                                  runSpacing: 4,
                                  children: List.generate(
                                    state.words[_wordIndex].listLetters.length,
                                    (index) => InkWell(
                                      onTap: () {
                                        if (state.words[_wordIndex].word
                                                    .length !=
                                                _choosedLetters.length &&
                                            !_choosedLetterIndexes
                                                .contains(index)) {
                                          setState(() {
                                            _choosedLetterIndexes.add(index);
                                            _choosedLetters.add(state
                                                .words[_wordIndex]
                                                .listLetters[index]
                                                .toUpperCase());
                                          });
                                        }
                                        if (listEquals(
                                            state.words[_wordIndex].word
                                                .toUpperCase()
                                                .split(''),
                                            _choosedLetters)) {
                                          setState(() {
                                            _goNext = true;
                                            _correctAnswers++;
                                          });
                                        }
                                      },
                                      radius: 0,
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: _choosedLetterIndexes
                                                  .contains(index)
                                              ? correctColor
                                              // : buttonColor.withOpacity(0.8),
                                              : Color(0xffA7875B)
                                                  .withOpacity(0.8),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          state.words[_wordIndex]
                                              .listLetters[index]
                                              .toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              next_button(state.words.length),
                              Spacer(),
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

  Column success_body(BuildContext context, GetFindWordsSuccess state) {
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
                    row_info('All', '${state.words.length}'),
                    SizedBox(height: 16),
                    row_info('Correct', '$_correctAnswers'),
                    // SizedBox(height: 16),
                    // row_info(
                    //     'Wrong', '${state.words.length - _correctAnswers}'),
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
      ],
    );
  }

  GestureDetector next_button(int length) {
    return GestureDetector(
      onTap: () {
        if (mounted && _goNext) {
          setState(() {
            _wordIndex++;
            // print(_wordIndex);
            _goNext = false;
            _choosedLetters = [];
            _choosedLetterIndexes = [];
          });
        }
        if (_wordIndex == length) {
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
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        decoration: BoxDecoration(
          color: buttonYellowColor.withOpacity(_goNext ? 1 : 0),
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
                color: Colors.white.withOpacity(_goNext ? 1 : 0),
              ),
            ),
            SizedBox(width: 6),
            Icon(
              Icons.arrow_forward,
              color: Colors.white.withOpacity(_goNext ? 1 : 0),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget top_body(BuildContext context, FindWordModel word) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 37,
          width: maxWidth(context),
        ),
        image_body(word.image),
        SizedBox(height: 44),
        Wrap(
          // mainAxisSize: MainAxisSize.min,
          spacing: 6,
          children: List.generate(
            word.word.length,
            (index) => InkWell(
              radius: 0,
              onTap: () {
                if (index <= _choosedLetterIndexes.length) {
                  setState(() {
                    _choosedLetterIndexes.removeAt(index);
                    _choosedLetters.removeAt(index);
                    _goNext = false;
                  });
                }
              },
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Color(0xff6A3900)
                    .withOpacity(_choosedLetters.length - 1 >= index ? 1 : 0.5),
                child: _choosedLetters.length - 1 >= index &&
                        _choosedLetters.isNotEmpty
                    ? Text(
                        _choosedLetters[index].toUpperCase(),
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      )
                    : SizedBox(),
              ),
            ),
          ),
        ),
      ],
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

  Widget image_body(String url) {
    return InkWell(
      splashColor: Colors.white,
      highlightColor: Colors.white,
      onTap: () {
        show_image(context, AssetImage('assets/images/$url'));
      },
      child: Container(
        width: 200,
        height: 200,
        // width: maxWidth(context) - 32,
        // height: maxWidth(context) - 32,
        margin: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: AssetImage('assets/images/$url'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
