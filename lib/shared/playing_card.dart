import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayingCard extends StatelessWidget {
  PlayingCard({this.value, this.number, this.suit, this.isTen, this.isAce});
  final int value;
  final String number;
  final String suit;
  final bool isTen;
  final bool isAce;

  String _suitIcon(String suit) {
    switch (suit) {
      case 'spades':
        {
          return '♠️';
        }
        break;

      case 'clubs':
        {
          return '♣️';
        }
        break;

      case 'hearts':
        {
          return '♥️';
        }
        break;

      default:
        {
          return '♦️';
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 71,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          border: Border.all(color: Colors.black, width: 2.0),
          color: Colors.white),
      child: Stack(
        children: <Widget>[
          Positioned(
              top: 5,
              left: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    number.toUpperCase(),
                    style: GoogleFonts.oxanium(
                        color: suit == 'hearts' || suit == 'diamonds' ? Colors.red : Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 22),
                  ),
                  Text(_suitIcon(suit), style: TextStyle(fontSize: 20))
                ],
              ))
        ],
      ),
    );
  }
}
