import 'package:blacktom/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  Map<String, bool> openCasinos = {
    'gcpd': false,
    'blackgate': false,
    'arkham': false,
    'iceberg': false,
    'courthouse': false,
    'ace': false,
    'cemetary': false,
  };

  // 1) Collection reference
  final CollectionReference gamblersCollection = FirebaseFirestore.instance.collection('gamblers');

  Future updateUserData(String username, int chips, int batpoints, String batvatar) async {
    return await gamblersCollection.doc(uid).set({'username': username, 'chips': chips, 'batpoints': batpoints, 'batvatar': batvatar, 'openCasinos': openCasinos});
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return UserData(
      uid: uid,
      chips: data['chips'],
      username: data['username'],
      batpoints: data['batpoints'],
      batvatar: data['batvatar'],
    );
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
    return gamblersCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
