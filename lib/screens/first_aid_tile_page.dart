// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:clients_app/data/models/first_aid_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/constants/sized_boxes.dart';

class FirstAidTilePage extends StatefulWidget {
  final FirstAid firstAid;

  const FirstAidTilePage({
    super.key,
    required this.firstAid,
  });

  @override
  State<FirstAidTilePage> createState() => _FirstAidTilePageState();
}

class _FirstAidTilePageState extends State<FirstAidTilePage> {
  double maxWidth(BuildContext ct) => MediaQuery.of(ct).size.width;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFB9B9),
      extendBody: true,
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
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
        title: Text(
          widget.firstAid.title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      widget.firstAid.title,
                      style: TextStyle(
                        fontSize: 20,
                        height: 1.2,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    sb_h12(),
                    Text(
                      widget.firstAid.info,
                      style: TextStyle(
                        fontSize: 14,
                        height: 18 / 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'FIRST AID',
                      style: TextStyle(
                        fontSize: 20,
                        height: 1.2,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    sb_h12(),
                    Text(
                      widget.firstAid.firstAid,
                      style: TextStyle(
                        fontSize: 14,
                        height: 18 / 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              sb_h20(),
              widget.firstAid.videoUrl != null
                  ? GestureDetector(
                      onTap: () async {
                        if (widget.firstAid.videoUrl != null) {
                          final Uri url = Uri.parse(widget.firstAid.videoUrl!);
                          if (!await launchUrl(url,
                              mode: LaunchMode.externalApplication)) {
                            throw Exception('Could not launch $url');
                          }
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color(0xffFF4C4C),
                        ),
                        child: Text(
                          'Watch the video!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              sb_h40(),
            ],
          ),
        ),
      ),
    );
  }
}
