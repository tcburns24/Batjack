import 'package:blacktom/screens/authenticate/authenticate.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Navigate to Home screen if user is signed in, otherwise authenticate user
    return Authenticate();
  }
}
