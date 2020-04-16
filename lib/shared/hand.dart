import 'package:flutter/material.dart';

class Hand extends StatefulWidget {
  Hand({this.cards});

  List<dynamic> cards;

  @override
  _HandState createState() => _HandState();
}

class _HandState extends State<Hand> {
  double _nextCardPos = 30.0;
  int _result = 0;
  List<int> _value = [0];
  int _bet = 25;

  List<Positioned> _cardStack() {
    List<Positioned> cardStack = [];
    for (int i = 0; i < widget.cards.length; i++) {
      cardStack.add(Positioned(
        left: _nextCardPos * i,
        child: widget.cards[i],
      ));
    }
    return cardStack;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        Container(
          width: 600,
          padding: EdgeInsets.only(left: 4, right: 4),
          child: Stack(
            children: _cardStack(),
          ),
        )
      ],
    ));
  }
}
