import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:qrtest/services/crud.dart';
import 'package:qrtest/ui/dashboard.dart';
import 'package:qrtest/ui/qrcode_read.dart';
import 'package:qrtest/utils/my_colors.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

class ExtractOutgoing extends StatefulWidget {
  final String incomingId;
  final String title;

  ExtractOutgoing({Key key, this.title, this.incomingId}) : super(key: key);

  @override
  _ExtractOutgoingState createState() => _ExtractOutgoingState();
}

class _ExtractOutgoingState extends State<ExtractOutgoing>
    with TickerProviderStateMixin {
  File pickedImage;
  String extractedText = '';
  AnimationController _controller;
  TextEditingController commentController = TextEditingController();
  static const List<IconData> icons = const [
    Icons.camera_alt,
    Icons.photo,
  ];
  TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();

  Future<VoidCallback> getImage(int type) async {
    var image;
    if (type == 1)
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    else
      image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      pickedImage = image;
    });

    _cropImage(pickedImage);
  }

  Future<void> _cropImage(File imageFile) async {
    File cropped = await ImageCropper.cropImage(sourcePath: imageFile.path);

    setState(() {
      pickedImage = cropped ?? imageFile;
    });
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

  Future<void> processImage() async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
    VisionText readText = await recognizeText.processImage(ourImage);
    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          print(element.text);

          if (element.text.contains('-2019-') ||
              element.text.contains('-2020-')) {
            setState(() {
              extractedText = element.text;
            });

            _finalDataDialog(
                incomingId: widget.incomingId, outgoingId: extractedText);
          }
        }
      }
    }
  }

  @override
  void initState() {
    commentController.addListener(() {
      setState(() {});
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

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
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Container(
                height: 400,
                width: 400,
                child: Center(
                  child: pickedImage == null
                      ? Text('No image selected.')
                      : Image.file(pickedImage),
                ),
              ),
            ),
            pickedImage == null
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(50.0),
                        child: RaisedButton(
                          color: MyColors.primaryColor,
                          child: Text(
                            'Extract Text',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            processImage().whenComplete(() {
                              recognizeText.close();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
            Padding(
              padding: EdgeInsets.all(50.0),
              child: Center(
                child: Text(
                  extractedText,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(icons.length, (int index) {
          Widget child = Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: _controller,
                curve: Interval(0.0, 1.0 - index / icons.length / 2.0,
                    curve: Curves.easeOut),
              ),
              child: FloatingActionButton(
                heroTag: null,
                backgroundColor: MyColors.primaryColor,
                mini: true,
                child: Icon(icons[index], color: Colors.white),
                onPressed: () {
                  getImage(index);
                },
              ),
            ),
          );
          return child;
        }).toList()
          ..add(
            FloatingActionButton(
              heroTag: null,
              backgroundColor: MyColors.primaryColor,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget child) {
                  return Transform(
                    transform:
                        Matrix4.rotationZ(_controller.value * 0.5 * 3.13),
                    alignment: FractionalOffset.center,
                    child:
                        Icon(_controller.isDismissed ? Icons.add : Icons.close),
                  );
                },
              ),
              onPressed: () {
                if (_controller.isDismissed) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
              },
            ),
          ),
      ),
    );
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
