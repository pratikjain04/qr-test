import 'package:cloud_firestore/cloud_firestore.dart';



// incoming: Given from India to Foreign
// outgoing: Taken from Foreign for India
class HandleCRUD {

  ///adding data to Firestore
  Future<void> addRefNumber({String incomingId = "", String outgoingId = "", String comments = ""}) async{

    Map<String,String> data = {
      "incoming": incomingId,
      "outgoing": outgoingId,
      "comments": comments
    };

    Firestore.instance.collection('/refNumber').add(data).catchError((e){
      print(e);
    });
  
  }


  /// for fetching data as streams from Firestore
  getData() async{
    return await Firestore.instance.collection('/refNumber').snapshots();
  }


  /// for updating data in dashboard if wrongly entered
  updateData(selectedDoc, newValues) {
    Firestore.instance
        .collection('refNumber')
        .document(selectedDoc)
        .updateData(newValues)
        .catchError((e) {
      print(e);
    });
  }

  /// for deleting a offer map from database
  deleteData(docId) {
    Firestore.instance
        .collection('refNumber')
        .document(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }
}


