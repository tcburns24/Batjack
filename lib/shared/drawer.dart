import 'package:blacktom/models/bat_button.dart';
import 'package:blacktom/models/user.dart';
import 'package:blacktom/screens/home/leaderboard.dart';
import 'package:blacktom/screens/home/rules.dart';
import 'package:blacktom/services/auth.dart';
import 'package:blacktom/services/database.dart';
import 'package:blacktom/shared/batvatar.dart';
import 'package:blacktom/shared/palettes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'loading.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  AuthService _auth = new AuthService();

  int? _selectedBatvatar;
  late num _playerCash;
  num _playerBatpoints = 40;
  int _wageredBatpoints = 1;
  int _exchangeRate = 6;

  List<String> _batvatars = [
    'assets/batmen/adam_west.png',
    'assets/batmen/michael_keaton.jpg',
    'assets/batmen/val_kilmer.png',
    'assets/batmen/george_clooney.png',
    'assets/batmen/christian_bale.png',
    'assets/batmen/ben_affleck.png',
    'assets/batmen/robert_pattinson.png',
  ];

  List<String> _actors = ['West', 'Keaton', 'Kilmer', 'Clooney', 'Bale', 'Affleck', 'Pattinson'];

  void _getUserChips() async {
    var user = Provider.of<AppUser?>(context, listen: false);
    if (user == null) return;
    await FirebaseFirestore.instance.collection('gamblers').doc(user.uid).get().then((doc) {
      _playerCash = doc.data()?['chips'];
      _playerBatpoints = doc.data()?['batpoints'];

      String? currentBatvatar = doc.data()?['batvatar'];
      if (currentBatvatar != null) {
        int index = _batvatars.indexOf(currentBatvatar);
        if (index != -1) {
          setState(() {
            _selectedBatvatar = index;
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserChips();
  }

  void updateSelectedBatvatar(int idx) {
    setState(() {
      _selectedBatvatar = idx;
    });
  }

  void _updateBatvatar() async {
    var user = Provider.of<AppUser?>(context, listen: false);
    if (user == null) return;
    await FirebaseFirestore.instance.collection('gamblers').doc(user.uid).update({'batvatar': _batvatars[_selectedBatvatar ?? 0]});
  }

  Widget _batvatarSelection() {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
        child: Container(
            child: ListView(
          scrollDirection: Axis.horizontal,
          children: List<Widget>.generate(
              _batvatars.length,
              (int index) => Padding(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                      GestureDetector(
                          onTap: () {
                            updateSelectedBatvatar(index);
                          },
                          child: Batvatar(
                            radius: 35,
                            borderWidth: 3,
                            bgColor: BatmanColors.lightGrey,
                            avatarImage: _batvatars[index],
                            isSelected: _selectedBatvatar == index,
                          )),
                      Container(child: Text('${_actors[index]}', style: GoogleFonts.oxanium(color: Colors.white, fontSize: 14)))
                    ]),
                  )),
        )));
  }

  @override
  Widget build(BuildContext context) {
    double statusBar = MediaQuery.of(context).padding.top;
    final user = Provider.of<AppUser?>(context);
    final theme = Theme.of(context);
    if (user == null) return Text('No user');
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).gamblerData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;
            return Drawer(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.fromLTRB(8, statusBar, 4, 4),
                    color: BatmanColors.blueGrey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(top: 16, bottom: 4),
                            child: Row(children: [
                              Container(
                                height: 24,
                                width: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: CircleAvatar(
                                    radius: 10,
                                    backgroundColor: BatmanColors.lightGrey,
                                    backgroundImage: AssetImage(userData!.batvatar),
                                  ),
                                ),
                              ),
                              Text(' ${userData.username}', style: GoogleFonts.oxanium(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700))
                            ])),
                        Container(
                            padding: EdgeInsets.only(top: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  Icons.monetization_on,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                Text(' Chips: ${userData.chips}', style: GoogleFonts.oxanium(fontSize: 16, color: Colors.white)),
                              ],
                            )),
                        Container(
                            padding: EdgeInsets.only(top: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  Icons.add_circle,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                Text(' Batpoints: ${userData.batpoints}', style: GoogleFonts.oxanium(fontSize: 16, color: Colors.white)),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Row(children: [
                              Icon(
                                Icons.person_pin,
                                size: 18,
                                color: Colors.white,
                              ),
                              Text(' Choose your Batvatar:', style: GoogleFonts.oxanium(fontSize: 16, color: Colors.white))
                            ])),
                        Container(height: 115, child: _batvatarSelection()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            BatButton(
                                enabledBool: true,
                                text: 'Update Batvatar',
                                textColor: Colors.white,
                                textSize: 13.0,
                                tapFunc: () {
                                  _updateBatvatar();
                                  setState(() {});
                                })
                          ],
                        )
                      ],
                    )),
                Container(
                  padding: EdgeInsets.only(left: 8, bottom: 12),
                  decoration: BoxDecoration(color: BatmanColors.darkGrey),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12, bottom: 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.swap_horizontal_circle, color: Colors.white, size: 18),
                            Text(
                              ' Exchange Batpoints for Chips',
                              style: GoogleFonts.oxanium(color: Colors.white, fontSize: 16),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 50,
                        child: Theme(
                          data: theme.copyWith(hintColor: BatmanColors.yellow),
                          child: NumberPicker(
                              value: _wageredBatpoints,
                              axis: Axis.horizontal,
                              minValue: 1,
                              maxValue: _playerBatpoints.toInt(),
                              textStyle: TextStyle(color: BatmanColors.black),
                              selectedTextStyle: TextStyle(color: BatmanColors.yellow, fontSize: 22.0 ),
                              onChanged: (newVal) {
                                setState(() {
                                  _wageredBatpoints = newVal;
                                });
                              }),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: BatButton(
                          enabledBool: true,
                          text: 'Exchange for ${_wageredBatpoints * _exchangeRate} Chips',
                          tapFunc: () async {
                            FirebaseFirestore.instance
                              .collection('gamblers')
                              .doc(user.uid)
                              .update({'batpoints': (_playerBatpoints - _wageredBatpoints), 'chips': (_playerCash + (_wageredBatpoints * _exchangeRate))});

                            setState(() {
                              _playerBatpoints = _playerBatpoints - _wageredBatpoints;
                              _playerCash = _playerCash + (_wageredBatpoints * _exchangeRate);
                            });
                          },
                          textSize: 14.0,
                          textColor: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  child: ListTile(title: Text('Leaderboard'), leading: Icon(Icons.casino)),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Leaderboard()));
                  },
                ),
                GestureDetector(
                    child: ListTile(title: Text('Rules'), leading: Icon(Icons.description)),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Rules()));
                    }),
                GestureDetector(
                  child: ListTile(title: Text('Sign Out'), leading: Icon(Icons.flight_takeoff)),
                  onTap: () => _auth.signOut(),
                ),
              ],
            ));
          } else {
            return Loading(
              bgColor: BatmanColors.black,
              dotColor: BatmanColors.blueGrey,
            );
          }
        });
  }
}
