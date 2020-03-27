import 'package:blacktom/models/user.dart';
import 'package:blacktom/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Casino extends StatefulWidget {
  Casino({this.bgGradient, this.dealerImage, this.casinoName, this.tableMin});

  final LinearGradient bgGradient;
  final String dealerImage;
  final String casinoName;
  final int tableMin;

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
                  Container(),
                  Container()
                ],
              )),
        );
      },
    );
  }
}
