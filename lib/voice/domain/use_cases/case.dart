import 'dart:typed_data';
import 'package:voice_note/voice/domain/entities/data_entities.dart';
import 'package:voice_note/voice/domain/entities/login_data.dart';
import 'package:voice_note/voice/domain/repositories/domain_repositry.dart';


class Cases {
  DomainRepositry domainRepositry;

  Cases({required this.domainRepositry});


  // login
  Future<dynamic> insertLoginFB(LoginData login){
    return domainRepositry.insertLoginFB(login);
  }
  Future<dynamic> getLoginFB(LoginData loginData){
    return domainRepositry.getLoginFB(loginData);
  }

  Future<void> setLoginData(
      dynamic loginDataEntities){
    return domainRepositry.setLoginData(loginDataEntities);
  }

  LoginData getLoginData(){
    return domainRepositry.getLoginData();
  }

  // voice

  Future<dynamic> getData(){
    return domainRepositry.getData();
  }
  Future<dynamic> insertData(DataEntities dataEntities){
    return domainRepositry.insertData(dataEntities);
  }
  Future<dynamic> deleteData(DataEntities dataEntities){
    return domainRepositry.deleteData(dataEntities);
  }



  Future<String> uploadFile(Uint8List file,String name){
    return domainRepositry.uploadFile(file, name);
  }
  Future<bool> removeFile(String name){
    return domainRepositry.removeFile(name);
  }

  Future<bool> checkPermission(){
    return domainRepositry.checkPermission();
  }


  Future<String> getFilePath(String name){
    return domainRepositry.getFilePath(name);
  }
  Future<String> startRecord(String name){
    return domainRepositry.startRecord(name);
  }

  void pauseRecord(){
    return domainRepositry.pauseRecord();
  }

  void stopRecord(){
    return domainRepositry.stopRecord();
  }

  void resumeRecord(){
    return domainRepositry.resumeRecord();
  }
}
