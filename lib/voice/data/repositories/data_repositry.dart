import 'dart:typed_data';


import 'package:voice_note/voice/data/data_sources/local_data/record.dart';
import 'package:voice_note/voice/data/data_sources/local_data/shared_preferences.dart';
import 'package:voice_note/voice/data/remote_data/firebase_remote_data.dart';
import 'package:voice_note/voice/domain/entities/data_entities.dart';
import 'package:voice_note/voice/domain/entities/login_data.dart';
import 'package:voice_note/voice/domain/repositories/domain_repositry.dart';

class DataRepositry extends DomainRepositry {
  RemoteData remoteData;
  GetSharedPreference getSharedPreference;
  Record record;

  DataRepositry({
    required this.remoteData,
    required this.getSharedPreference,
    required this.record,
  });

  @override
  LoginData getLoginData() {
    return getSharedPreference.getLoginData();
  }

  @override
  Future<void> setLoginData(LoginData loginDataEntities) {
    return getSharedPreference.setLoginData(loginDataEntities);
  }

  @override
  Future getLoginFB(LoginData loginData) {
    return remoteData.getLogin(loginData);
  }

  @override
  Future<dynamic> insertLoginFB(LoginData login) {
    return remoteData.insertLogin(login);
  }

  @override
  Future deleteData(DataEntities dataEntities) {
    return remoteData.deleteData(dataEntities);
  }

  @override
  Future getData() {
    return remoteData.getData();
  }

  @override
  Future insertData(DataEntities dataEntities) {
    return remoteData.insertData(dataEntities);
  }

  @override
  Future<bool> checkPermission() {
    return record.checkPermission();
  }

  @override
  Future<String> getFilePath(String name) {
    return record.getFilePath(name);
  }

  @override
  void pauseRecord() {
  return record.pauseRecord();
  }

  @override
  Future<bool> removeFile(String name) {
    return remoteData.removeFile(name);
  }

  @override
  void resumeRecord() {
   return record.resumeRecord();
  }

  @override
  Future<String> startRecord(String name) {
    return record.startRecord(name);
  }

  @override
  void stopRecord() {
    return record.stopRecord();
  }

  @override
  Future<String> uploadFile(Uint8List file, String name) {
    return remoteData.uploadFile(file, name);
  }
}
