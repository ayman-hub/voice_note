import 'package:flutter/material.dart';




getLoginDecoration(String s, IconData iconData) {
  return InputDecoration(
      hintText: s,
      prefixIcon: Icon(iconData,color: Colors.white,),
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.5),fontWeight: FontWeight.w300),
      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      focusColor: Colors.white,
      fillColor: Colors.blue[600],
      filled: true,
      hoverColor: Colors.white,
      focusedBorder:OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(10.0)) ,
      border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10.0)),
      disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10.0)),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10.0)),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10.0)),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10.0)),
      counterStyle: TextStyle(color: Colors.white),
      labelStyle: TextStyle(fontWeight: FontWeight.w700,color: Colors.white));
}