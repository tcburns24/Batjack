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
  Casino({this.bgGradient, this.dealerImage, this.casinoName, this.tableMin, this.tableMax, this.appBarColor, this.wallpaper, this.openCasino, this.welcomeMssg});

  final LinearGradient bgGradient;
  final String dealerImage;
  final String casinoName;
  final int tableMin;
  final int tableMax;
  final Color appBarColor;
  final String wallpaper;
  final String openCasino;
  final String welcomeMssg;

  @override
  _CasinoState createState() => _CasinoState();
}

class _CasinoState extends State<Casino> {
  // 1) State
  int _playerCash = 0;
  int _playerBatpoints = 0;
  String _playerBatvatar = '';
  bool _gameInSession = false;
  bool _hitBtnEnabled = true;
  bool _canSplit = false;
  int curr = 0;
  double _bet = 25.0;
  double _totalWager = 0.0;

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

  Future<void> _getUserChips() async {
    var user = Provider.of<User>(context, listen: false);
    await Firestore.instance.collection('gamblers').document(user.uid).get().then((doc) {
      _playerCash = doc.data['chips'];
      _playerBatvatar = doc.data['batvatar'];
      _playerBatpoints = doc.data['batpoints'];
    });
  }

  void _maybeShowWelcomeDialog(BuildContext context) {
    var user = Provider.of<User>(context, listen: false);
    Firestore.instance.collection('gamblers').document(user.uid).get().then((doc) {
      print('doc.data[openCasinos][${widget.openCasino}] == ${doc.data['openCasinos'][widget.openCasino]}');
      if (doc.data['openCasinos'][widget.openCasino] == false) {
        Firestore.instance.collection('gamblers').document(user.uid).updateData({'openCasinos.${widget.openCasino}': true});
        _welcomeDialog(true);
        (context) => Scaffold.of(context).showSnackBar(newCasinoSnackbar);
        Firestore.instance.collection('gamblers').document(user.uid).updateData({'batpoints': _playerBatpoints + 10});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _bet = widget.tableMin.toDouble();
    _getUserChips();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowWelcomeDialog(context));
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
    _totalWager = 0.0;
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
        _playerCash += 0;
        // if player wins, give them their $ plus $.
      } else if (_player[i]['result'] == 1) {
        _playerCash += _player[i]['handBet'];
        // if player gets batjack, give them their money back plus $ x 2.
      } else if (_player[i]['result'] == 2) {
        _playerCash += _player[i]['handBet'] * 2;
      } else if (_player[i]['result'] == -1) {
        _playerCash -= _player[i]['handBet'];
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
    _player[curr]['handBet'] = _bet.floor();
    _totalWager += _bet;
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
    while (_dealer['value'].length > 0 && _dealer['value'][0] < 18) {
      if (_dealer['value'][0] == 17) {
        if (_dealer['value'].length == 1) {
          break;
        }
      }
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
    _bank(context);
  }

  void _split() {
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
    _totalWager += _bet;
    _player[0]['cards'] = _player[0]['cards'].sublist(0, 1);
    _canSplit = false;
    _hit();

    // Check if gambler was dealt a blackjack
    if ((_player[0]['cards'][0].isAce && _player[curr]['cards'][1].isTen) || (_player[0]['cards'][1].isAce && _player[curr]['cards'][0].isTen)) {
      _player[0]['result'] = 2;
      _stand();
    }
    _player[0]['canDouble'] = true;
  }

  void _double() {
    if (_player[curr]['canDouble']) {
      _player[curr]['handBet'] += _bet.floor();
      _totalWager += _bet;
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
              Text('\$${_player[index]['result'] == 2 ? (_player[index]['handBet'].floor()) * 2 : _player[index]['handBet'].floor()}',
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
  final newCasinoSnackbar = SnackBar(
    content: Row(
      children: <Widget>[
        Icon(Icons.add_circle, color: BatmanColors.jokerGreen, size: 44),
        Flexible(
          child: Padding(
              padding: EdgeInsets.only(left: 6.0),
              child: Text(
                'Open a new casino. +10 Batpoints',
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

  void _hitFunc() {
    if (_playerCash < widget.tableMin) {
      if (!_gameInSession) {
        _notEnoughCash();
      } else {
        _hit();
      }
    }
    if (_playerCash >= widget.tableMin) {
      if (_hitBtnEnabled) {
        if (_gameInSession) {
          _hit();
        } else {
          _beginPlay();
        }
      }
    }
    setState(() {});
  }

  Widget _playerCommand() {
    Widget avatar = Container(
        padding: EdgeInsets.only(left: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 24),
              child: Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Center(
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: BatmanColors.lightGrey,
                    backgroundImage: AssetImage(_playerBatvatar ?? 'assets/batmen/adam_west.png'),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 6),
              child: Text(
                _gameInSession ? '\$${_playerCash - _totalWager.floor()}' : '\$${_playerCash}',
                style: GoogleFonts.oxanium(color: Colors.white, fontSize: 18),
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(child: Container()),
            Expanded(
              child: BatButton(
                text: _gameInSession ? 'Hit' : 'Deal',
                enabledBool: _hitBtnEnabled,
                tapFunc: () => _hitFunc(),
              ),
            ),
            Expanded(child: Container())
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
                    enabledBool: (_canSplit && _gameInSession && (_playerCash >= _bet * 2)),
                    tapFunc: () {
                      _canSplit && _gameInSession && (_playerCash >= _bet * 2)
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
                    enabledBool: (_gameInSession && _player[curr]['canDouble'] && (_playerCash >= _bet * 2)),
                    text: 'Double',
                    tapFunc: () {
                      (_player[curr]['canDouble'] && _gameInSession && (_playerCash >= _bet * 2))
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
            ),
          ],
        ),
      ],
    );

    double _determineMax() {
      if (_playerCash >= widget.tableMin) {
        if (_playerCash >= _bet.toDouble()) {
          return [widget.tableMax.toDouble(), _playerCash.toDouble()].reduce(min);
        } else {
          return _bet.toDouble();
        }
      } else {
        return 1.0;
      }
    }

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
//                  max: _playerCash >= widget.tableMin ? [widget.tableMax.toDouble(), _playerCash.toDouble()].reduce(min) : 1.0),
                  max: _determineMax()),
            )
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
        GestureDetector(
          onTap: () => _welcomeDialog(false),
          child: Container(
            height: 115,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 6,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, boxShadow: [BoxShadow(color: Color(0xff0f0f0f).withOpacity(0.9), spreadRadius: -5.0, blurRadius: 8.0, offset: Offset(7, 15))]),
                    child: CircleAvatar(
                      radius: 48,
                      backgroundImage: AssetImage(widget.dealerImage),
                    ),
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

  Future<void> _welcomeDialog(bool firstShow) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: BatmanColors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 43,
              width: 43,
              decoration: BoxDecoration(shape: BoxShape.circle, color: widget.appBarColor),
              child: Center(
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(widget.dealerImage),
                ),
              ),
            ),
            firstShow
                ? Container(
                    padding: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8.0)), border: Border.all(color: BatmanColors.yellow)),
                    child: RichText(
                      text: TextSpan(text: '${widget.casinoName}\n', style: GoogleFonts.oxanium(fontSize: 16, color: BatmanColors.yellow, height: 1.5), children: <TextSpan>[
                        TextSpan(
                          text: '✅  +10 Batpoints',
                          style: GoogleFonts.oxanium(fontSize: 14, color: BatmanColors.jokerGreen, height: 1.5),
                        )
                      ]),
                    ),
                  )
                : Container()
          ],
        ),
        content: SingleChildScrollView(child: Text('${widget.welcomeMssg}', style: GoogleFonts.oxanium(color: Colors.white))),
        actions: <Widget>[
          FlatButton(
            child: Text('Deal the cards', style: GoogleFonts.oxanium(color: BatmanColors.yellow)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
        elevation: 16.0,
      ),
      barrierDismissible: false,
    );
  }

  Future<bool> _confirmLeave() async {
    _gameInSession
        ? await showDialog(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: BatmanColors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: Text('Sure you want to leave?', style: GoogleFonts.oxanium(color: Colors.white, fontWeight: FontWeight.w800)),
              content: Text('If you exit, you\'ll lose your bet', style: GoogleFonts.oxanium(color: BatmanColors.lightGrey)),
              actions: <Widget>[
                FlatButton(
                  child: Text('I\'ll Stay', style: GoogleFonts.oxanium(color: BatmanColors.lightGrey)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                FlatButton(
                  child: Text('Gotham Needs Me', style: GoogleFonts.oxanium(color: BatmanColors.yellow)),
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
        title: Text('You Need More Chips', style: GoogleFonts.oxanium(color: Colors.white, fontWeight: FontWeight.w800)),
        content: Text('The minimum bet allowed at ${widget.casinoName} is \$${widget.tableMin}. Exchange Batpoints for chips in the Batcave.',
            style: GoogleFonts.oxanium(color: BatmanColors.lightGrey)),
        actions: <Widget>[
          FlatButton(
            child: Text('Gas up the Batmobile', style: GoogleFonts.oxanium(color: BatmanColors.yellow)),
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
            body: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(bottom: 12),
                  child: Image.asset(widget.wallpaper, fit: BoxFit.cover),
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black.withOpacity(0.1), widget.appBarColor.withOpacity(0.2), Colors.black],
                          stops: [0.0, 0.3, 0.9])),
                ),
                Column(
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
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
