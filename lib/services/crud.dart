import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qrtest/utils/constants.dart';

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

    Firestore.instance.collection(Constants.country).add(data).catchError((e){
      print(e);
    });
  
  }


  /// for fetching data as streams from Firestore
  getData() async{
    return await Firestore.instance.collection(Constants.country).snapshots();
  }


  /// for updating data in dashboard if wrongly entered
  updateData(selectedDoc, newValues) {
    Firestore.instance
        .collection(Constants.country)
        .document(selectedDoc)
        .updateData(newValues)
        .catchError((e) {
      print(e);
    });
  }

  /// for deleting a offer map from database
  deleteData(docId) {
    Firestore.instance
        .collection(Constants.country)
        .document(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }
}


