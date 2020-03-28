import 'package:blacktom/models/user.dart';
import 'package:blacktom/services/database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Casino extends StatefulWidget {
  Casino({this.bgGradient, this.dealerImage, this.casinoName, this.tableMin, this.appBarColor});

  final LinearGradient bgGradient;
  final String dealerImage;
  final String casinoName;
  final int tableMin;
  final Color appBarColor;

  @override
  _CasinoState createState() => _CasinoState();
}

class _CasinoState extends State<Casino> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).gamblerData,
      builder: (context, snapshot) {
        UserData userData = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.casinoName),
            backgroundColor: widget.appBarColor,
          ),
          body: Container(
              decoration: BoxDecoration(
                gradient: widget.bgGradient,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      child: CircleAvatar(
                    radius: MediaQuery.of(context).size.width / 6,
                    backgroundImage: AssetImage(widget.dealerImage),
                  )),
                  Container(
                      child: FlatButton(
                    child: Text('+100 chips', style: GoogleFonts.fenix(color: Colors.white)),
                    onPressed: () async {
                      await DatabaseService(uid: user.uid)
                          .updateUserData(userData.username, userData.chips + 100, userData.level);
                    },
                  )),
                  Container()
                ],
              )),
        );
      },
    );
  }
}
