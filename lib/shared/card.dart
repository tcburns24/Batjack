import 'package:flutter/material.dart';

class Card extends StatelessWidget {
  Card({this.value, this.type, this.isTen, this.isAce});
  final int value;
  final String type;
  final bool isTen;
  final bool isAce;

  @override
  Widget build(BuildContext context) {
    num eighthScreen = MediaQuery.of(context).size.height / 8;
    return Container(
      height: eighthScreen,
      width: eighthScreen * 0.71,
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 5,
            left: 5,
            child: Text(type.toUpperCase()),
          )
        ],
      ),
    );
  }
}
