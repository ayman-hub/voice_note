import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:voice_note/voice/domain/entities/login_data.dart';
import 'package:voice_note/voice/domain/use_cases/case.dart';
import 'package:voice_note/voice/domain/use_cases/constant_data.dart';

import '../../../injection.dart';
import 'login/login_page.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  bool goLogin = true;
  late AnimationController _controller ;

  @override
  void initState() {
    LoginData login = sl<Cases>().getLoginData();
    if(login.email.isNotEmpty){
      goLogin = false;
    }
    _controller = AnimationController(vsync: this);

    _controller.addListener(() {

      if(_controller.isCompleted){
        Get.off(()=>goLogin? LoginPage():HomePage(),transition: Transition.fadeIn);
      }
    });
  }


  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: staticColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.4, 1, 0.01],
                colors: [Colors.blue[700]!, Colors.blue[400]!, Colors.white])),
        alignment: Alignment.center,
        child: Lottie.asset("images/voice_splash.json",controller: _controller,
            onLoaded: (LottieComposition composition){
              _controller
                ..duration = composition.duration
                ..forward();
            }
        ),
      ),
    );
  }
}