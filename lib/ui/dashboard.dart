import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrtest/services/crud.dart';
import 'package:qrtest/utils/my_colors.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Stream<QuerySnapshot> data;

  @override
  void initState() {
    super.initState();
//      data = HandleCRUD().getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        title: Text(
          'Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
body: Container(),
//      body: StreamBuilder<QuerySnapshot>(
//        stream: Firestore.instance.collection('/refNumber').snapshots(),
//        builder: (context, snapshot) {
//          if (!snapshot.hasData)
//            return new Text('Error Loading Data, Please check your internet connection}');
//          else{
//              return new ListView(
//                children: snapshot.data.documents.map((DocumentSnapshot document) {
//                  print(document);
//                  return new ListTile(
//                    title: new Text(document.data['taken']),
//                    subtitle: new Text(document.data['given']),
//                  );
//                }).toList(),
//              );
//          }
//        },
//      ),
//      body: FutureBuilder<DocumentSnapshot>(
//        future: HandleCRUD().getData(),
//        builder: (context, projectSnap) {
//          if (!projectSnap.hasData) {
//            return Center(
//              child: CircularProgressIndicator(),
//            );
//          }
//          print("dashboard.dart:${projectSnap.data}");
//          return ListView.builder(
//            itemCount: 1,
//              itemBuilder: (BuildContext context, index) {
//                return ListTile(
//                  title: Text(projectSnap.toString()),
//                );
//              });
//        },
//      ),
    );
  }
}
