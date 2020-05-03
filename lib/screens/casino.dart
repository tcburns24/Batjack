import 'dart:math';

import 'package:blacktom/models/user.dart';
import 'package:blacktom/services/database.dart';
import 'package:blacktom/shared/deck.dart';
import 'package:blacktom/shared/hand.dart';
import 'package:blacktom/shared/palettes.dart';
import 'package:blacktom/shared/playing_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  TextEditingController _tff = new TextEditingController();
  bool _tffEnabled = true;
  bool _gameInSession = false;
  bool _hitBtnEnabled = true;
  bool _canSplit = false;
  int curr = 0;
  double _bet = 25;
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

  Map<int, Map<String, dynamic>> _handResults = {
    -1: {'text': 'Lose', 'color': BatmanColors.red},
    0: {'text': '0', 'color': Colors.white},
    1: {'text': 'Win', 'color': BatmanColors.green},
    2: {'text': 'Batjack!', 'color': BatmanColors.green},
    3: {'text': 'Push', 'color': BatmanColors.lightGrey}
  };

  void _reset() {
    print('🦒🦒_reset() called.');
    _hitBtnEnabled = true;
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

  Future _bank(BuildContext context) async {
    var user = Provider.of<User>(context, listen: false);
    double currentCash;
    await Firestore.instance.collection('gamblers').document(user.uid).get().then((doc) => currentCash = doc.data['chips']);
    print('💎💎 currentCash starts as ${currentCash}');

    print('🐉🐲🐉 _bank called.');
    for (int i = 0; i < _player.length; i++) {
      if (_player[i]['result'] == 0) {
        if (_player[i]['value'][0] > _dealer['value'][0]) {
          print('🤑 _player (${_player[i]['value'][0]}) > _dealer (${_dealer['value'][0]}). Player wins.');
          _player[i]['result'] = 1;
        } else if (_player[i]['value'][0] < _dealer['value'][0]) {
          print('🤑 _player (${_player[i]['value'][0]}) < _dealer (${_dealer['value'][0]}). Dealer wins.');
          _player[i]['result'] = -1;
        } else {
          _player[i]['result'] = 3;
        }
      }
    }
    for (int i = 0; i < _player.length; i++) {
      print('🐉 i = $i');
      if (_player[i]['result'] == -1) {
        currentCash -= _bet;
        print('🤑 _player loses ${_player[i]['netCash']}');
      } else if (_player[i]['result'] == 1) {
        print('🤑 _player wins ${_player[i]['netCash']}');
        currentCash += _bet;
      } else if (_player[i]['result'] == 2) {
        currentCash += (_bet * 2);
      }
      print('🌝🌚 now currentCash = ${currentCash}');
    }
    _gameInSession = false;
    await Firestore.instance.collection('gamblers').document(user.uid).updateData({'chips': currentCash});
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
        } else {
          _player[i]['result'] = 3;
        }
      }
    }

    for (int i = 0; i < _player.length; i++) {
      print('🐉🐲 i = $i');
      if (_player[i]['result'] == -1) {
        _player[i]['netCash'] -= _bet;
        print('🤑 _player loses ${_player[i]['netCash']}');
      } else if (_player[i]['result'] == 1) {
        print('🤑 _player wins ${_player[i]['netCash']}');
        _player[i]['netCash'] += _bet;
      } else if (_player[i]['result'] == 2) {
        _player[i]['netCash'] += (_bet * 1.5);
      }
      print('🌝🌚_banking ${_player[i]['netCash']}');
    }
    _gameInSession = false;
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
          _hitBtnEnabled = false;
          _gameInSession = false;
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

    // Check if gambler was dealt a blackjack
    if ((_player[curr]['cards'][0].isAce && _player[curr]['cards'][1].isTen) ||
        (_player[curr]['cards'][1].isAce && _player[curr]['cards'][0].isTen)) {
      _player[curr]['result'] = 2;
      _hitBtnEnabled = false;
      _gameInSession = false;
    }

    // Check if gambler can split()
    if (_player[curr]['cards'][0].value == _player[curr]['cards'][1].value) {
      _canSplit = true;
    }
  }

  void _stand() {
    curr += 1;
    if (curr == _player.length) {
      dealDealer();
    }
    if (curr == _player.length) {
      _hitBtnEnabled = false;
      _gameInSession = false;
    }
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
    _bank(context);
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
    _canSplit = false;
  }

  // 3) Widgets
  List<Hand> _hands() {
    return new List<Hand>.generate(_player.length, (int index) => Hand(cards: _player[index]['cards']));
  }

  List<Widget> _handScore() {
    return new List<Widget>.generate(
        _player.length,
        (int index) => Container(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(_gameInSession ? '${_player[index]['value'][0]}' : '${_handResults[_player[index]['result']]['text']}',
                style: GoogleFonts.ultra(
                    fontSize: 24,
                    color: _handResults[_player[index]['result']]['color'],
                    decoration: index == curr ? TextDecoration.underline : TextDecoration.none))));
  }

  List<Hand> _dealerHands() {
    return new List<Hand>.generate(1, (int index) => Hand(cards: _dealer['cards']));
  }

  Widget _playerCommand() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Icon(Icons.monetization_on, color: BatmanColors.darkGrey, size: 18),
            ),
            Expanded(
                child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.red[700],
                  inactiveTrackColor: Colors.red[100],
                  trackShape: RoundedRectSliderTrackShape(),
                  trackHeight: 4.0,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                  thumbColor: Colors.redAccent,
                  overlayColor: Colors.red.withAlpha(32),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                  tickMarkShape: RoundSliderTickMarkShape(),
                  activeTickMarkColor: Colors.red[700],
                  inactiveTickMarkColor: Colors.red[100],
                  valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                  valueIndicatorColor: Colors.redAccent,
                  valueIndicatorTextStyle: TextStyle(
                    color: Colors.white,
                  )),
              child: Slider.adaptive(
                  value: _bet,
                  onChanged: (newBet) {
                    setState(() {
                      _bet = newBet;
                    });
                  },
                  divisions: ((200 - 25) / 5).floor(),
                  label: '$_bet',
                  min: 25,
                  max: 200),
            ))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
                child: Text(_gameInSession ? 'Hit' : 'Deal', style: GoogleFonts.kreon(color: Colors.white, fontSize: 16)),
                color: Colors.black54,
                onPressed: () {
                  _hitBtnEnabled ? (_gameInSession ? _hit() : _beginPlay()) : null;
                  setState(() {});
                })
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: RaisedButton(
                  child: Text('Split', style: GoogleFonts.kreon(color: Colors.white, fontSize: 16)),
                  color: Colors.black54,
                  onPressed: () {
                    _canSplit
                        ? setState(() {
                            _split();
                          })
                        : null;
                  }),
            ),
            Container(
              width: 125,
              height: 45,
//                padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
              child: TextFormField(
                enabled: !_gameInSession,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.attach_money,
                    color: BatmanColors.darkGrey,
                  ),
                  hintText: '${_bet.floor()}',
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)), borderSide: BorderSide(color: BatmanColors.yellow)),
                ),
                style: GoogleFonts.geo(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
                showCursor: false,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: RaisedButton(
                  child: Text('Double', style: GoogleFonts.kreon(color: Colors.white, fontSize: 16)),
                  color: Colors.black54,
                  onPressed: () {}),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
                child: Text(_gameInSession ? 'Stand' : 'Play Again', style: GoogleFonts.kreon(color: Colors.white, fontSize: 16)),
                color: Colors.black54,
                onPressed: () {
                  setState(() {
                    _gameInSession ? _stand() : _reset();
                  });
                })
          ],
        ),
      ],
    );
  }

  Widget _dealerSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 115,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 6,
                right: 8,
                child: CircleAvatar(
                  radius: 48,
                  backgroundImage: AssetImage(widget.dealerImage),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  height: 110,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _dealerHands(),
                  ),
                ),
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _dealer['value'].length > 0 ? '${_dealer['value'][0]}' : 'Bust',
              style: GoogleFonts.ultra(fontSize: 24, color: Colors.white),
            )
          ],
        )
      ],
    );
  }

  Widget _playerSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 4, right: 4),
            height: 120,
            child: Row(
              children: _hands(),
            )),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: _handScore()),
      ],
    );
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
              padding: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                gradient: widget.bgGradient,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: _dealerSection(),
                  ),
                  Expanded(
                    child: _playerSection(),
                  ),
                  Expanded(
                    child: _playerCommand(),
                  )
//                  Column(
//                    mainAxisAlignment: MainAxisAlignment.start,
//                    children: <Widget>[
//                      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: _handScore()),
//                      Container(
//                          padding: EdgeInsets.only(left: 4, right: 4),
//                          height: 120,
//                          child: Row(
//                            children: _hands(),
//                          )),
//                      _playerCommand()
//                    ],
//                  ),
                ],
              )),
        );
      },
    );
  }
}
