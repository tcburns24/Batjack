import 'package:blacktom/models/user.dart';
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

  // 3) Register w/ Email/Password

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
