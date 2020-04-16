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
  int curr = 0;
  int _bet;
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

//  void _bank() async {
//    var user = Provider.of<User>(context);
//    await DatabaseService(uid: user.uid).updateUserData(userData.username, userData.chips + 100, userData.level);
//  }

  void _reset() {
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
    for (int i = 0; i < _player.length; i++) {
      if (_player[i]['result'] == 0) {
        if (_player[i]['value'][0] > _dealer['value'][0]) {
          _player[i]['result'] = 1;
        } else if (_player[i]['value'][0] < _dealer['value'][0]) {
          _player[i]['result'] = -1;
        }
      }
    }
    for (int i = 0; i < _player.length; i++) {
      if (_player[i]['result'] == -1) {
        _player[i]['netCash'] -= _bet;
      } else if (_player[i]['result'] == 1) {
        _player[i]['netCash'] += _bet;
      } else if (_player[i]['result'] == 2) {
        _player[i]['netCash'] += (_bet * 1.5);
      }
    }
    _reset();
  }

  void _hit() {
    PlayingCard card = deck[randomCard()];
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
        _player[curr]['result'] = -1;
        curr += 1;
        if (curr == _player.length) {
          dealDealer();
        }
      }
    }
    print('🍑✴️🍑 _player[curr][value] = ${_player[curr]['value']}');
  }

  void dealDealer() {
    while (_dealer.length > 0 && _dealer[0] < 17) {
      PlayingCard card = deck[randomCard()];
      _dealer['cards'].add(card);
      for (int i = 0; i < _dealer['value'].length; i++) {
        _dealer['value'][i] += card.value;
      }
      if (_dealer['value'][0] > 21) {
        _dealer['value'] = _dealer['value'].sublist(1);
        if (_dealer['value'].length < 1) {
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

  // 3) Widgets
  List<Hand> _hands() {
    return new List<Hand>.generate(_player.length, (int index) => Hand(cards: _player[index]['cards']));
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
                children: <Widget>[
                  Container(
                      child: CircleAvatar(
                    radius: MediaQuery.of(context).size.width / 6,
                    backgroundImage: AssetImage(widget.dealerImage),
                  )),
                  Container(
                      child: FlatButton(
                    child: Text('+100 chips', style: GoogleFonts.fenix(color: Colors.white)),
                    onPressed: () async {
                      await DatabaseService(uid: user.uid)
                          .updateUserData(userData.username, userData.chips + 100, userData.level);
                    },
                  )),
                  Container(
                      padding: EdgeInsets.only(left: 4, right: 4),
                      height: 130,
                      child: Row(
                        children: _hands(),
                      )),
                  RaisedButton(
                      child: Text('Hit', style: GoogleFonts.kreon(color: Colors.white, fontSize: 16)),
                      color: Colors.black54,
                      onPressed: () {
                        _hit();
                        setState(() {});
                      })
                ],
              )),
        );
      },
    );
  }
}
