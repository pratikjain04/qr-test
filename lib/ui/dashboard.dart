import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrtest/ui/qrcode_read.dart';
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

        actions: <Widget>[
          IconButton(
              tooltip: "Scan QR Code",
              icon: Image.asset("assets/qr-code.png", color: Colors.white,), onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => QRCodeScan()));
          }),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('/refNumber').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(MyColors.primaryColor),));
          else{
              return ListView(
                children: snapshot.data.documents.map((DocumentSnapshot document) {
                  print(document);
                  return ListTile(
                    title: Text(document.data['outgoing']),
                    subtitle: Text(document.data['incoming']),
                  );
                }).toList(),
              );
          }
        },
      ),

    );
  }
}
