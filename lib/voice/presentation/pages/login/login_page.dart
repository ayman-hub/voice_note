import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:voice_note/voice/domain/use_cases/authinticate.dart';
import 'package:voice_note/injection.dart';
import 'package:voice_note/voice/domain/use_cases/constant_data.dart';
import 'package:voice_note/voice/domain/entities/login_data.dart';
import 'package:voice_note/voice/domain/use_cases/case.dart';
import 'package:voice_note/voice/presentation/pages/login/password_page.dart';
import 'package:voice_note/voice/presentation/pages/login/sign_up.dart';
import 'package:voice_note/voice/presentation/pages/home_page.dart';
import 'package:voice_note/voice/presentation/widgets/const_widget.dart';
import 'package:voice_note/voice/presentation/widgets/loading_widget.dart';
import 'package:voice_note/toast_utils.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller1;
  late Animation animation1;

  late Animation shade;

  late Animation animation2;
  late Size getSize;

LoginData loginData = LoginData(email: "");

  final formKey = GlobalKey<FormState>();

  bool showProgress = false;

  @override
  void initState() {
    super.initState();
    controller1 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation1 = Tween<Offset>(begin: Offset(1.5, 0.0), end: Offset.zero)
        .animate(CurvedAnimation(parent: controller1, curve: Curves.easeIn));
    animation2 = Tween<Offset>(begin: Offset(-1.5, 0.0), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: controller1, curve: Curves.fastOutSlowIn));
    shade = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller1, curve: Curves.fastOutSlowIn));
    controller1.forward();
  }

  @override
  void dispose() {
    super.dispose();
    controller1.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        Scaffold(
          body: Form(
            key: formKey,
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: [
                    0.4,
                    1,
                    0.01
                  ],
                      colors: [
                    Colors.blue[700]!,
                    Colors.blue[400]!,
                    Colors.white
                  ])),
              alignment: Alignment.center,
              child: AnimatedBuilder(
                  animation: controller1,
                  builder: (animation, child) {
                    return SingleChildScrollView(
                      child: Container(
                        height: getSize.height,
                        child: Column(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FadeTransition(
                                    opacity: shade as Animation<double>,
                                    child: Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(right: 10),
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SlideTransition(
                                    position: animation1 as Animation<Offset>,
                                    child: Container(
                                      margin: EdgeInsets.all(10),
                                      child: TextFormField(
                                        maxLines: 1,
                                        onChanged: (value) {
                                          loginData.email = value;
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'need to write email';
                                          } else if (!GetUtils.isEmail(value)) {
                                            return 'need to write correct email';
                                          }
                                          return null;
                                        },
                                        style: TextStyle(
                                            fontSize: 15.0, color: Colors.white),
                                        decoration: getLoginDecoration(
                                            'ayman.atef@yahoo.com', Icons.email),
                                      ),
                                    ),
                                  ),
                                  SlideTransition(
                                    position: animation2 as Animation<Offset>,
                                    child: Container(
                                      margin: EdgeInsets.all(10),
                                      child: TextFormField(
                                        maxLines: 1,
                                        obscureText: true,
                                        onChanged: (value) {
                                          loginData.password = value;
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'need to write password';
                                          }
                                          return null;
                                        },
                                        style: TextStyle(
                                            fontSize: 15.0, color: Colors.white),
                                        decoration: getLoginDecoration(
                                            '******', Icons.lock),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    child: Hero(
                                      tag: "log",
                                      child: TextButton(
                                        onPressed: loginMethod,
                                        child: Container(
                                          height: 45,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 2.0,
                                                spreadRadius: 0.0,
                                                offset: Offset(2.0,
                                                    2.0), // shadow direction: bottom right
                                              )
                                            ],
                                          ),
                                          child: Text(
                                            'Login',
                                            style: TextStyle(
                                                color: staticColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Hero(
                                      tag: "OR",
                                      child: Text(
                                        'OR',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Hero(
                                    tag: "Row",
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.all(10),
                                          child: TextButton(
                                            onPressed: facebookMethod,
                                            child: Container(
                                              height: 50,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey,
                                                    blurRadius: 2.0,
                                                    spreadRadius: 0.0,
                                                    offset: Offset(2.0,
                                                        2.0), // shadow direction: bottom right
                                                  )
                                                ],
                                              ),
                                              child: Icon(
                                                Icons.facebook,
                                                color: staticColor,
                                                size: 50,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(10),
                                          child: TextButton(
                                            onPressed: googleMethod,
                                            child: Container(
                                              height: 45,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey,
                                                    blurRadius: 2.0,
                                                    spreadRadius: 0.0,
                                                    offset: Offset(2.0,
                                                        2.0), // shadow direction: bottom right
                                                  )
                                                ],
                                              ),
                                              child: Container(
                                                  padding: EdgeInsets.all(8),
                                                  child: Image.asset(
                                                      "images/google.png")),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(10),
                                          child: TextButton(
                                            onPressed: twitterMethod,
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey,
                                                    blurRadius: 2.0,
                                                    spreadRadius: 0.0,
                                                    offset: Offset(2.0,
                                                        2.0), // shadow direction: bottom right
                                                  )
                                                ],
                                              ),
                                              child: Icon(
                                                FontAwesomeIcons.twitter,
                                                color: staticColor,
                                                size: 35,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              alignment: Alignment.center,
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: "Don't have account   ",
                                    style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 17),
                                  ),
                                  TextSpan(
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Get.toNamed(signUpScreen);
                                        },
                                      text: "Sign Up",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17))
                                ]),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ),
        showProgress
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: loadingContainer())
            : Container()
      ],
    );
  }

  void loginMethod() async {
    unFocus(context);
    if (formKey.currentState!.validate()) {
      setState(() {
        showProgress = true;
      });
      var response = await sl<Cases>().getLoginFB(loginData);
      setState(() {
        showProgress = false;
      });
      if (response is String) {
        showToast(response);
      } else if (response is LoginData) {
        if (response.password == loginData.password) {
          sl<Cases>().setLoginData(response);
           Get.offNamed(homeScreen);
        } else {
          showToast("wrong password");
        }
      }
    }
  }

  void twitterMethod() async {
    unFocus(context);
    setState(() {
      showProgress = true;
    });
    var data = await signInWithTwitter();
    print(data);
    if (data is LoginData) {
      var response = await sl<Cases>().getLoginFB(data);
      setState(() {
        showProgress = false;
      });
      if (response is String) {
        showToast(response);
        if(response == notExist){
          Get.to(()=>PasswordPage(login: data),transition: Transition.fadeIn);
        }
      } else if (response is LoginData) {
        sl<Cases>().setLoginData(response);
         Get.offNamed(homeScreen);
      }
    } else {
      setState(() {
        showProgress = false;
      });
      showToast("$data");
    }
  }

  void googleMethod() async {
    unFocus(context);
    setState(() {
      showProgress = true;
    });
    var data = await signInWithGoogle();
    print(data);
    if (data is LoginData) {
      var response = await sl<Cases>().getLoginFB(data);
      setState(() {
        showProgress = false;
      });
      if (response is String) {
        showToast(response);
        if(response == notExist){
          Get.to(()=>PasswordPage(login: data),transition: Transition.fadeIn);
        }
      } else if (response is LoginData) {
        sl<Cases>().setLoginData(response);
         Get.offNamed(homeScreen);
      }
    } else {
      setState(() {
        showProgress = false;
      });
      showToast("$data");
    }
  }

  void facebookMethod() async {
    unFocus(context);
    setState(() {
      showProgress = true;
    });
    var data = await loginWithFacebook();
    print(data);
    if (data is LoginData) {
      var response = await sl<Cases>().getLoginFB(data);
      setState(() {
        showProgress = false;
      });
      if (response is String) {
        showToast(response);
        if(response == notExist){
          Get.to(()=>PasswordPage(login: data),transition: Transition.fadeIn);
        }
      } else if (response is LoginData) {
        sl<Cases>().setLoginData(response);
         Get.offNamed(homeScreen);
      }
    } else {
      setState(() {
        showProgress = false;
      });
      showToast("$data");
    }
  }
}
