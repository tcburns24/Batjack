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
    'tableMin': 10,
    'bgGradient': LinearGradient(colors: [Colors.blue[900], Colors.blueGrey[600]])
  },
  {
    'location': 'The Batcave',
    'locationImage': 'assets/casino_slides/batcave.png',
    'dealer': 'Bane',
    'dealerImage': 'assets/dealers/bane.jpg',
    'villainColor': Colors.brown[700],
    'tableMin': 25,
    'bgGradient': LinearGradient(colors: [Colors.brown[900], Colors.brown[600]]),
  },
  {
    'location': 'Arkham Asylum',
    'locationImage': 'assets/casino_slides/arkham_asylum.jpg',
    'dealerImage': 'assets/dealers/scarecrow.jpg',
    'dealer': 'Scarecrow',
    'villainColor': Colors.brown[300],
    'tableMin': 15,
    'bgGradient': LinearGradient(colors: [Colors.brown[400], Colors.grey[600]]),
  },
  {
    'location': 'Iceberg Lounge',
    'locationImage': 'assets/casino_slides/iceberg_lounge.jpg',
    'dealerImage': 'assets/dealers/penguin.png',
    'dealer': 'Penguin',
    'villainColor': Colors.lightBlue[200],
    'tableMin': 50,
    'bgGradient': LinearGradient(colors: [Colors.lightBlue[600], Colors.lightBlue[300]]),
  },
  {
    'location': 'Ace Chemicals',
    'locationImage': 'assets/casino_slides/ace_chemicals.jpg',
    'dealer': 'Joker',
    'dealerImage': 'assets/dealers/joker.jpg',
    'villainColor': BatmanColors.jokerGreen,
    'tableMin': 100,
    'bgGradient': LinearGradient(colors: [BatmanColors.jokerGreen, BatmanColors.jokerPurple]),
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
    ));
  }
  return allCasinos;
}
