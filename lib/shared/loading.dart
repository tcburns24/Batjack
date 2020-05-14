import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  Loading({this.bgColor, this.dotColor});
  Color bgColor;
  Color dotColor = Colors.yellow;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 36,
        width: 88,
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.all(Radius.circular(50))),
        child: Center(
          child: SpinKitThreeBounce(
            color: dotColor,
            size: 18.0,
          ),
        ));
  }
}
