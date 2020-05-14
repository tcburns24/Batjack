import 'dart:math';

import 'package:blacktom/models/bat_button.dart';
import 'package:blacktom/models/user.dart';
import 'package:blacktom/services/database.dart';
import 'package:blacktom/shared/deck.dart';
import 'package:blacktom/shared/hand.dart';
import 'package:blacktom/shared/palettes.dart';
import 'package:blacktom/shared/playing_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Casino extends StatefulWidget {
  Casino({this.bgGradient, this.dealerImage, this.casinoName, this.tableMin, this.tableMax, this.appBarColor});

  final LinearGradient bgGradient;
  final String dealerImage;
  final String casinoName;
  final int tableMin;
  final int tableMax;
  final Color appBarColor;

  @override
  _CasinoState createState() => _CasinoState();
}

class _CasinoState extends State<Casino> {
  // 1) State
  int _playerCash;
  bool _gameInSession = false;
  bool _hitBtnEnabled = true;
  bool _canSplit = false;
  int curr = 0;
  double _bet = 25.0;
  List<Map<dynamic, dynamic>> _player = [
    {
      'cards': [],
      'value': [0],
      'result': 0,
      'handBet': 0,
      'canDouble': true,
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

  void _getUserChips() async {
    var user = Provider.of<User>(context, listen: false);
    await Firestore.instance.collection('gamblers').document(user.uid).get().then((doc) => _playerCash = doc.data['chips']);
    print('❎❎🥃_playerCAsh = $_playerCash');
  }

  @override
  void initState() {
    super.initState();
    _bet = widget.tableMin.toDouble();
    _getUserChips();
  }

  void _reset() {
    print('🦒🦒_reset() called.');
    _hitBtnEnabled = true;
    curr = 0;
    _player = [
      {
        'cards': [],
        'value': [0],
        'result': 0,
        'handBet': 0
      }
    ];
    _dealer = {
      'cards': [],
      'value': [0],
    };
  }

  Future _bank(BuildContext context) async {
    var user = Provider.of<User>(context, listen: false);

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
      print('\n🐉🐉 i = $i\n🐉 _player[$i][result] == ${_player[i]['result']}\n🐉 _player[$i][handBet] == ${_player[i]['handBet']}');
      // if push, give player their $ back.
      if (_player[i]['result'] == 3) {
        _playerCash += _player[i]['handBet'];
        // if player wins, give them their $ plus $.
      } else if (_player[i]['result'] == 1) {
        _playerCash += _player[i]['handBet'] * 2;
        // if player gets batjack, give them their money back plus $ x 2.
      } else if (_player[i]['result'] == 2) {
        _playerCash += _player[i]['handBet'] * 3;
      }
    }
    _gameInSession = false;
    await Firestore.instance.collection('gamblers').document(user.uid).updateData({'chips': _playerCash});
    print('🐲🐉🐲 _bank done.');
  }

  void _hit() {
    HapticFeedback.vibrate();
    _player[curr]['canDouble'] = false;
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
        print('️♥️ player busted (curr = $curr)');
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
    _playerCash -= _bet.floor();
    PlayingCard card = deck[randomCard()];
    _dealer['cards'].add(card);
    for (int i = 0; i < _dealer['value'].length; i++) {
      _dealer['value'][i] += card.value;
    }
    _player[curr]['handBet'] = _bet.floor();
    _hit();
    _hit();

    // Check if gambler was dealt a blackjack
    if ((_player[curr]['cards'][0].isAce && _player[curr]['cards'][1].isTen) || (_player[curr]['cards'][1].isAce && _player[curr]['cards'][0].isTen)) {
      _player[curr]['result'] = 2;
      _hitBtnEnabled = false;
      _bank(context);
    }

    // Check if gambler can split()
    if (_player[curr]['cards'][0].value == _player[curr]['cards'][1].value) {
      _canSplit = true;
    }
    _player[curr]['canDouble'] = true;
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
    _playerCash -= _bet.floor();
    PlayingCard splitCard = _player[0]['cards'][1];
    for (int i = 0; i < _player[0]['value'].length; i++) {
      _player[0]['value'][i] -= (splitCard.isAce ? 1 : splitCard.value);
    }
    _player.add({
      'cards': [splitCard],
      'value': [splitCard.value],
      'result': 0,
      'handBet': _bet.floor(),
      'canDouble': true,
    });
    _player[0]['cards'] = _player[0]['cards'].sublist(0, 1);
    _canSplit = false;
    _hit();
    // Check if gambler was dealt a blackjack
    if ((_player[0]['cards'][0].isAce && _player[curr]['cards'][1].isTen) || (_player[0]['cards'][1].isAce && _player[curr]['cards'][0].isTen)) {
      _player[0]['result'] = 2;
      _hitBtnEnabled = false;
    }
    _player[0]['canDouble'] = true;
  }

  void _double() {
    if (_player[curr]['canDouble']) {
      _playerCash -= _bet.floor();
      _player[curr]['handBet'] += _bet.floor();
      _hit();
      _stand();
    }
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
            child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
              Text(_gameInSession ? '${_player[index]['value'].length > 0 ? _player[index]['value'][0] : 'Bust'}' : '${_handResults[_player[index]['result']]['text']}',
                  style: GoogleFonts.ultra(
                      fontSize: 24, color: _handResults[_player[index]['result']]['color'], decoration: index == curr ? TextDecoration.underline : TextDecoration.none)),
              Text('\$${_player[index]['handBet'].floor()}',
                  style: GoogleFonts.ultra(
                    fontSize: 18,
                    color: _player[index]['result'] != 0 ? _handResults[_player[index]['result']]['color'] : BatmanColors.lightGrey,
                  ))
            ])));
  }

  List<Hand> _dealerHands() {
    return new List<Hand>.generate(1, (int index) => Hand(cards: _dealer['cards']));
  }

  // wrap in function w/ buildcontext so you can use $widget.tableMin
  final cashSnackbar = SnackBar(
    content: Row(
      children: <Widget>[
        Icon(Icons.lock, color: BatmanColors.darkGrey, size: 44),
        Flexible(
          child: Padding(
              padding: EdgeInsets.only(left: 6.0),
              child: Text(
                '\$tableMin required to gamble here',
                style: GoogleFonts.oxanium(color: Colors.black, fontSize: 14),
                textAlign: TextAlign.left,
              )),
        )
      ],
    ),
    duration: Duration(seconds: 6),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.white,
  );

  Widget _playerCommand() {
    Widget avatar = Container(
        padding: EdgeInsets.only(left: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 32,
              backgroundImage: AssetImage('assets/batmen/michael_keaton.jpg'),
            ),
            Container(
              padding: EdgeInsets.only(top: 6),
              child: Text(
                '\$$_playerCash',
                style: GoogleFonts.oxanium(color: BatmanColors.darkGrey),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ));
    Widget buttons = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BatButton(
              text: _gameInSession ? 'Hit' : 'Deal',
              enabledBool: _hitBtnEnabled,
              tapFunc: () {
                _playerCash >= widget.tableMin ? _hitBtnEnabled ? (_gameInSession ? _hit() : _beginPlay()) : () {} : _notEnoughCash();
                setState(() {});
              },
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: BatButton(
                    text: 'Split',
                    enabledBool: (_canSplit && _gameInSession),
                    tapFunc: () {
                      _canSplit
                          ? setState(() {
                              _split();
                            })
                          : () {};
                    },
                  )),
            ),
            Expanded(
                child: Container(
                    child: Text(
              '\$${_bet.floor()}',
              style: GoogleFonts.vastShadow(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ))),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 6),
                child: BatButton(
                    enabledBool: (_gameInSession && _player[curr]['canDouble']),
                    text: 'Double',
                    tapFunc: () {
                      _player[curr]['canDouble']
                          ? setState(() {
                              _double();
                            })
                          : () {};
                    }),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BatButton(
              text: _gameInSession ? 'Stand' : 'Play Again',
              enabledBool: 2 > 1,
              tapFunc: () {
                setState(() {
                  _gameInSession ? _stand() : _reset();
                });
              },
            )
          ],
        ),
      ],
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
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
                  value: _playerCash >= widget.tableMin ? _bet.toDouble() : 0.0,
                  onChanged: !_gameInSession
                      ? (newBet) {
                          setState(() {
                            _bet = newBet;
                          });
                        }
                      : null,
                  label: '$_bet',
                  min: _playerCash >= widget.tableMin ? widget.tableMin.toDouble() : 0.0,
                  max: _playerCash >= widget.tableMin ? [widget.tableMax.toDouble(), _playerCash.toDouble()].reduce(min) : 1.0),
            ))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[avatar, Expanded(child: buttons)],
        )
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

  Future<bool> _confirmLeave() async {
    _gameInSession
        ? await showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('Sure you want to leave?'),
              content: Text('If you do, you\'ll lose your bet'),
              actions: <Widget>[
                FlatButton(
                  child: Text('No I\'ll Stay'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                FlatButton(
                  child: Text('Gotham needs me'),
                  onPressed: () async {
                    var user = Provider.of<User>(context, listen: false);
                    for (int i = 0; i < _player.length; i++) {
                      _player[i]['result'] = -1;
                      _playerCash -= _bet.floor();
                      _gameInSession = false;
                      await Firestore.instance.collection('gamblers').document(user.uid).updateData({'chips': _playerCash});
                    }
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
              elevation: 16.0,
            ),
            barrierDismissible: false,
          )
        : Navigator.of(context).pop();
  }

  Future<bool> _notEnoughCash() async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: BatmanColors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: Text('You Need More Chips', style: GoogleFonts.oxanium(color: BatmanColors.lightGrey, fontWeight: FontWeight.w800)),
        content: Text('The minimum bet allowed at ${widget.casinoName} is \$${widget.tableMin}. Exchange Batpoints for chips in the Batcave.',
            style: GoogleFonts.oxanium(color: BatmanColors.lightGrey)),
        actions: <Widget>[
          FlatButton(
            child: Text('Gas up the Batmobile'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
        elevation: 16.0,
      ),
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).gamblerData,
      builder: (context, snapshot) {
        UserData userData = snapshot.data;
        return WillPopScope(
          onWillPop: _confirmLeave,
          child: Scaffold(
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
                  ],
                )),
          ),
        );
      },
    );
  }
}
