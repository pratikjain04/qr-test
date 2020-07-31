import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qrtest/utils/constants.dart';
import 'package:qrtest/utils/my_colors.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 2500), () {

      // if login status is logged in, i.e., if true then go to homepage
      if(isLoggedIn)
        Navigator.pushReplacementNamed(context, "/app");
      else
        Navigator.pushReplacementNamed(context, "/login");
    });
  }

  @override
  Widget build(BuildContext context) {

    // To access anywhere in the codebase just use "Constants.height"
    Constants.height = MediaQuery.of(context).size.height; // saving device height
    Constants.width = MediaQuery.of(context).size.width; // saving device width


    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      body: Container(
        child: Center(
          child: Hero(
              tag: Constants.logoImage,
              child: Image.asset(Constants.logoImage, scale: 10.0,)),
        ),
      ),
    );
  }
}
