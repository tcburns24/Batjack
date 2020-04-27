import 'dart:math';

import 'package:blacktom/models/user.dart';
import 'package:blacktom/services/database.dart';
import 'package:blacktom/shared/deck.dart';
import 'package:blacktom/shared/hand.dart';
import 'package:blacktom/shared/playing_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Casino extends StatefulWidget {
  Casino({this.bgGradient, this.dealerImage, this.casinoName, this.tableMin, this.appBarColor});

  final LinearGradient bgGradient;
  final String dealerImage;
  final String casinoName;
  final int tableMin;
  final Color appBarColor;

  @override
  _CasinoState createState() => _CasinoState();
}

class _CasinoState extends State<Casino> {
  // 1) State
  bool _gameInSession = false;
  bool _standBtnDisabled = true;
  bool _canSplit = true;
  int curr = 0;
  int _bet = 25;
  List<Map<dynamic, dynamic>> _player = [
    {
      'cards': [],
      'value': [0],
      'result': 0,
      'netCash': 0
    }
  ];

  Map<String, dynamic> _dealer = {
    'cards': [],
    'value': [0],
  };

  // 2) Methods
  int randomCard() {
    return Random().nextInt(deck.length);
  }

  Map<int, String> _handResults = {-1: 'You Lose, Batman', 0: 'Push', 1: 'You Win, Batman', 2: 'Batjack!'};

//  void _bank() async {
//    var user = Provider.of<User>(context);
//    await DatabaseService(uid: user.uid).updateUserData(userData.username, userData.chips + 100, userData.level);
//  }

  void _reset() {
    print('🦒🦒_reset() called.');
    curr = 0;
    _player = [
      {
        'cards': [],
        'value': [0],
        'result': 0,
        'netCash': 0
      }
    ];
    _dealer = {
      'cards': [],
      'value': [0],
    };
  }

  void _evaluate() {
    print('🐉🐲 _evaluate() called.');
    for (int i = 0; i < _player.length; i++) {
      if (_player[i]['result'] == 0) {
        if (_player[i]['value'][0] > _dealer['value'][0]) {
          print('🤑 _player (${_player[i]['value'][0]}) > _dealer (${_dealer['value'][0]}). Player wins.');
          _player[i]['result'] = 1;
        } else if (_player[i]['value'][0] < _dealer['value'][0]) {
          print('🤑 _player (${_player[i]['value'][0]}) < _dealer (${_dealer['value'][0]}). Dealer wins.');
          _player[i]['result'] = -1;
        }
      }
    }
    for (int i = 0; i < _player.length; i++) {
      if (_player[i]['result'] == -1) {
        _player[i]['netCash'] -= _bet;
        print('🤑 _player loses ${_player[i]['netCash']}');
      } else if (_player[i]['result'] == 1) {
        print('🤑 _player wins ${_player[i]['netCash']}');
        _player[i]['netCash'] += _bet;
      } else if (_player[i]['result'] == 2) {
        _player[i]['netCash'] += (_bet * 1.5);
      }
    }
    _gameInSession = false;
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _reset();
      });
    });
  }

  void _hit() {
    PlayingCard card = deck[randomCard()];
    print('\n=====\n♦️♥️ card = ${card.number} ${card.suit}');
    _player[curr]['cards'].add(card);
    for (int i = 0; i < _player[curr]['value'].length; i++) {
      _player[curr]['value'][i] += card.value;
    }
    if (card.isAce) {
      _player[curr]['value'].add(_player[curr]['value'][_player[curr]['value'].length - 1] - 10);
    }
    if (_player[curr]['value'][0] > 21) {
      _player[curr]['value'] = _player[curr]['value'].sublist(1);
      if (_player[curr]['value'].length < 1) {
        print('️♥️ player busted (curr = $curr');
        _player[curr]['result'] = -1;
        curr += 1;
        if (curr == _player.length) {
          dealDealer();
        }
      }
    } else {
      print('🍑✴️🍑 _player[curr][value] = ${_player[curr]['value']}\n-------');
    }
  }

  void _beginPlay() {
    _gameInSession = true;
    PlayingCard card = deck[randomCard()];
    _dealer['cards'].add(card);
    for (int i = 0; i < _dealer['value'].length; i++) {
      _dealer['value'][i] += card.value;
    }
    _hit();
    _hit();
    if ((_player[curr]['cards'][0].isAce && _player[curr]['cards'][1].isTen) ||
        (_player[curr]['cards'][1].isAce && _player[curr]['cards'][0].isTen)) {
      _player[curr]['result'] = 2;
    }
    _standBtnDisabled = false;
  }

  void _stand() {
    curr += 1;
    if (curr == _player.length) {
      dealDealer();
    }
    if (curr == _player.length) {
      _standBtnDisabled = true;
    }
    print('❇️ after _stand(), curr = $curr, _standBtnDisabled == $_standBtnDisabled');
  }

  void dealDealer() {
    while (_dealer['value'].length > 0 && _dealer['value'][0] < 17) {
      PlayingCard card = deck[randomCard()];
      print('🦌🦌 Dealer: card = ${card.suit} ${card.number}');
      _dealer['cards'].add(card);
      for (int i = 0; i < _dealer['value'].length; i++) {
        _dealer['value'][i] += card.value;
      }
      if (_dealer['value'][0] > 21) {
        _dealer['value'] = _dealer['value'].sublist(1);
        if (_dealer['value'].length < 1) {
          print('️️🍑️ dealer busted');
          for (int i = 0; i < _player.length; i++) {
            if (_player[i]['result'] == 0) {
              _player[i]['result'] = 1;
            }
          }
        }
      }
    }
    _evaluate();
  }

  void _split() {
    PlayingCard splitCard = _player[0]['cards'][1];
    for (int i = 0; i < _player[0]['value'].length; i++) {
      _player[0]['value'][i] -= splitCard.value;
    }
    _player.add({
      'cards': [splitCard],
      'value': [splitCard.value],
      'result': 0,
      'netCash': 0
    });
    _player[0]['cards'] = _player[0]['cards'].sublist(0, 1);
  }

  // 3) Widgets
  List<Hand> _hands() {
    return new List<Hand>.generate(_player.length, (int index) => Hand(cards: _player[index]['cards']));
  }

  List<Widget> _handScore() {
    return new List<Widget>.generate(
        _player.length,
        (int index) => Container(
              child: Text(_player[index]['value'].length > 0 ? '${_player[index]['value'][0]}' : 'Bust',
                  style: GoogleFonts.ultra(
                      fontSize: 24,
                      color:
                          curr < _player.length ? Colors.white : _player[curr - 1]['netCash'] < 0 ? Colors.red : Colors.green)),
            ));
  }

  List<Hand> _dealerHands() {
    return new List<Hand>.generate(1, (int index) => Hand(cards: _dealer['cards']));
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).gamblerData,
      builder: (context, snapshot) {
        UserData userData = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.casinoName),
            backgroundColor: widget.appBarColor,
          ),
          body: Container(
              decoration: BoxDecoration(
                gradient: widget.bgGradient,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      child: CircleAvatar(
                    radius: MediaQuery.of(context).size.width / 7,
                    backgroundImage: AssetImage(widget.dealerImage),
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        _dealer['value'].length > 0 ? '${_dealer['value'][0]}' : 'Bust',
                        style: GoogleFonts.ultra(fontSize: 24, color: Colors.white),
                      )
                    ],
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 4, right: 4),
                      height: 130,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _dealerHands(),
                      )),
                  Container(
                      child: FlatButton(
                    child: Text('+100 chips', style: GoogleFonts.fenix(color: Colors.white)),
                    onPressed: () async {
                      await DatabaseService(uid: user.uid)
                          .updateUserData(userData.username, userData.chips + 100, userData.level);
                    },
                  )),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(left: 4, right: 4),
                          height: 100,
                          child: Row(
                            children: _hands(),
                          )),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: _handScore()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RaisedButton(
                              child: Text(_gameInSession ? 'Hit' : 'Deal',
                                  style: GoogleFonts.kreon(color: Colors.white, fontSize: 16)),
                              color: Colors.black54,
                              onPressed: () {
                                _gameInSession ? _hit() : _beginPlay();
                                setState(() {});
                              }),
                          RaisedButton(
                              child: Text('Stand', style: GoogleFonts.kreon(color: Colors.white, fontSize: 16)),
                              color: Colors.black54,
                              onPressed: () {
                                !_standBtnDisabled
                                    ? setState(() {
                                        _stand();
                                      })
                                    : null;
                              }),
                          RaisedButton(
                              child: Text('Split', style: GoogleFonts.kreon(color: Colors.white, fontSize: 16)),
                              color: Colors.black54,
                              onPressed: () {
                                _canSplit
                                    ? setState(() {
                                        _split();
                                      })
                                    : null;
                              })
                        ],
                      )
                    ],
                  ),
                ],
              )),
        );
      },
    );
  }
}
