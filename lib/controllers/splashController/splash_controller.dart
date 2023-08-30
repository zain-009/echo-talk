import 'dart:async';
import 'package:flutter/material.dart';
import '../../views/auth/auth_page.dart';

class SplashController{
  void splashTimer(BuildContext context){
    Timer(const Duration(seconds: 2), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthPage())));
  }
}