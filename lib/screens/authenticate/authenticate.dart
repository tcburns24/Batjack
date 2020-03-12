import 'package:blacktom/screens/authenticate/register.dart';
import 'package:blacktom/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = false;

  void toggleSignIn() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: showSignIn ? SignIn(toggleView: toggleSignIn) : Register(toggleView: toggleSignIn));
  }
}
