

import 'dart:typed_data';

import 'package:voice_note/voice/domain/entities/data_entities.dart';
import 'package:voice_note/voice/domain/entities/login_data.dart';


abstract class DomainRepositry {


  // login

  Future<dynamic> insertLoginFB(LoginData login);
  Future<dynamic> getLoginFB(LoginData loginData);

  Future<void> setLoginData(
      LoginData loginDataEntities);

  LoginData getLoginData();



  // data voice
  Future<dynamic> getData() ;
  Future<dynamic> insertData(DataEntities dataEntities);
  Future<dynamic> deleteData(DataEntities dataEntities);


  //upload file
  Future<String> uploadFile(Uint8List file,String name);
  Future<bool> removeFile(String name);


  //record

  Future<bool> checkPermission();


  Future<String> getFilePath(String name);
  Future<String> startRecord(String name);

  void pauseRecord();

  void stopRecord();

  void resumeRecord();
}
