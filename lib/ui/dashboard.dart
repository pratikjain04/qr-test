import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrtest/services/crud.dart';
import 'package:qrtest/services/download_excel.dart';
import 'package:qrtest/ui/qrcode_read.dart';
import 'package:qrtest/utils/my_colors.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Stream<QuerySnapshot> data;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DownloadService downloadService = DownloadService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
              icon: Image.asset(
                "assets/qr-code.png",
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => QRCodeScan()));
              }),
          IconButton(
              tooltip: "Download Excel",
              icon: Icon(
                Icons.file_download,
                color: Colors.white,
              ),
              onPressed: () async {
                var dio = Dio();
                final externalDir = await getExternalStorageDirectory();
                final status = await Permission.storage.request();
                if(status.isGranted) {
                  downloadService.download(
                      dio, "http://iaeste.in/test.php", externalDir.path);
                }
                else{
                  print("Permission Denied");
                }
//                final externalDir = await getExternalStorageDirectory();
//                final status = await Permission.storage.request();
//
//                DownloadService.offerList.insert(0, {
//                  "incoming": "Incoming ID",
//                  "outgoing": "Outgoing ID",
//                  "comments": "Comments"
//                });
//
//                if (status.isGranted) {
//               final id = await  FlutterDownloader.enqueue(
//                      url: "https://www.iaeste.in/test.php",
//                      headers: {
//                        'string': DownloadService.offerList.toString()
//                      },
//                      savedDir: "/sdcard/download/",
//                      fileName: "OfferMap.csv",
//                      showNotification: true,
//                      openFileFromNotification: true);
//                } else {
//                  print("Permission Denied");
//                }
              }),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('/refNumber').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(MyColors.primaryColor),
            ));
          else {
            return ListView(
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                String outgoing = document.data['outgoing'];
                String incoming = document.data['incoming'];
                String comments = document.data['comments'] ?? "";
                TextEditingController inController =
                    TextEditingController(text: incoming);
                TextEditingController outController =
                    TextEditingController(text: outgoing);
                TextEditingController comController =
                    TextEditingController(text: comments);

                DownloadService.offerList.add({
                  'Incoming_ID': incoming,
                  'Outgoing_ID': outgoing,
                  'Comments': comments
                });

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: MyColors.primaryColor,
                    child: Center(
                      child: Text(
                        outgoing.substring(0, 2),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  title: Text(outgoing),
                  subtitle: Text(incoming),
                  trailing: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        tooltip: 'Edit',
                        icon: Icon(
                          Icons.edit,
                          color: MyColors.primaryColor,
                        ),
                        onPressed: () {
                          _editDashboardDataDialog(
                              documentID: document.documentID,
                              incomingController: inController,
                              outgoingController: outController,
                              commentsConroller: comController,
                              originalIncomingId: incoming,
                              originalComments: comments,
                              originalOutgoingId: outgoing);
                        },
                      ),
                      IconButton(
                        tooltip: 'Show Comments',
                        icon: Icon(
                          Icons.comment,
                          color: MyColors.primaryColor,
                        ),
                        onPressed: () {
                          _commentDialog(comment: comments);
                        },
                      ),
                      IconButton(
                        tooltip: 'Delete Data',
                        icon: Icon(
                          Icons.delete,
                          color: MyColors.primaryColor,
                        ),
                        onPressed: () {
                          _confirmDeleteDialog(documentID: document.documentID);
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }

  _editDashboardDataDialog(
      {var documentID,
      TextEditingController incomingController,
      TextEditingController outgoingController,
      TextEditingController commentsConroller,
      String originalIncomingId,
      String originalOutgoingId,
      String originalComments}) {
    String incomingData;
    String outgoingData;
    String comments;

    incomingController.addListener(() {
      setState(() {});
    });

    outgoingController.addListener(() {
      setState(() {});
    });

    commentsConroller.addListener(() {
      setState(() {});
    });

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('EDIT DATA'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: incomingController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Incoming',
                      hintText: 'Incoming Data'),
                  onChanged: (data) {
                    incomingData = incomingController.text;
                  },
                ),
                TextFormField(
                  controller: outgoingController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Ougoing',
                      hintText: 'Outgoing Data'),
                  onChanged: (data) {
                    outgoingData = outgoingController.text;
                  },
                ),
                TextFormField(
                  controller: commentsConroller,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Comments',
                      hintText: 'Write your comment'),
                  onChanged: (data) {
                    comments = commentsConroller.text;
                  },
                )
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              color: MyColors.primaryColor,
              child: Text(
                'SUBMIT',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Map<String, String> data = {
                  "incoming": incomingData ?? originalIncomingId,
                  "outgoing": outgoingData ?? originalOutgoingId,
                  "comments": comments ?? originalComments
                };

                HandleCRUD().updateData(documentID, data);
                showInSnackBar("Data Updated Successfully");
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  _confirmDeleteDialog({var documentID}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Performing this operation will delete this mapped offer!'),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              color: Colors.red,
              child: Text(
                'DELETE',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                HandleCRUD().deleteData(documentID);
                showInSnackBar("Data Deleted Successfully");
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  _commentDialog({String comment}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Comments'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  comment,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              color: MyColors.primaryColor,
              child: Text(
                'BACK',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void showInSnackBar(String value, {int type = 0}) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      action: SnackBarAction(
          textColor: Colors.white,
          label: "Scan Again",
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => QRCodeScan()));
          }),
      content: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Text(
              value,
              style: TextStyle(color: Colors.white),
            ),
          ),
          Icon(
            type == 0 ? Icons.check : Icons.clear,
            color: Colors.white,
          )
        ],
      ),
      backgroundColor: type == 0 ? Colors.green : Colors.red,
    ));
  }
}
