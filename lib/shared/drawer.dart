import 'package:blacktom/models/user.dart';
import 'package:blacktom/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'loading.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).gamblerData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Drawer(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(title: Text('Leaderboard'), leading: Icon(Icons.casino)),
                ListTile(title: Text('Sign Out'), leading: Icon(Icons.flight_takeoff)),
              ],
            ));
          } else {
            return Loading();
          }
        });
  }
}
