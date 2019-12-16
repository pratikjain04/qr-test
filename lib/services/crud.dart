import 'package:cloud_firestore/cloud_firestore.dart';



// incoming: Given from India to Foreign
// outgoing: Taken from Foreign for India
class HandleCRUD {

  Future<void> addRefNumber({String incomingId = "", String outgoingId = ""}) async{

    Map<String,String> data = {
      "incoming": incomingId,
      "outgoing": outgoingId
    };

    Firestore.instance.collection('/refNumber').add(data).catchError((e){
      print(e);
    });
  
  }

  getData() async{
    return await Firestore.instance.collection('/refNumber').snapshots();
  }


}