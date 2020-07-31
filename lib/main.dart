import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:qrtest/ui/login.dart';
import 'package:qrtest/ui/qrcode_read.dart';
import 'package:qrtest/ui/splash.dart';
import 'dart:async';
import 'ui/scan_outgoing.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IAESTE Offer Map',
      home: SplashPage(),
      routes: <String, WidgetBuilder> {
        "/login": (BuildContext context) => LoginPage()
      },
    );
  }
}
