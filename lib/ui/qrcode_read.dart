import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:qrtest/ui/dashboard.dart';
import 'package:qrtest/ui/extract_outgoing.dart';
import 'package:qrtest/utils/my_colors.dart';

class QRCodeScan extends StatefulWidget {
  @override
  _QRCodeScanState createState() => _QRCodeScanState();
}

class _QRCodeScanState extends State<QRCodeScan> {
  String barcode = '';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: MyColors.primaryColor,
          title: Text('IAESTE India'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.track_changes, color: Colors.white,), onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Dashboard()));
            },)
          ],
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: "Scan QR",
          child: Image(
            image: AssetImage("assets/qr-code.png"),
            color: Colors.white,
          ),
          backgroundColor: MyColors.primaryColor,
          onPressed: () {
            scan().then((v) {
              _finalDataDialog();
            });
          },
        ),
        body: Center(
          child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/bg.png"),
                  )
              ),
        ))
    );
  }

  Future<void> _finalDataDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Final Data'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('QR Code data: $barcode'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Go Ahead'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => ExtractOutgoing(
                          incomingId: barcode,
                        )));
              },
            ),
            FlatButton(
              child: Text('Scan Again'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
