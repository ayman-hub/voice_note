import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:voice_note/injection.dart';
import 'package:voice_note/voice/domain/entities/data_entities.dart';
import 'package:voice_note/voice/domain/entities/login_data.dart';
import 'package:voice_note/voice/domain/use_cases/case.dart';
import 'package:voice_note/voice/domain/use_cases/constant_data.dart';

const String FIREBASE_COLLECITON_USERS = "LOGIN";
const String FIREBASE_COLLECITON_Data = "data";


class RemoteData {
  FirebaseFirestore firestore;

  RemoteData({required this.firestore});



  // login


  Future<dynamic> insertLogin(LoginData login) async {
    try {
    DocumentSnapshot data =  await firestore
          .collection(FIREBASE_COLLECITON_USERS)
          .doc(login.email).get();
    if(data.exists){
      return "email is Already Sign up";
    }
      await firestore
          .collection(FIREBASE_COLLECITON_USERS)
          .doc(login.email)
          .set(login.toJson());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }


  Future<dynamic> getLogin(LoginData login) async {
    try {
      print('login::: ${login.email}');
      DocumentSnapshot data = await firestore
          .collection(FIREBASE_COLLECITON_USERS)
          .doc(login.email)
          .get();
      print('responseData::: ${data.data()}');
      if (data.exists) {
        return LoginData.fromJson(data.data()as Map<String, dynamic>);
      } else {
        return notExist;
      }
    } catch (e) {
      print(e);
      return "error has been happen please try again";
    }
  }

  Future<dynamic> getData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> data = await firestore
          .collection(FIREBASE_COLLECITON_USERS)
          .doc(sl<Cases>().getLoginData().email).collection(FIREBASE_COLLECITON_Data)
          .get();
      List<DataEntities> voices = [];
      if(data.docs.length != 0){
        data.docs.forEach((element) {
            DataEntities dataEntities = DataEntities.fromJson(element.data());
            voices.add(dataEntities);
        });
      }
      return voices;
    } catch (e) {
      print("error get data ::::: $e");
      return e;
    }
  }
  Future<dynamic> insertData(DataEntities dataEntities) async {
    try {
     await firestore
          .collection(FIREBASE_COLLECITON_USERS)
          .doc(sl<Cases>().getLoginData().email).collection(FIREBASE_COLLECITON_Data)
          .doc(dataEntities.date.toString()).set(dataEntities.toJson());
    return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
  Future<dynamic> deleteData(DataEntities dataEntities) async {
    try {
      await firestore
          .collection(FIREBASE_COLLECITON_USERS)
          .doc(sl<Cases>().getLoginData().email).collection(FIREBASE_COLLECITON_Data)
          .doc(dataEntities.date.toString()).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }



  Future<String> uploadFile(Uint8List file,String name)async{
    Reference _reference = FirebaseStorage.instance
        .ref()
        .child('voices/$name');
    await _reference
        .putData(
      file,
      SettableMetadata(contentType: 'audio/mp3'),
    );
    return await _reference.getDownloadURL();
  }
  Future<bool> removeFile(String name)async{
    bool uploadedPhotoUrl = true ;
    await FirebaseStorage.instance
        .ref()
        .child('voices/$name').delete().whenComplete(() => uploadedPhotoUrl = true);
    return uploadedPhotoUrl;
  }

}
