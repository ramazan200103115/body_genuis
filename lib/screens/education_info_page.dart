// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clients_app/data/constants/colors.dart';
import 'package:clients_app/data/constants/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';

import '../data/models/education_model.dart';

class EducationInfoPage extends StatefulWidget {
  final Education education;

  const EducationInfoPage({
    super.key,
    required this.education,
  });

  @override
  State<EducationInfoPage> createState() => _EducationInfoPageState();
}

class _EducationInfoPageState extends State<EducationInfoPage> {
  @override
  void initState() {
    super.initState();
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
          'Information',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
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
                    widget.education.title,
                    style: TextStyle(
                      fontSize: 20,
                      height: 1.2,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  sb_h12(),
                  Text(
                    widget.education.info,
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
            widget.education.infoImages.isNotEmpty
                ? Container(
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
                          'Images',
                          style: TextStyle(
                            fontSize: 20,
                            height: 1.2,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        sb_h12(),
                        Wrap(
                          spacing: 12,
                          runSpacing: 10,
                          children: List.generate(
                            widget.education.infoImages.length,
                            (index) => widget.education.id != -1
                                ? network_image(
                                    widget.education.infoImages[index])
                                : InkWell(
                                    splashColor: Colors.white,
                                    highlightColor: Colors.white,
                                    onTap: () {
                                      show_image(
                                          context,
                                          AssetImage(widget
                                              .education.infoImages[index]));
                                    },
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: backgroundColor,
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: AssetImage(widget
                                              .education.infoImages[index]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
            sb_h20(),
          ],
        ),
      )),
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
    return CachedNetworkImage(
      imageUrl: url,
      // baseUrl + (url != '/assets/image/image-not-found.jpg' ? url : ''),
      imageBuilder: (context, imageProvider) => InkWell(
        splashColor: Colors.white,
        highlightColor: Colors.white,
        onTap: () {
          show_image(context, imageProvider);
        },
        child: Container(
          width: 100,
          height: 100,
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
        width: 100,
        height: 100,
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
        width: 100,
        height: 100,
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
}
