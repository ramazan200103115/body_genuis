// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:clients_app/data/constants/colors.dart';
import 'package:clients_app/screens/list_first_aid_page.dart';
import 'package:clients_app/screens/list_guizes_page.dart';
import 'package:clients_app/screens/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'blocs/get_profile_bloc/get_profile_bloc.dart';
import 'find_word_page.dart';
import 'list_learning_types.dart';
import 'login_page.dart';

List<String> _listPageNames = [
  'Quizes',
  'Education',
  // 'Enter to quiz with code',
  'Find word',
  'First Aid',
];
List<String> _listPageImages = [
  // 'online_quizes.png',
  'new_quizes.png',
  'educations.png',
  // 'Enter to quiz with code',
  // 'find_word.png',
  'new_find_word.png',
  'first_aid.png',
];
// List<Color> _listColors = [
//   Color(0xFFFF5722),
//   Color(0xFF673AB7),
//   Color(0xFFFF9800),
//   Color(0xFFF44336),
// ];
List<Widget> _listPages = [
  ListQuizesPage(),
  ListEducationTypesPage(),
  // ListQuizesPage(),
  FindWordPage(),
  ListFirstAidPage(),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<GetProfileBloc>().add(GetProfileEvent());
  }

  double maxWidth(BuildContext ct) => MediaQuery.of(ct).size.width;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBody: true,
        resizeToAvoidBottomInset: true,
        extendBodyBehindAppBar: true,
        // appBar: appBar(context),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              SizedBox(height: 10),
              BlocConsumer<GetProfileBloc, GetProfileState>(
                listener: (context, state) {
                  if (state is GetProfileSuccess) {
                    if (state.profileModel.id == -401) {
                      var tokenBox = Hive.box('tokens');
                      tokenBox.clear();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ));
                    }
                  }
                },
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 6,
                              // width: maxWidth(context),
                            ),
                            // Text(
                            //   'Your earned:',
                            //   style: TextStyle(
                            //     fontSize: 12,
                            //     color: Colors.black,
                            //   ),
                            // ),
                            state is GetProfileLoading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: buttonColor,
                                    ),
                                  )
                                : state is GetProfileSuccess
                                    ? Text(
                                        // '1700 MEDC',
                                        '${state.profileModel.medcoins} MEDC',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xff5EE764),
                                        ),
                                      )
                                    : Center(
                                        child: Text(
                                          'serverError',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                          ],
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProfilePage(),
                            ));
                          },
                          child: Icon(
                            Icons.person,
                            color: Color(0xff5EE764),
                            size: 36,
                          ),
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                  );
                },
              ),
              Spacer(),
              SizedBox(height: 10),
              Image.asset(
                'assets/images/profile_icon.png',
                fit: BoxFit.cover,
                width: 150,
                height: 150,
              ),
              SizedBox(height: 10),
              BlocConsumer<GetProfileBloc, GetProfileState>(
                listener: (context, state) {
                  if (state is GetProfileSuccess) {
                    if (state.profileModel.id == -401) {
                      var tokenBox = Hive.box('tokens');
                      tokenBox.clear();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ));
                    }
                  }
                },
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        state is GetProfileLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: buttonColor,
                                ),
                              )
                            : state is GetProfileSuccess
                                ? Text(
                                    // '1700 MEDC',
                                    'Hello, ${state.profileModel.name}!',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff5EE764),
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      'serverError',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
              Spacer(),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height - 338,
                decoration: BoxDecoration(
                    color: Color(0xff5EE764),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(45))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 14),
                    SizedBox(
                      width: maxWidth(context) - 30,
                      child: Text(
                        'Let’s study Anatomy!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          // color: Color(0xff333333),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 14),
                    SingleChildScrollView(
                      child: Wrap(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 30,
                        runSpacing: 20,
                        children: List.generate(
                          _listPageNames.length,
                          (index) => GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => _listPages[index],
                                // fullscreenDialog: true,
                              ));
                            },
                            child: Container(
                              width: (maxWidth(context) - 100) / 2,
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 26),
                              decoration: BoxDecoration(
                                color: Color(0xffFFFCA9),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  // Spacer(),
                                  // SizedBox(
                                  //   height: 100,
                                  //   // width: 12,
                                  // ),
                                  Image.asset(
                                    'assets/images/${_listPageImages[index]}',
                                    fit: BoxFit.contain,
                                    width: 96,
                                    height: 100,
                                  ),
                                  SizedBox(height: 0),
                                  Container(
                                    width: (maxWidth(context) - 160) / 2,
                                    // padding: EdgeInsets.symmetric(vertical: 12),
                                    // margin: EdgeInsets.only(bottom: 10, left: 60),
                                    decoration: BoxDecoration(
                                        // color: index % 2 == 0
                                        //     ? Colors.white
                                        //     : Color(0xff333333),
                                        // borderRadius: BorderRadius.circular(12),
                                        ),
                                    child: Text(
                                      _listPageNames[index],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff333333),
                                        // color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  // Spacer(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      leadingWidth: maxWidth(context) - 100,
      backgroundColor: appBarYellow,
      automaticallyImplyLeading: false,
      elevation: 2,
      shadowColor: Colors.black,
      leading: BlocConsumer<GetProfileBloc, GetProfileState>(
        listener: (context, state) {
          if (state is GetProfileSuccess) {
            if (state.profileModel.id == -401) {
              var tokenBox = Hive.box('tokens');
              tokenBox.clear();
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => LoginPage(),
              ));
            }
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 6),
                Text(
                  'Your earned:',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 0),
                state is GetProfileLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: buttonColor,
                        ),
                      )
                    : state is GetProfileSuccess
                        ? Text(
                            // '1700 MEDC',
                            '${state.profileModel.medcoins} MEDC',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          )
                        : Center(
                            child: Text(
                              'serverError',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
              ],
            ),
          );
        },
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProfilePage(),
            ));
          },
          child: Icon(
            Icons.person,
            color: Colors.black,
            size: 36,
          ),
        ),
        SizedBox(width: 14),
      ],
    );
  }
}
