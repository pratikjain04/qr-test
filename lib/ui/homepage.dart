import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:qrtest/ui/dashboard.dart';
import 'package:qrtest/ui/qrcode_read.dart';
import 'package:qrtest/utils/my_colors.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  File pickedImage;
  String extractedText = '';

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

  Future<void> processImage() async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
    VisionText readText = await recognizeText.processImage(ourImage);
    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          print(element.text);

          if (element.text.contains('TR') ) {
            setState(() {
              extractedText = element.text;
            });
          }
        }
      }
    }
  }

  AnimationController _controller;

  static const List<IconData> icons = const [
    Icons.camera_alt,
    Icons.photo,
  ];

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          child: Column(
            children: <Widget>[
              Center(
                child: FlatButton(
                  child: Text(
                    'Dashboard',
                    style: TextStyle(color: MyColors.primaryColor),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => Dashboard(),
                    ));
                  },
                ),
              ),
              Center(
                child: FlatButton(
                  child: Text(
                    'QR Scan',
                    style: TextStyle(color: MyColors.primaryColor),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => QRCodeScan(),
                    ));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
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
            Row(
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
                Padding(
                  padding: EdgeInsets.all(50.0),
                  child: RaisedButton(
                    color: MyColors.primaryColor,
                    child: Text(
                      'Crop Image',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _cropImage(pickedImage);

                    },
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.all(50.0),
              child: Center(child: Text(extractedText, style: TextStyle(color: Colors.black),),),
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
                onPressed: (){
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
                    child: Icon(
                        _controller.isDismissed ? Icons.add : Icons.close),
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
}
