import 'package:flutter/material.dart';


import 'package:get/get.dart';

void showToast(String msg) {
  Get.snackbar("message", msg,
  backgroundColor: Colors.white
  );
}
