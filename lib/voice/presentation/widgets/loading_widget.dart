import 'package:flutter/material.dart';

loadingContainer() {
  return Container(
    alignment: Alignment.center,
    child: Container(
      height: 50,
      width: 50,
      child: Image.asset("images/load.gif"),
    ),
  );
}