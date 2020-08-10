import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qrtest/models/login_model.dart';
import 'package:qrtest/ui/qrcode_read.dart';
import 'package:qrtest/utils/constants.dart';
import 'package:qrtest/utils/my_colors.dart';
import 'package:qrtest/utils/settings.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  List<LoginModel> countryList = [];
  List<String> countries = [];
  List<DropdownMenuItem<String>> options = [];
  String selectedCountry;
  bool isOptionCreated = false;
  TextEditingController pinController = TextEditingController();

  buildCountryObjectList() async {
    String data = await DefaultAssetBundle.of(context).loadString("assets/data.json");
    List<dynamic> res = json.decode(data)["login"];

    countryList?.clear();

    res.forEach((data) {
      countryList.add(LoginModel.fromJson(data));
    });

    buildCountryDropDownData();
  }

  buildCountryDropDownData() {
    countries?.clear();

    countryList.forEach((countryObject) {
      countries.add(countryObject.country);
    });

    countries.sort();
    print(countries);


    for(int i =0; i<countries.length; i++) {
      createOptions(countries[i]);
    }

    setState(() {
      isOptionCreated = true;
    });
  }

  handleSuccess(){
    Constants.country = selectedCountry;
    Storage.setCountry(value: selectedCountry);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => QRCodeScan()));
  }

  handleFailure(){
    Toast.show("Incorrect Pin or Country", context,
        gravity: Toast.BOTTOM,
        backgroundColor: Colors.redAccent,
        duration: Toast.LENGTH_SHORT);
  }

  int flag = 0;

  verifyPin({@required String country, @required String pin}) {


    for(int i = 0; i<countryList.length; i++){
      if(countryList[i].country == country && countryList[i].pin == pin){
        setState(() {
          flag = 1;
        });
        break;
      }
      else {
        setState(() {
          flag = 0;
        });
      }
    }

    if(flag == 1)
      handleSuccess();
    else
      handleFailure();
  }

  void createOptions(String text) {

    print("Inside Create Options");

    options.add(DropdownMenuItem<String>(
      value: text,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(text, style: TextStyle(fontSize: 16.0),),
        ],
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
    buildCountryObjectList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: Constants.height / 50,
                ),
                Center(
                  child: Hero(
                    tag: Constants.logoImage,
                    child: Image.asset(
                      Constants.logoImage,
                      scale: 12.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: Constants.height / 5,
                ),
               isOptionCreated ? Center(
                  child: DropdownButton<String>(
                    dropdownColor: MyColors.primaryColor,
                    elevation: 10,
                    iconDisabledColor: Colors.white,
                    hint: Text("Select Country Name            ", style: TextStyle(color: Colors.white, fontSize: 20.0),),
                    items: options,
                    value: selectedCountry,
                    style: TextStyle(color: Colors.white),
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        selectedCountry = value;
                      });
                    },
                  ),
                ) : Container(),
                SizedBox(height: 20.0,),
                Container(
                  height: Constants.height/20,
                  width: Constants.width/1.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: TextField(
                      controller: pinController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter PIN",
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                SizedBox(height: Constants.height/10),
                RaisedButton(
                  color: Colors.white,
                  child: Text("Login", style: TextStyle(color: MyColors.primaryColor),),
                  onPressed: (){
                    verifyPin(country: selectedCountry, pin: pinController.text);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
