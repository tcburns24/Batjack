import 'package:blacktom/models/user.dart';
import 'package:blacktom/services/auth.dart';
import 'package:blacktom/services/database.dart';
import 'package:blacktom/shared/casinos.dart';
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
    num batLogoWidth = MediaQuery.of(context).size.width / 2;
    num batLogoHeight = batLogoWidth * 0.6;
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
                    Icons.flight_takeoff,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Sign out',
                    style: GoogleFonts.oxanium(color: Colors.white),
                  ))
            ],
          ),
          body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/wallpapers/home.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 12.0, bottom: 20),
                      child: Image.asset(
                        'assets/batman_logos/white.png',
                        width: batLogoWidth / 1.7,
                        height: batLogoHeight / 1.7,
                      )),
                  Padding(padding: EdgeInsets.only(bottom: 16), child: Text('Choose a casino', style: GoogleFonts.oxanium(color: Colors.white, fontSize: 20))),
                  Container(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: allCasinos(),
                      )),
                ],
              ))),
          drawer: MainDrawer(),
        ));
  }
}
