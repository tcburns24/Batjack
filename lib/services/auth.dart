import 'package:blacktom/models/user.dart';
import 'package:blacktom/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // 1) Sign in anonymously
  FirebaseAuth _auth = FirebaseAuth.instance;

  // Convert the Firebase user into a lightweight user
  User _userFromFirebase(FirebaseUser fbUser) {
    return fbUser != null ? User(uid: fbUser.uid) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map((FirebaseUser user) => _userFromFirebase(user));
  }

  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebase(user);
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  // 2) Sign in w/ Email/Password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser fbUser = result.user;
      return _userFromFirebase(fbUser);
    } catch (err) {
      print('err = ${err.toString()}');
      return null;
    }
  }

  // 3) Register w/ Email/Password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser fbUser = result.user;
      await DatabaseService(uid: fbUser.uid).updateUserData(email, 100, 25, 'assets/batmen/adam_west.png');
      return _userFromFirebase(fbUser);
    } catch (err) {
      print('err = ${err.toString()}');
      return null;
    }
  }

  // 4) Sign Out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (err) {
      print('Sign out error = ${err.toString()}');
      return null;
    }
  }
}
