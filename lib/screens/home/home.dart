import 'package:blacktom/models/user.dart';
import 'package:blacktom/services/auth.dart';
import 'package:blacktom/services/database.dart';
import 'package:blacktom/shared/drawer.dart';
import 'package:blacktom/shared/palettes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthService _auth = new AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamProvider<QuerySnapshot>.value(
        value: DatabaseService().gamblers,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: BatmanColors.blueGrey,
            title: Text('Batjack'),
            elevation: 0.8,
            actions: <Widget>[
              FlatButton.icon(
                onPressed: () async {
                  await _auth.signOut();
                },
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(
                  'sign out',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
            ],
          ),
          body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/wallpapers/bg1.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Home Screen',
                    style: GoogleFonts.oxanium(color: BatmanColors.yellow),
                  ),
                  Text(
                    'Batman',
                    style: GoogleFonts.oxanium(color: BatmanColors.yellow),
                  ),
                  Text(
                    'Batman',
                    style: GoogleFonts.oxanium(color: BatmanColors.yellow),
                  ),
                ],
              ))),
          drawer: MainDrawer(),
        ));
  }
}
