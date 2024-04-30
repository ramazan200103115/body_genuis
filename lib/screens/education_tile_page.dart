// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:clients_app/data/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/get_education_tile_bloc/get_education_tile_bloc.dart';
import 'education_diagram_page.dart';
import 'education_diseases_page.dart';
import 'education_info_page.dart';
import 'online_quiz_page.dart';

class EducationTilePage extends StatefulWidget {
  final int educationId;
  final String educationTitle;

  const EducationTilePage({
    super.key,
    required this.educationId,
    required this.educationTitle,
  });

  @override
  State<EducationTilePage> createState() => _EducationTilePageState();
}

class _EducationTilePageState extends State<EducationTilePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context
        .read<GetEducationTileBloc>()
        .add(GetEducationTile(educationId: widget.educationId));
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
          widget.educationTitle,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<GetEducationTileBloc, GetEducationTileState>(
          builder: (context, state) {
            return state is GetEducationTileLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: buttonColor,
                    ),
                  )
                : state is GetEducationTileSuccess
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // SizedBox(
                          //   width: maxWidth(context),
                          //   height: 50,
                          // ),
                          Spacer(),
                          widget.educationId == -1
                              ? InkWell(
                                  radius: 0,
                                  splashColor: backgroundColor,
                                  overlayColor:
                                      MaterialStatePropertyAll(backgroundColor),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return EducationDiagramPage();
                                        },
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 81.5,
                                    backgroundColor: buttonColor,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'What is it?',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Image.asset(
                                          'assets/images/diagram.png',
                                          width: 70,
                                          height: 70,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          Row(
                            mainAxisAlignment: state.education.diseases != ''
                                ? MainAxisAlignment.spaceEvenly
                                : MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              InkWell(
                                radius: 0,
                                splashColor: backgroundColor,
                                overlayColor:
                                    MaterialStatePropertyAll(backgroundColor),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return EducationInfoPage(
                                          education: state.education,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                  radius: 81.5,
                                  backgroundColor: buttonColor,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Information',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Image.asset(
                                        'assets/images/knowledge.png',
                                        width: 70,
                                        height: 70,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              state.education.diseases != ''
                                  ? InkWell(
                                      radius: 0,
                                      splashColor: backgroundColor,
                                      overlayColor: MaterialStatePropertyAll(
                                          backgroundColor),
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return EducationDiseasesPage(
                                                education: state.education,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: CircleAvatar(
                                        radius: 81.5,
                                        backgroundColor: buttonColor,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Diseases',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Image.asset(
                                              'assets/images/disease.png',
                                              width: 70,
                                              height: 70,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                          SizedBox(
                            height: state.education.diseases != '' ? 0 : 20,
                          ),
                          InkWell(
                            radius: 0,
                            splashColor: backgroundColor,
                            overlayColor:
                                MaterialStatePropertyAll(backgroundColor),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return OnlineQuizPage(
                                      quizId: state.education.id,
                                      quizTitle: state.education.title,
                                      isEducation: true,
                                    );
                                  },
                                ),
                              );
                            },
                            child: CircleAvatar(
                              radius: 81.5,
                              backgroundColor: buttonColor,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Test',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Image.asset(
                                    'assets/images/quiz_test.png',
                                    width: 70,
                                    height: 70,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Spacer(),
                          Spacer(),
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
}
