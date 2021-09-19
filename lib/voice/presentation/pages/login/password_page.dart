import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:voice_note/voice/domain/entities/login_data.dart';
import 'package:voice_note/voice/domain/use_cases/case.dart';
import 'package:voice_note/voice/domain/use_cases/constant_data.dart';
import 'package:voice_note/voice/presentation/widgets/const_widget.dart';
import 'package:voice_note/voice/presentation/widgets/loading_widget.dart';

import '../../../../injection.dart';
import '../../../../toast_utils.dart';

class PasswordPage extends StatefulWidget {
  PasswordPage({Key? key,required this.login}) : super(key: key);
LoginData login;
  @override
  _PasswordPageState createState() {
    return _PasswordPageState();
  }
}

class _PasswordPageState extends State<PasswordPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller1;
  late Animation animation1;

  late Animation shade;

  late Animation animation2;
  late Size getSize;


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
 Size  getSize = MediaQuery.of(context).size;
 return Container(
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
   child: Scaffold(
     backgroundColor: Colors.transparent,
     appBar: AppBar(
       elevation: 0.0,
       backgroundColor: Colors.transparent,
     ),
     body: InkWell(
       onTap:(){
         unFocus(context);
       },
       child: SingleChildScrollView(
         child: Container(
           height: getSize.height,
           padding: EdgeInsets.only(top: 70),
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
           child: Stack(
             children: [
               Form(
                 key: formKey,
                 child: Container(
                   alignment: Alignment.center,
                   child: AnimatedBuilder(
                       animation: controller1,
                       builder: (animation, child) {
                         return Column(
                         // mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             FadeTransition(
                               opacity: shade as Animation<double>,
                               child: Container(
                                 alignment: Alignment.center,
                                 margin: EdgeInsets.only(right: 10),
                                 child: Text(
                                   'Sign Up',
                                   style: TextStyle(
                                       color: Colors.white,
                                       fontSize: 20,
                                       fontWeight: FontWeight.bold),
                                 ),
                               ),
                             ),
                             Flexible(
                               child: SizedBox(
                                 height: 20,
                               ),
                             ),
                             Container(
                               alignment: Alignment.centerLeft,
                               padding: EdgeInsets.only(left: 10),
                               child: Text('Password',style: TextStyle(color: Colors.white,fontSize: 14),),
                             ),
                             SlideTransition(
                               position: animation1 as Animation<Offset>,
                               child: Container(
                                 margin: EdgeInsets.all(10),
                                 child: TextFormField(
                                   maxLines: 1,
                                   obscureText: true,
                                   onChanged: (value) {
                                     widget.login.password = value;
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
                             Flexible(
                               child: SizedBox(
                                 height: 20,
                               ),
                             ),
                             Container(
                               alignment: Alignment.centerLeft,
                               padding: EdgeInsets.only(left: 10),
                               child: Text('Confirm Password',style: TextStyle(color: Colors.white,fontSize: 14),),
                             ),
                             SlideTransition(
                               position: animation2 as Animation<Offset>,
                               child: Container(
                                 margin: EdgeInsets.all(10),
                                 child: TextFormField(
                                   maxLines: 1,
                                   obscureText: true,
                                   validator: (value) {
                                     if (value!.isEmpty) {
                                       return 'need to write password';
                                     }else if(value != widget.login.password){
                                       return "confirm password not identical with password";
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
                             Flexible(
                               child: SizedBox(
                                 height: 20,
                               ),
                             ),
                             Container(
                               margin: EdgeInsets.all(10),
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
                                     'Sign Up',
                                     style: TextStyle(
                                         color: staticColor,
                                         fontWeight: FontWeight.bold,
                                         fontSize: 18),
                                   ),
                                 ),
                               ),
                             ),
                           ],
                         );
                       }),
                 ),
               ),
               showProgress
                   ? Container(
                   width: getSize.width,
                   height: getSize.height,
                   child: loadingContainer())
                   : Container()
             ],
           ),
         ),
       ),
     ),
   ),
 );
  }

  void loginMethod() async {
    unFocus(context);
    if (formKey.currentState!.validate()) {
      setState(() {
        showProgress = true;
      });
      var response = await sl<Cases>().insertLoginFB(widget.login);
      setState(() {
        showProgress = false;
      });
      if (response is String) {
        showToast(response);
      } else if (response  == true) {
        sl<Cases>().setLoginData(widget.login);
        Get.offAllNamed(homeScreen);
      }
    }
  }
}
