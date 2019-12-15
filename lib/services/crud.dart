import 'package:cloud_firestore/cloud_firestore.dart';



// givenRef: Given from India to Foreign
// takenRef: Taken from Foreign for India
class HandleCRUD {

  Future<void> addRefNumber({String givenRef, String takenRef}) async{

    Map<String,String> data = {
      "given": givenRef,
      "taken": takenRef
    };

    Firestore.instance.collection('/refNumber').add(data).catchError((e){
      print(e);
    });
  
  }

  getData() async{
    return await Firestore.instance.collection('/refNumber').snapshots();
  }


}