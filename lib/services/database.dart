import 'package:blacktom/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  DatabaseService({this.uid});

  final String uid;

  // 1) Collection reference
  final CollectionReference gamblersCollection = Firestore.instance.collection('gamblers');

  Future updateUserData(String username, int chips, int batpoints, String batvatar) async {
    return await gamblersCollection.document(uid).setData({'username': username, 'chips': chips, 'batpoints': batpoints, 'batvatar': batvatar});
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(uid: uid, chips: snapshot.data['chips'], username: snapshot.data['username'], level: snapshot.data['level']);
  }

  // 2) Gamblers collection stream
  Stream<QuerySnapshot> get gamblers {
    return gamblersCollection.snapshots();
  }

  Stream<QuerySnapshot> get allGamblers {
    return gamblersCollection.snapshots();
  }

  // 3) Get individual Gambler document stream
  Stream<UserData> get gamblerData {
    return gamblersCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }
}
