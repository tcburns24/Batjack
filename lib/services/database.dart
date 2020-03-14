import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  DatabaseService({this.uid});

  final String uid;

  // 1) Collection reference
  final CollectionReference gamblersCollection = Firestore.instance.collection('gamblers');

  Future updateUserData(String username, int chips, int level) async {
    return await gamblersCollection.document(uid).setData({'username': username, 'chips': chips, 'level': level});
  }

  // 2) Gamblers collection stream
  Stream<QuerySnapshot> get gamblers {
    return gamblersCollection.snapshots();
  }
}
