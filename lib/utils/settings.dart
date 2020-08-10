import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {


  static Future<String> setCountry({@required String value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("country", value);
  }


  static Future<String> getCountry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString("country");
  }

}