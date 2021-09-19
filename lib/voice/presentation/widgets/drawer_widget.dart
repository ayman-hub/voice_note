import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voice_note/voice/domain/use_cases/constant_data.dart';

import 'package:voice_note/voice/presentation/pages/home_page.dart';


class DrawerWidget extends StatelessWidget {
  DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: staticColor,
      child: Container(
        alignment: Alignment.centerLeft,
        color: staticColor,
        margin: EdgeInsets.only(right: MediaQuery.of(context).size.width / 2),
        child: Column(
          children: [
            DrawerHeader(
                padding: EdgeInsets.only(right: 50,left: 10),
                child: Image.asset("images/message.png",color: Colors.white,)),
        /// insert widgets of drawer
          ],
        ),
      ),
    );
  }
}
