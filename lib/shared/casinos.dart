import 'package:blacktom/models/casino_slide.dart';
import 'package:blacktom/shared/palettes.dart';
import 'package:flutter/material.dart';

List<Map<String, dynamic>> casinos = [
  {
    'location': 'Gotham City PD',
    'locationImage': 'assets/casino_slides/gcpd.png',
    'dealerImage': 'assets/dealers/commissioner_gordon.jpg',
    'dealer': 'Commissioner Gordon',
    'villainColor': Colors.blue[900],
    'tableMin': 15,
    'tableMax': 200,
    'bgGradient':
        LinearGradient(colors: [Colors.blue[100], Colors.blueGrey[600]], begin: Alignment.topCenter, end: Alignment.bottomCenter),
    'unlockAt': 0,
  },
  {
    'location': 'The Batcave',
    'locationImage': 'assets/casino_slides/batcave.png',
    'dealer': 'Bane',
    'dealerImage': 'assets/dealers/bane.jpg',
    'villainColor': Colors.brown[700],
    'tableMin': 25,
    'tableMax': 350,
    'bgGradient':
        LinearGradient(colors: [Colors.brown[400], Colors.brown[100]], begin: Alignment.topCenter, end: Alignment.bottomCenter),
    'unlockAt': 200,
  },
  {
    'location': 'Arkham Asylum',
    'locationImage': 'assets/casino_slides/arkham_asylum.jpg',
    'dealerImage': 'assets/dealers/scarecrow.jpg',
    'dealer': 'Scarecrow',
    'villainColor': Color(0xffa6997e),
    'tableMin': 35,
    'tableMax': 500,
    'bgGradient':
        LinearGradient(colors: [Colors.brown[300], Colors.grey[500]], begin: Alignment.topCenter, end: Alignment.bottomCenter),
    'unlockAt': 300,
  },
  {
    'location': 'Iceberg Lounge',
    'locationImage': 'assets/casino_slides/iceberg_lounge.jpg',
    'dealerImage': 'assets/dealers/penguin.png',
    'dealer': 'Penguin',
    'villainColor': Colors.lightBlue[900],
    'tableMin': 50,
    'tableMax': 750,
    'bgGradient': LinearGradient(
        colors: [Colors.lightBlue[400], Colors.lightBlue[100]], begin: Alignment.topCenter, end: Alignment.bottomCenter),
    'unlockAt': 400,
  },
  {
    'location': 'Ace Chemicals',
    'locationImage': 'assets/casino_slides/ace_chemicals.jpg',
    'dealer': 'Joker',
    'dealerImage': 'assets/dealers/joker.jpg',
    'villainColor': BatmanColors.jokerGreen,
    'tableMin': 75,
    'tableMax': 1000,
    'bgGradient': LinearGradient(
        colors: [BatmanColors.jokerPurple, BatmanColors.jokerGreen], begin: Alignment.topLeft, end: Alignment.bottomRight),
    'unlockAt': 500,
  }
];

List<Widget> allCasinos() {
  List<CasinoSlide> allCasinos = [];
  for (var i = 0; i < casinos.length; i++) {
    allCasinos.add(CasinoSlide(
      location: casinos[i]['location'],
      locationImage: casinos[i]['locationImage'],
      dealer: casinos[i]['dealer'],
      dealerImage: casinos[i]['dealerImage'],
      villainColor: casinos[i]['villainColor'],
      tableMin: casinos[i]['tableMin'],
      tableMax: casinos[i]['tableMax'],
      bgGradient: casinos[i]['bgGradient'],
      unlockAt: casinos[i]['unlockAt'],
    ));
  }
  return allCasinos;
}
