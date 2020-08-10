import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qrtest/utils/constants.dart';
import 'package:qrtest/utils/my_colors.dart';
import 'package:qrtest/utils/settings.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  String countryName;

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  checkLogin() async {
    await Storage.getCountry().then((value) {
      print(value);
      if(value != null){
        setState(() {
          countryName = value;
          Constants.country = value;
        });
      }
      startTimer();
    });

  }

  startTimer() {
    Timer(Duration(milliseconds: 1500), () {
      // if login status is logged in, i.e., if true then go to homepage
      if(countryName != null)
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
