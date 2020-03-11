import 'package:blacktom/models/user.dart';
import 'package:blacktom/screens/authenticate/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user);
    // Navigate to Home screen if user is signed in, otherwise authenticate user
    return user == null ? Authenticate() : Home();
  }
}
