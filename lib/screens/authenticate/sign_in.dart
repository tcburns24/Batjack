import 'package:blacktom/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = new AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        elevation: 6.0,
        title: Text('Sign In to BlackTom'),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
          child: RaisedButton(
            child: Text('Sign In Anonymously'),
            onPressed: () async {
              AuthResult result = await _auth.signInAnon();
              if (result == null) {
                print('ahh shit. no can do.');
              } else {
                print('result = $result');
              }
            },
          )),
    );
  }
}
