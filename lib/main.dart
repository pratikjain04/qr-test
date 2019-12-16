import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:qrtest/ui/qrcode_read.dart';
import 'dart:async';
import 'ui/homepage.dart';

void main() {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IAESTE Offer Map',
      home: QRCodeScan(),
    );
  }
}
