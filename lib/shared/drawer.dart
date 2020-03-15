import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(title: Text('Leaderboard'), leading: Icon(Icons.casino)),
        ListTile(title: Text('Sign Out'), leading: Icon(Icons.flight_takeoff)),
      ],
    ));
  }
}
