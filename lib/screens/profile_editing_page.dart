// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clients_app/data/constants/colors.dart';
import 'package:clients_app/data/models/profile_model.dart';
import 'package:clients_app/screens/blocs/get_profile_bloc/get_profile_bloc.dart';
import 'package:clients_app/screens/blocs/update_profile_cubit/update_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../data/api/config.dart';
import '../data/constants/sized_boxes.dart';

TextEditingController _emailContrl = TextEditingController();
TextEditingController _nameContrl = TextEditingController();
TextEditingController _ageContrl = TextEditingController();
TextEditingController _aboutContrl = TextEditingController();
bool _canGo = false;
final ImagePicker imagePicker = ImagePicker();
XFile? _image;

class ProfileEditingPage extends StatefulWidget {
  final ProfileModel profileModel;
  const ProfileEditingPage({
    super.key,
    required this.profileModel,
  });

  @override
  State<ProfileEditingPage> createState() => _ProfileEditingPageState();
}

class _ProfileEditingPageState extends State<ProfileEditingPage> {
  @override
  void initState() {
    super.initState();
    _canGo = false;
    _emailContrl = TextEditingController(text: widget.profileModel.email);
    _ageContrl =
        TextEditingController(text: widget.profileModel.age.toString());
    _nameContrl = TextEditingController(text: widget.profileModel.name);
    _aboutContrl = TextEditingController(text: widget.profileModel.aboutMe);
  }

  void selectImage() async {
    final XFile? selectedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        _image = selectedImage;
      });
      checkGo();
    }
  }

  void checkGo() {
    setState(() {
      _canGo = _nameContrl.text.isNotEmpty &&
          _emailContrl.text.isNotEmpty &&
          _ageContrl.text.isNotEmpty &&
          _aboutContrl.text.isNotEmpty;
    });
  }

  double maxWidth(BuildContext context) => MediaQuery.of(context).size.width;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        didPop ? context.read<GetProfileBloc>().add(GetProfileEvent()) : null;
      },
      child: Scaffold(
        backgroundColor: Color(0xffDCEFDB),
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
            'Editing profile',
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
              children: [
                sb_h20(),
                InkWell(
                  overlayColor: MaterialStatePropertyAll(backgroundColor),
                  onTap: () {
                    selectImage();
                  },
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      _image != null
                          ? Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: FileImage(File(_image!.path)),
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.high,
                                ),
                              ),
                            )
                          : network_image(widget.profileModel.urlAvatar),
                      Container(
                        margin: EdgeInsets.only(right: 6, bottom: 6),
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                sb_h20(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      input_title('Name'),
                      sb_h4(),
                      info_input_tiles(_nameContrl, 'First name and last name',
                          TextInputType.name),
                      sb_h8(),
                      input_title('Age'),
                      sb_h4(),
                      info_input_tiles(_ageContrl, 'Age', TextInputType.number),
                      sb_h4(),
                      input_title('Email'),
                      sb_h4(),
                      info_input_tiles(_emailContrl, 'example@gmail.com',
                          TextInputType.emailAddress),
                      sb_h8(),
                      input_title('About me'),
                      sb_h4(),
                      info_input_tiles(_aboutContrl,
                          'I am a designer from Almaty...', TextInputType.text),
                      sb_h24(),
                      sb_h4(),
                    ],
                  ),
                ),
                BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
                  listener: (context, state) {
                    if (state is UpdateProfileSuccess) {
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        Navigator.of(context).pop();
                      });
                    }
                  },
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: () {
                        // _canGo ? Navigator.of(context).pop() : null;
                        _canGo
                            ? context.read<UpdateProfileCubit>().updateProfile(
                                  ProfileModel(
                                    id: widget.profileModel.id,
                                    urlAvatar: '',
                                    name: _nameContrl.text,
                                    age: int.parse(_ageContrl.text),
                                    email: _emailContrl.text,
                                    aboutMe: _aboutContrl.text,
                                    medcoins: -1,
                                  ),
                                  _image != null ? File(_image!.path) : null,
                                )
                            : null;
                        // File(_image!.path);
                      },
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 50),
                        padding: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: correctColor.withOpacity(_canGo ? 1 : 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: state is UpdateProfileLoading
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: 23,
                                    width: 23,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                state is UpdateProfileFailure
                                    ? 'Server Error! Try again!'
                                    : 'Save',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    );
                  },
                ),
                sb_h40(),
              ],
            ),
          ),
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
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: keyboardType == TextInputType.number
          ? [
              LengthLimitingTextInputFormatter(2),
              FilteringTextInputFormatter.digitsOnly,
            ]
          : [],
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
        checkGo();
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
