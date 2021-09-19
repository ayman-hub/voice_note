import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:voice_note/injection.dart';
import 'package:voice_note/toast_utils.dart';
import 'package:voice_note/voice/domain/use_cases/case.dart';


class Record {

  RecordMp3 recordMp3;


  Record(this.recordMp3);

  Future<String> getFilePath(String name) async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/test_$name.mp3";
  }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }



  Future<String> startRecord(String name) async {
    String recordFilePath = "";
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      String recordFilePath = await getFilePath(name);
      print("recordPath:::::$recordFilePath");
      RecordMp3.instance.start(recordFilePath, (type) {
        showToast("Record error--->$type");
      });
      return recordFilePath;
    } else {
      showToast("No microphone permission");
    }
    return recordFilePath.isNotEmpty?recordFilePath:"";
  }

  void pauseRecord() {
    if (RecordMp3.instance.status == RecordStatus.PAUSE) {
      bool s = RecordMp3.instance.resume();
      if (s) {

      }
    } else {
      bool s = RecordMp3.instance.pause();
      if (s) {

      }
    }
  }

  void stopRecord() {
    bool s = RecordMp3.instance.stop();
    if (s) {

    }
  }

  void resumeRecord() {
    bool s = RecordMp3.instance.resume();
    if (s) {

    }
  }


/*  void play(String recordFilePath) {
    if (File(recordFilePath).existsSync()) {
      AudioPlayer audioPlayer = AudioPlayer();
      audioPlayer.setFilePath(recordFilePath);
      audioPlayer.play();
    }
  }*/

}