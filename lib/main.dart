
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voice_note/generate_material_color.dart';
import 'package:voice_note/voice/domain/entities/login_data.dart';
import 'package:voice_note/voice/domain/use_cases/constant_data.dart';
import 'package:voice_note/voice/presentation/pages/home_page.dart';
import 'package:voice_note/voice/presentation/pages/login/password_page.dart';
import 'package:voice_note/voice/presentation/pages/login/sign_up.dart';


import 'injection.dart';
import 'voice/presentation/pages/login/login_page.dart';
import 'voice/presentation/pages/splash_screen.dart';


void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await init();
 await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Voice Note',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: generateMaterialColor(staticColor),
      ),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
          child: child!,
        );
      },
      home:SplashScreen(),
      getPages: [
        GetPage(
            name: homeScreen, page: () => HomePage(), transition: Transition.fadeIn),
        GetPage(
            name: loginScreen, page: () => LoginPage(), transition: Transition.fadeIn),
        GetPage(
            name: signUpScreen, page: () => SignUpPage(), transition: Transition.fadeIn),
      ],
    );
  }
}






