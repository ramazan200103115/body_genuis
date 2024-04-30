// ignore_for_file: prefer_const_constructors

import 'package:clients_app/data/models/profile_model.dart';
import 'package:clients_app/screens/blocs/login_cubit/login_cubit.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/constants/colors.dart';
import 'home_page.dart';
import 'package:flutter/material.dart';

TextEditingController _emailContrl = TextEditingController();
TextEditingController _passContrl = TextEditingController();
TextEditingController _nameContrl = TextEditingController();
TextEditingController _ageContrl = TextEditingController();
bool _canEnter = false;
bool _isLogin = true;
bool _visiblePass = false;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _canEnter = false;
    _isLogin = true;
    _visiblePass = false;
    _emailContrl = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var maxWidth = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBody: true,
        resizeToAvoidBottomInset: true,
        extendBodyBehindAppBar: true,
        body: SafeArea(
          // top: false,
          child: SingleChildScrollView(
            child: AnimatedSize(
              duration: Duration(milliseconds: 400),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: _isLogin ? login_body(maxWidth) : signup_body(maxWidth),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget signup_body(double maxWidth) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 180,
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          input_title('Name'),
          SizedBox(height: 12),
          info_input_tiles(_nameContrl, 'Name', TextInputType.name),
          SizedBox(height: 12),
          input_title('Age'),
          SizedBox(height: 12),
          info_input_tiles(_ageContrl, 'Age', TextInputType.number),
          SizedBox(height: 12),
          input_title('Email'),
          SizedBox(height: 12),
          info_input_tiles(_emailContrl, 'Email', TextInputType.emailAddress),
          SizedBox(height: 12),
          input_title('Password'),
          SizedBox(height: 12),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              info_input_tiles(
                  _passContrl, 'Password', TextInputType.visiblePassword),
              Positioned(
                right: 12,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _visiblePass = !_visiblePass;
                    });
                  },
                  child: Icon(
                    _visiblePass ? Icons.visibility_off : Icons.visibility,
                    size: 24,
                    color: buttonColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          button(maxWidth, 'Register'),
          SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              setState(() {
                _isLogin = true;
              });
              check();
            },
            child: SizedBox(
              width: maxWidth - 40,
              child: Text(
                'Do you have an account, Login',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget button(double maxWidth, String buttonName) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          // if (state is LoginFailure) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                  builder: (BuildContext context) => const HomePage()),
            );
          });
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            if (_canEnter) {
              if (_isLogin) {
                context
                    .read<LoginCubit>()
                    .login(_emailContrl.text, _passContrl.text);
              } else {
                context.read<LoginCubit>().register(
                    ProfileModel(
                      id: 1,
                      urlAvatar: '',
                      name: _nameContrl.text,
                      age: int.parse(_ageContrl.text),
                      email: _emailContrl.text,
                      aboutMe: '',
                      medcoins: 1,
                    ),
                    _passContrl.text);
              }
            }
          },
          child: Container(
            width: maxWidth - 40,
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: buttonColor.withOpacity(_canEnter ? 1 : 0.5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: state is LoginLoading
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
                    state is LoginFailure
                        ? 'Server Error! Try again!'
                        : buttonName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget login_body(double maxWidth) {
    return Column(
      // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            SizedBox(width: maxWidth - 40),
            Image.asset(
              'assets/images/med_icon.jpeg',
              width: maxWidth - 100,
              height: maxWidth - 100,
              fit: BoxFit.contain,
              // color: Colors.white,
            ),
          ],
        ),
        SizedBox(height: 20),
        input_title('Email'),
        SizedBox(height: 12),
        info_input_tiles(_emailContrl, 'Email', TextInputType.emailAddress),
        SizedBox(height: 12),
        input_title('Password'),
        SizedBox(height: 12),
        Stack(
          alignment: Alignment.centerRight,
          children: [
            info_input_tiles(
                _passContrl, 'Password', TextInputType.visiblePassword),
            Positioned(
              right: 12,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _visiblePass = !_visiblePass;
                  });
                },
                child: Icon(
                  _visiblePass ? Icons.visibility_off : Icons.visibility,
                  size: 24,
                  color: buttonColor,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        button(maxWidth, 'Login'),
        SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            setState(() {
              _isLogin = false;
            });
            check();
          },
          child: SizedBox(
            width: maxWidth - 40,
            child: Text(
              'If you don\'t have an account, Sign up',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void check() {
    setState(() {
      _canEnter = _isLogin
          ? _emailContrl.text.isNotEmpty && _passContrl.text.length > 8
          : _emailContrl.text.isNotEmpty &&
              _passContrl.text.length > 8 &&
              _ageContrl.text.isNotEmpty &&
              _nameContrl.text.isNotEmpty;
    });
  }

  Text input_title(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w500,
        color: Color(0xff344054),
      ),
    );
  }

  TextField info_input_tiles(TextEditingController controller, String hint,
      TextInputType? keyboardType) {
    return TextField(
      obscureText:
          keyboardType == TextInputType.visiblePassword ? _visiblePass : false,
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
        height: 24 / 16,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16,
          height: 24 / 16,
          fontWeight: FontWeight.w400,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
        check();
      },
    );
  }
}
