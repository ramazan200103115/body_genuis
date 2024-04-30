// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clients_app/data/constants/colors.dart';
import 'package:clients_app/data/models/profile_model.dart';
import 'package:clients_app/screens/blocs/get_list_quizes_bloc/get_list_quizes_bloc.dart';
import 'package:clients_app/screens/blocs/get_profile_bloc/get_profile_bloc.dart';
import 'package:clients_app/screens/blocs/get_quiz_by_code_cubit/get_quiz_by_code_cubit.dart';
import 'package:clients_app/screens/blocs/update_profile_cubit/update_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/ph.dart';

import '../data/models/quiz_model.dart';
import 'online_quiz_page.dart';

// List<String> _listTopics = [
//   'Cytology Basics',
//   'Cell Structure and Function',
//   'Introduction to Osteology',
//   'Bones of the Human Body',
//   'Syndesmology: Study of Joints',
//   'Types of Joints',
//   'Myology: Muscles and Their Functions',
//   'Muscle Anatomy and Physiology',
//   'Angiology: Understanding Blood Vessels',
//   'Circulatory System Quiz',
//   'Neurology Fundamentals',
//   'Nervous System Anatomy',
//   'Aesthesiology: Sensory Organs and Perception',
//   'Senses and Sensory Reception',
//   'Introduction to Endocrinology',
//   'Hormones and Their Functions',
//   'Endocrine System Disorders',
//   'Interactions of Hormones',
//   'Diseases of the Nervous System',
//   'Disorders of the Endocrine System'
// ];
TextEditingController _codeContoller = TextEditingController();
int _maxLength = 8;

var coinsBox = Hive.box('coins');
int coins = coinsBox.get('coins');

class ListQuizesPage extends StatefulWidget {
  const ListQuizesPage({super.key});

  @override
  State<ListQuizesPage> createState() => _ListQuizesPageState();
}

// osteology
class _ListQuizesPageState extends State<ListQuizesPage> {
  @override
  void initState() {
    super.initState();
    context.read<GetListQuizesBloc>().add(GetQuizes());
    coins = coinsBox.get('coins');
  }

  double maxWidth(BuildContext ct) => MediaQuery.of(ct).size.width;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFCA9),
      extendBody: true,
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // leadingWidth: maxWidth(context) - 40,
        backgroundColor: Color(0xff6A3900),
        leading: Row(
          children: [
            SizedBox(width: 20),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ],
        ),
        centerTitle: true,
        title: Text(
          'Online open quizes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        actions: [
          actionButton(context),
          SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<GetListQuizesBloc, GetListQuizesState>(
          builder: (context, state) {
            return state is GetListQuizesLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: buttonColor,
                    ),
                  )
                : state is GetListQuizesSuccess
                    ? SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // SizedBox(height: 20),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  state.quizesList.length,
                                  (index) => quizTile(
                                      context, state.quizesList[index]),
                                ),
                              ),
                            ],
                          ),
                        ),
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

  GestureDetector quizTile(BuildContext context, Quiz quiz) {
    return GestureDetector(
      onTap: () {
        show_alert_dialog(context, quiz);
      },
      child: Container(
        width: maxWidth(context) - 32,
        padding: EdgeInsets.all(12),
        // margin: EdgeInsets.fromLTRB(60, 0, 60, 10),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            quiz.imageUrl != null
                ? network_image(quiz.imageUrl ?? '')
                : Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      // image: DecorationImage(
                      //   image: AssetImage('assets/images/osteology.png'),
                      //   fit: BoxFit.cover,
                      // ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.image_outlined,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
            SizedBox(width: 8),
            Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: maxWidth(context) - 165,
                      child: Text(
                        quiz.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    // SizedBox(height: 2),
                    SizedBox(
                      width: maxWidth(context) - 165,
                      child: Text(
                        'by ${quiz.author}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                // Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(width: 6),
                    Text(
                      '${quiz.questionsCount}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 2),
                    Iconify(
                      Ph.question,
                      color: Colors.black,
                      size: 20,
                    ),
                    // Icon(
                    //   Icons.quiz,
                    //   color: Colors.white,
                    //   size: 16,
                    // ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget network_image(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      // baseUrl + (url != '/assets/image/image-not-found.jpg' ? url : ''),
      imageBuilder: (context, imageProvider) => Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        width: 50,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const CircularProgressIndicator(
          color: buttonColor,
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: 50,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Iconify(
          MaterialSymbols.wifi_off_rounded,
          color: buttonColor,
          size: 30,
        ),
      ),
    );
  }

  InkWell actionButton(BuildContext context) {
    return InkWell(
      radius: 0,
      onTap: () {
        showModalBottomSheet(
          isScrollControlled: true,
          clipBehavior: Clip.antiAlias,
          context: context,
          barrierColor: Colors.black.withOpacity(0.5),
          backgroundColor: Colors.white,
          useSafeArea: true,
          builder: (context) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: double.infinity),
                      SizedBox(
                        width: maxWidth(context),
                        child: Text(
                          'Enter to game with code',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            height: 30 / 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _codeContoller,
                        keyboardType: TextInputType.text,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(_maxLength),
                        ],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          height: 24 / 20,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: 'XXXXXXXX',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            height: 24 / 20,
                            fontWeight: FontWeight.w400,
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Color(0xffD0D5DD)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Color(0xffD0D5DD)),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.length == _maxLength) {
                            FocusScope.of(context).requestFocus(FocusNode());
                          }
                        },
                      ),
                      SizedBox(height: 10),
                      BlocConsumer<GetQuizByCodeCubit, GetQuizByCodeState>(
                        listener: (context, state) {
                          if (state is GetQuizByCodeSuccess) {
                            Navigator.of(context).pop();
                            show_alert_dialog(
                              context,
                              // Quiz(
                              //   id: -1,
                              //   title: 'FROM PROMOCODE',
                              //   author: 'TEACHER',
                              //   questionsCount: 20,
                              //   imageUrl: null,
                              // ),
                              state.quiz,
                            );
                          }
                        },
                        builder: (context, state) {
                          return InkWell(
                            radius: 0,
                            onTap: () {
                              _codeContoller.text.length == _maxLength
                                  ? context.read<GetQuizByCodeCubit>().getQuiz(
                                      _codeContoller.text.toUpperCase())
                                  : null;
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: state is GetQuizByCodeFailure
                                    ? Colors.red
                                    : Color(0xff6A3900),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.black),
                              ),
                              child: state is GetQuizByCodeLoading
                                  ? Column(
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      state is GetQuizByCodeFailure
                                          ? 'ERROR'
                                          : 'Start game',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Icon(
        Icons.code_outlined,
        color: Colors.white,
      ),
    );
  }

  Future<Object?> show_alert_dialog(BuildContext context, Quiz quiz) {
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
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              quiz.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                height: 28 / 22,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'by ${quiz.author}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 18 / 14,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'It costs ${quiz.questionsCount * 10} MEDC. Do you want to start?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 20 / 16,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
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
                BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
                  listener: (context, state) {
                    if (state is UpdateProfileSuccess) {
                      // coinsBox.put('coins', coins - quiz.questionsCount * 10);
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return OnlineQuizPage(
                              quizId: quiz.id,
                              quizTitle: quiz.title,
                              isEducation: false,
                            );
                          },
                        ),
                      );
                      context.read<GetProfileBloc>().add(GetProfileEvent());
                    }
                  },
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: () {
                        coins > (quiz.questionsCount * 10)
                            ? context.read<UpdateProfileCubit>().updateProfile(
                                  ProfileModel(
                                    id: -1,
                                    urlAvatar: '',
                                    name: '',
                                    age: -1,
                                    medcoins: coins - quiz.questionsCount * 10,
                                    email: '',
                                    aboutMe: '',
                                  ),
                                  null,
                                )
                            : null;
                      },
                      child: coins > (quiz.questionsCount * 10)
                          ? Container(
                              width: (maxWidth(context) - 84) / 2,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: state is UpdateProfileFailure
                                    ? Colors.red
                                    : appBarColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: state is UpdateProfileLoading
                                  ? Column(
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      state is UpdateProfileFailure
                                          ? 'ERROR'
                                          : 'Start',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            )
                          : SizedBox(
                              width: (maxWidth(context) - 84) / 2,
                              height: 36,
                            ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
