import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:voice_note/voice/domain/entities/login_data.dart';

const String SHAREDPREFERENCE_USER = "USER";

class GetSharedPreference {
  GetStorage sharedPreferences;

  GetSharedPreference({required this.sharedPreferences});

  Future<void> setLoginData(LoginData loginDataEntities) async {
    print("insert data: " + jsonEncode(loginDataEntities.toJson()));
    sharedPreferences.write(SHAREDPREFERENCE_USER, loginDataEntities.toJson());
  }

  LoginData getLoginData() {
    if (sharedPreferences.read(SHAREDPREFERENCE_USER) != null) {
      return LoginData.fromJson(sharedPreferences.read(SHAREDPREFERENCE_USER));
    } else {
      return LoginData(password: "", email: "");
    }
  }
}
