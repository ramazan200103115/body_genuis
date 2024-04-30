// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clients_app/data/constants/colors.dart';
import 'package:clients_app/screens/blocs/get_profile_bloc/get_profile_bloc.dart';
import 'package:clients_app/screens/login_page.dart';
import 'package:clients_app/screens/profile_editing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/api/config.dart';
import '../data/constants/sized_boxes.dart';

TextEditingController _emailContrl = TextEditingController();
TextEditingController _nameContrl = TextEditingController();
TextEditingController _ageContrl = TextEditingController();
TextEditingController _aboutContrl = TextEditingController();

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<GetProfileBloc>().add(GetProfileEvent());
  }

  double maxWidth(BuildContext ct) => MediaQuery.of(ct).size.width;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffDCEFDB),
      // backgroundColor: Color(0xff5EE764),
      extendBody: true,
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color(0xff5EE764),
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
          'Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<GetProfileBloc, GetProfileState>(
          listener: (context, state) {
            if (state is GetProfileSuccess) {
              if (state.profileModel.id == -401) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) => const LoginPage()),
                    (d) => false,
                  );
                });
              }
              _emailContrl =
                  TextEditingController(text: state.profileModel.email);
              _ageContrl = TextEditingController(
                  text: state.profileModel.age.toString());
              _nameContrl =
                  TextEditingController(text: state.profileModel.name);
              _aboutContrl =
                  TextEditingController(text: state.profileModel.aboutMe);
            }
          },
          builder: (context, state) {
            return state is GetProfileLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: buttonColor,
                      strokeWidth: 1,
                    ),
                  )
                : state is GetProfileSuccess
                    ? SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            sb_h20(),
                            network_image(state.profileModel.urlAvatar),
                            sb_h20(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 26),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  input_title('Name'),
                                  sb_h4(),
                                  info_input_tiles(
                                      _nameContrl,
                                      'First name and last name',
                                      TextInputType.name),
                                  sb_h8(),
                                  input_title('Age'),
                                  sb_h4(),
                                  info_input_tiles(
                                      _ageContrl, 'Age', TextInputType.number),
                                  sb_h4(),
                                  input_title('Email'),
                                  sb_h4(),
                                  info_input_tiles(
                                      _emailContrl,
                                      'example@gmail.com',
                                      TextInputType.emailAddress),
                                  sb_h8(),
                                  input_title('About me'),
                                  sb_h4(),
                                  info_input_tiles(
                                      _aboutContrl,
                                      'I am a designer from Almaty...',
                                      TextInputType.text),
                                  sb_h8(),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ProfileEditingPage(
                                      profileModel: state.profileModel,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(horizontal: 50),
                                padding: EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: correctColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Edit',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            sb_h8(),
                            GestureDetector(
                              onTap: () {
                                var tokenBox = Hive.box('tokens');
                                tokenBox.clear();
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ));
                              },
                              child: Container(
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(horizontal: 50),
                                padding: EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: wrongColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Logout',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            sb_h40(),
                          ],
                        ),
                      )
                    : Center(
                        child: Column(
                          children: [
                            Text(
                              'serverError',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.red,
                              ),
                            ),
                            sb_h8(),
                            GestureDetector(
                              onTap: () {
                                var tokenBox = Hive.box('tokens');
                                tokenBox.clear();
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ));
                              },
                              child: Container(
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(horizontal: 50),
                                padding: EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: wrongColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Logout',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            sb_h40(),
                          ],
                        ),
                      );
          },
        ),
      ),
    );
  }

  Text input_title(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        color: Colors.black,
      ),
    );
  }

  TextField info_input_tiles(TextEditingController controller, String hint,
      TextInputType? keyboardType) {
    return TextField(
      enabled: false,
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(
        color: Colors.black,
        fontSize: 16,
        height: keyboardType == TextInputType.text ? (24 / 16) : 1,
        fontWeight: FontWeight.w400,
      ),
      maxLines: keyboardType == TextInputType.text ? null : 1,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16,
          height: keyboardType == TextInputType.text ? (24 / 16) : 1,
          fontWeight: FontWeight.w400,
        ),
        contentPadding: EdgeInsets.symmetric(
            vertical: keyboardType == TextInputType.text ? 8 : 0,
            horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Color(0xffD0D5DD)),
        ),
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
        // check();
      },
    );
  }

  Widget network_image(String url) {
    return CachedNetworkImage(
      imageUrl: baseUrl + url,
      // baseUrl + (url != '/assets/image/image-not-found.jpg' ? url : ''),
      imageBuilder: (context, imageProvider) => InkWell(
        splashColor: Colors.white,
        highlightColor: Colors.white,
        onTap: () {
          show_image(context, imageProvider);
        },
        child: Container(
          width: 150,
          height: 150,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        width: 150,
        height: 150,
        padding: EdgeInsets.all(15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: const CircularProgressIndicator(
          color: buttonColor,
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: 150,
        height: 150,
        // padding: EdgeInsets.all(15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          // border: Border.all(
          //   color: Color(0xff5EE764),
          //   width: 10,
          //   strokeAlign: BorderSide.strokeAlignInside,
          // ),
        ),
        child: Image.asset(
          'assets/images/profile_icon.png',
          fit: BoxFit.cover,
          width: 150,
          height: 150,
        ),
        // child: Iconify(
        //   Mdi.account_circle_outline,
        //   color: Colors.black,
        //   size: 120,
        // ),
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
}
