import 'package:blacktom/models/user.dart';
import 'package:blacktom/services/database.dart';
import 'package:blacktom/shared/assets/palettes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'loading.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double statusBar = MediaQuery.of(context).padding.top;
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).gamblerData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Drawer(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.symmetric(vertical: statusBar * 2, horizontal: 15),
                    color: CasinoColors.purple,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(top: 4, bottom: 4),
                            child: Text(userData.username,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Avenir', color: Colors.white))),
                        Container(
                            padding: EdgeInsets.only(top: 4, bottom: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  Icons.monetization_on,
                                  color: Colors.white,
                                ),
                                Text(' Chips: ${userData.chips}  |   Level: ${userData.level}',
                                    style: TextStyle(fontSize: 14, fontFamily: 'Avenir', color: Colors.white)),
                              ],
                            ))
                      ],
                    )),
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
