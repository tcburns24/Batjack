import 'package:blacktom/screens/home/leaderboard.dart';
import 'package:blacktom/services/auth.dart';
import 'package:blacktom/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthService _auth = new AuthService();
  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot>.value(
        value: DatabaseService().gamblers,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.red[800],
            title: Text('Welcome to Blacktom'),
            elevation: 0.8,
            actions: <Widget>[
              FlatButton.icon(
                  onPressed: () async {
                    await _auth.signOut();
                  },
                  icon: Icon(
                    Icons.person,
                  ),
                  label: Text('Sign out'))
            ],
          ),
          body: Container(
              child: Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
            child: Container(
              child: Leaderboard(),
            ),
          )),
        ));
  }
}
