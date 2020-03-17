import 'package:blacktom/services/database.dart';
import 'package:blacktom/shared/assets/palettes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Leaderboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gamblers = Provider.of<QuerySnapshot>(context);
    List<Widget> children = [];

    for (var gambler in gamblers.documents) {
      children.add(Container(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[Text(gambler.data.toString())],
        ),
      ));
    }
    return StreamProvider<QuerySnapshot>.value(
      value: DatabaseService().gamblers,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: CasinoColors.burnt,
            title: Text('Blacktom Leaderboard'),
            elevation: 0.8,
            actions: <Widget>[FlatButton.icon(onPressed: () {}, icon: Icon(Icons.chevron_left), label: Text('Back'))],
          ),
          body: ListView(children: children)),
    );
  }
}
