import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayingCard extends StatefulWidget {
  PlayingCard({
    required this.value,
    required this.number,
    required this.suit,
    required this.isTen,
    required this.isAce});
  final int value;
  final String number;
  final String suit;
  final bool isTen;
  final bool isAce;

  @override
  _PlayingCardState createState() => _PlayingCardState();
}

class _PlayingCardState extends State<PlayingCard> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

//  this will start the animation
    controller.forward();
  }

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
    return FadeTransition(
      opacity: animation,
      child: Container(
        height: 100,
        width: 71,
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8.0)), border: Border.all(color: Colors.black, width: 2.0), color: Colors.white),
        child: Stack(
          children: <Widget>[
            Positioned(
                top: 5,
                left: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.number.toUpperCase(),
                      style: GoogleFonts.livvic(color: widget.suit == 'hearts' || widget.suit == 'diamonds' ? Colors.red : Colors.black, fontWeight: FontWeight.w600, fontSize: 22),
                    ),
                    Text(_suitIcon(widget.suit), style: TextStyle(fontSize: 20))
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
