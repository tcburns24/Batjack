import 'package:blacktom/shared/palettes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CasinoSlide extends StatelessWidget {
  CasinoSlide({this.tableMin, this.dealer, this.villainColor, this.dealerImage, this.location, this.locationImage});
  final int tableMin;
  final String dealer;
  final String dealerImage;
  final String location;
  final String locationImage;
  final Color villainColor;

  @override
  Widget build(BuildContext context) {
    double eighthWidth = MediaQuery.of(context).size.width / 8;
    return Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Container(
          height: 225,
          width: 225,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              border: Border.all(color: BatmanColors.lightGrey, width: 4.0)),
          child: Stack(
            children: <Widget>[
              // 1st, the image background
              Container(
                height: 225,
                width: 225,
                child: FittedBox(
                  child: Image.asset(locationImage),
                  fit: BoxFit.fill,
                ),
              ),
              // 2nd, the color gradient
              Container(
                height: 225,
                width: 225,
                decoration: BoxDecoration(
                    color: Colors.white,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.grey.withOpacity(0.0), Colors.black],
                    )),
              ),
              Positioned(
                  bottom: 5,
                  width: 225,
                  child: Column(
                    children: <Widget>[
                      Text(
                        location,
                        style: GoogleFonts.adamina(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        dealer,
                        style: GoogleFonts.oxanium(color: BatmanColors.lightGrey, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )),
              Positioned(
                  top: 3,
                  right: 3,
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: villainColor, width: 3.0),
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage(dealerImage),
                    ),
                  ))
            ],
          ),
        ));
  }
}
