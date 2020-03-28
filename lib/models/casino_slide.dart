import 'package:blacktom/models/user.dart';
import 'package:blacktom/screens/casino.dart';
import 'package:blacktom/services/database.dart';
import 'package:blacktom/shared/loading.dart';
import 'package:blacktom/shared/palettes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CasinoSlide extends StatelessWidget {
  CasinoSlide(
      {this.tableMin,
      this.dealer,
      this.villainColor,
      this.dealerImage,
      this.location,
      this.locationImage,
      this.bgGradient,
      this.unlockAt});
  final int tableMin;
  final String dealer;
  final String dealerImage;
  final String location;
  final String locationImage;
  final Color villainColor;
  final LinearGradient bgGradient;
  final int unlockAt;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).gamblerData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Casino(
                              dealerImage: dealerImage,
                              casinoName: location,
                              bgGradient: bgGradient,
                              appBarColor: villainColor,
                            ))),
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          border: Border.all(color: villainColor, width: 4.0)),
                      child: Stack(
                        children: <Widget>[
                          // 1st, the image background
                          Container(
                            height: 200,
                            width: 200,
                            child: FittedBox(
                              child: Image.asset(locationImage),
                              fit: BoxFit.fill,
                            ),
                          ),
                          // 2nd, the color gradient
                          Container(
                            height: 200,
                            width: 200,
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
                              width: 200,
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
                              )),
                          Positioned.fill(
                              child: userData.chips > unlockAt
                                  ? Container()
                                  : Container(
                                      color: Colors.black.withOpacity(0.6),
                                      child: Icon(
                                        Icons.lock_outline,
                                        color: Colors.grey,
                                        size: 100,
                                      ),
                                    ))
                        ],
                      ),
                    )));
          } else {
            return Loading(
              bgColor: Colors.black,
              dotColor: BatmanColors.yellow,
            );
          }
        });
  }
}
