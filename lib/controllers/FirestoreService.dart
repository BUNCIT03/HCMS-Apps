import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
// make connection with firestore
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('database');

// store data
  Future<void> store(String data) {
    return collection.add({'title': data, 'timestamp': Timestamp.now()});
  }
// read data

// edit data

// delete data
}
