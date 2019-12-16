import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:qrtest/ui/homepage.dart';
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
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ExtractOutgoing(incomingId: barcode,)));

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: MyColors.primaryColor,
          title: new Text('IAESTE India'),
          centerTitle: true,
        ),

        floatingActionButton: FloatingActionButton(
          tooltip: "Scan QR",
          child: Image(image: AssetImage("assets/qr-code.png"), color: Colors.white,),
          backgroundColor: MyColors.primaryColor,
          onPressed: (){
            scan().then((v){
              _finalDataDialog();
            });
          },
        ),
        body: Container()
    );
  }
}
