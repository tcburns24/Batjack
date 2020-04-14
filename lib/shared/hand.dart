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
    handstate._addThenSet();
  }
}

class _HandState extends State<Hand> {
  double _nextCardPos = 30.0;
  List<Widget> _cards = [
    Positioned(
      left: 0.0,
      child: deck[11],
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

  _addThenSet() {
    _addCard();
    _nextCardPos += 30;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
          onTap: () {
            setState(() {
              _addCard();
              _nextCardPos += 30.0;
            });
          },
          child: Stack(children: _cards)),
    );
  }
}
