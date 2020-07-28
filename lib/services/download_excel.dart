import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:qrtest/services/crud.dart';
import 'package:flutter_downloader/flutter_downloader.dart';



class DownloadService {

  HandleCRUD handleCRUD = HandleCRUD();
  static List<dynamic> offerList = [];
  /// Builds JSON to be passed to the Excel Downloader API
   buildJson(data) async {

  }

  Future download(Dio dio, String url, String savePath) async {

    offerList.insert(0, {
      "Incoming_ID": "Incoming ID",
      "Outgoing_ID": "Outgoing ID",
      "Comments": "Comments"
    });

    try {
      FormData formData = new FormData.fromMap({
        "string": offerList.toString()
      });

      print(formData);

      print(savePath);
      await dio.download(
        url,
        "$savePath/offer.csv",
        data: offerList,
      );
    } catch (e) {
      print(e);
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

}