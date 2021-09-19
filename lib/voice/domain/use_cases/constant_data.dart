

import 'package:flutter/material.dart';

const staticColor = Colors.blueAccent;

enum TypeAudio{
  link,audio
}

enum LoginType{
  social,normal
}

const notExist = "this email not register ";

const homeScreen = '/home';
const loginScreen = '/login';
const signUpScreen = '/signUp';

void unFocus(BuildContext context) {
  FocusScope.of(context).unfocus();
}


Widget errorContainer(BuildContext context,Function onTap) {
  return Container(
    alignment: Alignment.center,
    child: IconButton(onPressed: (){
      onTap.call();
    }, icon: Icon(Icons.refresh,color: staticColor,)),
  );
}





