import 'package:blacktom/shared/palettes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CasinoSlide extends StatelessWidget {
  CasinoSlide({this.tableMin, this.villainDealer, this.villainImage, this.location, this.locationImage});
  final int tableMin;
  final String villainDealer;
  final String villainImage;
  final String location;
  final String locationImage;

  @override
  Widget build(BuildContext context) {
    double eighthWidth = MediaQuery.of(context).size.width / 8;
    return Padding(
        padding: EdgeInsets.fromLTRB(eighthWidth, 8, eighthWidth, 8),
        child: Container(
//          width: MediaQuery.of(context).size.width / 2,
//          height: MediaQuery.of(context).size.width / 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            border: Border.all(color: BatmanColors.lightGrey, width: 3.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/wallpapers/bg1.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(child: Text(location, style: GoogleFonts.oxanium(fontSize: 24))),
                  Container(child: Text(villainDealer, style: GoogleFonts.oxanium(fontSize: 14)))
                ],
              ),
            ],
          ),
        ));
  }
}
