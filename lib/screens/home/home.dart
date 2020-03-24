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

  List<Widget> casinos = [
    Padding(
        padding: EdgeInsets.all(10),
        child:
            Container(padding: EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.green), child: Text('I am a casino'))),
    Padding(
        padding: EdgeInsets.all(10),
        child: Container(
            padding: EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.deepOrange), child: Text('I am a casino'))),
    Padding(
        padding: EdgeInsets.all(10),
        child: Container(
            padding: EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.blueAccent), child: Text('I am a casino'))),
    Padding(
        padding: EdgeInsets.all(10),
        child: Container(padding: EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.grey), child: Text('I am a casino')))
  ];

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
                  Text('Choose a casino', style: GoogleFonts.oxanium(color: Colors.white, fontSize: 20)),
                  Container(
                      height: 100,
                      child: ListView(scrollDirection: Axis.horizontal, padding: EdgeInsets.all(12), children: casinos)),
                ],
              ))),
          drawer: MainDrawer(),
        ));
  }
}
