// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:clients_app/data/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/get_first_aids_cubit/get_first_aids_cubit.dart';
import 'first_aid_tile_page.dart';

// List<String> _listTypes = [
//   'Dislocation',
//   'Bleeding',
//   'Fainting',
//   'Fracture',
//   'Wounds',
//   'Carbon monoxide poisoning',
//   'Injury',
//   'Electrical injury',
// ];

class ListFirstAidPage extends StatefulWidget {
  const ListFirstAidPage({super.key});

  @override
  State<ListFirstAidPage> createState() => _ListFirstAidPageState();
}

class _ListFirstAidPageState extends State<ListFirstAidPage> {
  @override
  void initState() {
    super.initState();
    context.read<GetFirstAidsCubit>().getFirstAids();
  }

  double maxWidth(BuildContext ct) => MediaQuery.of(ct).size.width;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFB9B9),
      extendBody: true,
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // leadingWidth: maxWidth(context) - 100,
        backgroundColor: Color(0xffC60000),
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
              'First Aid',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Image.asset(
              'assets/images/first_aid.png',
              width: 40,
              height: 40,
            ),
          ],
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<GetFirstAidsCubit, GetFirstAidsState>(
          builder: (context, state) {
            return state is GetFirstAidsLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: buttonColor,
                    ),
                  )
                : state is GetFirstAidsSuccess
                    ? SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: maxWidth(context),
                                height: 20,
                              ),
                              // Text(
                              //   'What happened?',
                              //   textAlign: TextAlign.center,
                              //   style: TextStyle(
                              //     fontSize: 20,
                              //     fontWeight: FontWeight.w700,
                              //     color: Colors.white,
                              //   ),
                              // ),
                              // SizedBox(height: 20),
                              Container(
                                width: maxWidth(context) - 40,
                                decoration: BoxDecoration(
                                  color: Color(0xffFF4C4C),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(
                                    state.firstAids.length,
                                    (index) => GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return FirstAidTilePage(
                                                firstAid:
                                                    state.firstAids[index],
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
                                        margin:
                                            EdgeInsets.symmetric(vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              'assets/images/f${index + 1}.png',
                                              width: 40,
                                              height: 40,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              state.firstAids[index].title,
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
}
