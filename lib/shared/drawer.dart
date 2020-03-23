import 'package:blacktom/models/user.dart';
import 'package:blacktom/screens/home/leaderboard.dart';
import 'package:blacktom/services/auth.dart';
import 'package:blacktom/services/database.dart';
import 'package:blacktom/shared/palettes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'loading.dart';

class MainDrawer extends StatelessWidget {
  AuthService _auth = new AuthService();

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
                    padding: EdgeInsets.symmetric(vertical: statusBar, horizontal: 16),
                    color: BatmanColors.jokerPurple,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(top: 16, bottom: 4),
                            child: Text(userData.username,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Avenir', color: Colors.white))),
                        Container(
                            padding: EdgeInsets.only(top: 12),
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
                GestureDetector(
                  child: ListTile(title: Text('Leaderboard'), leading: Icon(Icons.casino)),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Leaderboard()));
                  },
                ),
                GestureDetector(
                  child: ListTile(title: Text('Sign Out'), leading: Icon(Icons.flight_takeoff)),
                  onTap: () => _auth.signOut(),
                ),
              ],
            ));
          } else {
            return Loading();
          }
        });
  }
}
