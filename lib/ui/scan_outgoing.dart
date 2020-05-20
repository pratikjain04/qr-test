import 'dart:io';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:qrtest/services/crud.dart';
import 'package:qrtest/ui/dashboard.dart';
import 'package:qrtest/ui/qrcode_read.dart';
import 'package:qrtest/utils/my_colors.dart';
import 'dart:async';

class ScanOutgoing extends StatefulWidget {
  final String incomingId; // passing the incomingID from previous scan

  ScanOutgoing({Key key, this.incomingId}) : super(key: key);

  @override
  _ScanOutgoingState createState() => _ScanOutgoingState();
}

/// [commentController] handles the comment text. It is responsible for any changes that needs to be noted
/// about a particular offer
/// [barcode] stores the scan data from the outgoing QR Code scan
/// [_scaffoldKey] track current scaffold and show Snackbar

class _ScanOutgoingState extends State<ScanOutgoing> with TickerProviderStateMixin {

  TextEditingController commentController = TextEditingController();
  String barcode = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  /// to show successful or failure of posting data to the DB
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

  @override
  void initState() {
    /// listening to dynamic changes in the comment text
    commentController.addListener(() {
      setState(() {});
    });
    /// starting the QR Code scan process on start of the page
    scan().then((v) {
      _finalDataDialog(incomingId: widget.incomingId, outgoingId: barcode);
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        title: Text(
          "IAESTE India",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
            icon: Image.asset(
              "assets/qr-code.png",
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => QRCodeScan(),
                  ));
            }),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.track_changes,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Dashboard()));
            },
          )
        ],
      ),
      body: Container(),
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    }
  }

  Future<void> _finalDataDialog({String incomingId, String outgoingId}) async {
    String commentData;

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Final Data'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Incoming: $incomingId'),
                Text('Outgoing: $outgoingId'),
                TextFormField(
                  controller: commentController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Add Comments',
                  ),
                  onChanged: (comment) {
                    commentData = commentController.text;
                  },
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Submit'),
              onPressed: () {
                HandleCRUD()
                    .addRefNumber(
                        incomingId: incomingId,
                        outgoingId: outgoingId,
                        comments: commentData)
                    .then((v) {
                  Navigator.pop(context);
                  showInSnackBar("Data Added Successfully");
                });
              },
            ),
            FlatButton(
              child: Text('Retake'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => QRCodeScan()));
              },
            ),
          ],
        );
      },
    );
  }


}
