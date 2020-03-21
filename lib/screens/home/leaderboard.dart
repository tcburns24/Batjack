import 'package:blacktom/shared/assets/palettes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Leaderboard extends StatefulWidget {
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  ListView _allDocs(List arr) {
    return ListView.builder(
        itemCount: arr.length,
        itemBuilder: (context, index) => Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[Text(arr[index].data['username'].toString())],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CasinoColors.grey,
        title: Text('Leaderboard'),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('gamblers').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _allDocs(snapshot.data.documents);
          }
        },
      ),
    );
  }
}
