import 'package:blacktom/models/user.dart';
import 'package:blacktom/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Convert the Firebase user into a lightweight user
  AppUser? _userFromFirebase(User? fbUser) {
    return fbUser != null ? AppUser(uid: fbUser.uid) : null;
  }

  Stream<AppUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  Future<AppUser?> signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? fbUser = result.user;
      return _userFromFirebase(fbUser);
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  Future<AppUser?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? fbUser = result.user;
      return _userFromFirebase(fbUser);
    } catch (err) {
      print('err = ${err.toString()}');
      return null;
    }
  }

  Future<AppUser?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? fbUser = result.user;
      await DatabaseService(uid: fbUser!.uid).updateUserData(email, 100, 25, 'assets/batmen/adam_west.png');
      return _userFromFirebase(fbUser);
    } catch (err) {
      print('err = ${err.toString()}');
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (err) {
      print('Sign out error = ${err.toString()}');
      return null;
    }
  }
}
