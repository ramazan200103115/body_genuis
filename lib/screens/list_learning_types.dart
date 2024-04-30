// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:clients_app/data/constants/colors.dart';
import 'package:clients_app/screens/blocs/get_educations_bloc/get_educations_bloc.dart';
import 'package:clients_app/screens/education_tile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// List<String> _listPages = [
//   'Cytology',
//   'Osteology',
//   'Syndesmology',
//   'Myology',
//   'Angiology',
//   'Neurology',
//   'Aesthesiology',
//   'Endocrinology',
// ];
// List<Color> _listColors = [
//   Color(0xFF007BFF),
//   Color(0xFF28A745),
//   Color(0xFFDC3545),
//   Color(0xFFFF69B4),
//   Color(0xFFFFA500),
//   Color(0xFF6F42C1),
//   Color(0xFF17A2B8),
//   Color(0xFF7DBF2E),
//   // Color(0xFFFF7F50),
//   // Color(0xFFE6E6FA),
//   // Color(0xFFFFFFFF),
//   // Color(0xFF448AFF),
// ];
List<String> _images = [
  'e2.png',
  'e3.png',
  'e4.png',
  'e5.png',
  'e6.png',
  'e7.png',
  'e8.png',
  'e1.png',
];

class ListEducationTypesPage extends StatefulWidget {
  const ListEducationTypesPage({super.key});

  @override
  State<ListEducationTypesPage> createState() => _ListEducationTypesPageState();
}

class _ListEducationTypesPageState extends State<ListEducationTypesPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<GetEducationsBloc>().add(GetEducationsEvent());
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
        // leadingWidth: maxWidth(context) - 100,
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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Education',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 6),
            Image.asset(
              'assets/images/educations.png',
              width: 40,
              height: 40,
            ),
          ],
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<GetEducationsBloc, GetEducationsState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                      width: maxWidth(context) - 30,
                      decoration: BoxDecoration(
                        color: Color(0xffBE834C),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Text(
                          //   'Which section would you like to study?',
                          //   textAlign: TextAlign.center,
                          //   style: TextStyle(
                          //     fontSize: 20,
                          //     fontWeight: FontWeight.w700,
                          //     color: Colors.white,
                          //   ),
                          // ),
                          // SizedBox(height: 40),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return EducationTilePage(
                                      educationId: -1,
                                      educationTitle: 'Basic',
                                    );
                                  },
                                ),
                              );
                            },
                            child: Container(
                              width: maxWidth(context) - 70,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 8),
                              // margin: EdgeInsets.fromLTRB(60, 0, 60, 10),
                              margin: EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/${_images[7]}',
                                    width: 40,
                                    height: 40,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Basic',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          state is GetEducationsLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: buttonColor,
                                  ),
                                )
                              : state is GetEducationsSuccess
                                  ? Column(
                                      mainAxisSize: MainAxisSize.min,
                                      // mainAxisAlignment: MainAxisAlignment.center,
                                      children: List.generate(
                                        state.educations.length,
                                        (index) => GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return EducationTilePage(
                                                    educationId: state
                                                        .educations[index].id,
                                                    educationTitle: state
                                                        .educations[index]
                                                        .title,
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 8),
                                            margin: EdgeInsets.symmetric(
                                                vertical: 6),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  'assets/images/${_images[index]}',
                                                  width: 40,
                                                  height: 40,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  state.educations[index].title,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Spacer(),
                                                Icon(
                                                  Icons.arrow_forward,
                                                  color: Colors.black,
                                                ),
                                              ],
                                            ),
                                          ),
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
                                    ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
