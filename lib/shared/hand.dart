import 'dart:math';

import 'package:blacktom/shared/playing_card.dart';
import 'package:flutter/material.dart';

import 'deck.dart';

class Hand extends StatefulWidget {
  @override
  _HandState createState() => _HandState();

  _HandState handstate = new _HandState();

  addCard() {
    print('🍷🍷 _addThenSet() called');
    handstate._addCard();
  }
}

class _HandState extends State<Hand> {
  double _nextCardPos = 30.0;
  List<Widget> _cards = [
    Positioned(
      left: 0.0,
      child: deck[19],
    ),
  ];
  int _result = 0;
  List<int> _value = [0];
  int _bet = 25;

  _randomCard() {
    return Random().nextInt(deck.length);
  }

  void _addCard() {
    PlayingCard card = deck[_randomCard()];
    print('🍷_addCard() called\n🍷card = $card');
    _cards.add(Positioned(
      left: _nextCardPos,
      child: card,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        GestureDetector(
            onTap: () {
              setState(() {
                _addCard();
                _nextCardPos += 30.0;
              });
            },
            child: Container(
              width: 600,
              padding: EdgeInsets.only(left: 4, right: 4),
              child: Stack(
                children: _cards,
              ),
            ))
      ],
    ));
  }
}
