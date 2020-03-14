import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Leaderboard extends StatefulWidget {
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  @override
  Widget build(BuildContext context) {
    final gamblers = Provider.of<QuerySnapshot>(context);
    List<Widget> children = [];

    for (var gambler in gamblers.documents) {
      print(gambler.data);
      children.add(Container(
          height: 75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[Text(gambler.data.toString())],
          )));
    }

    return ListView(children: children);
  }
}
