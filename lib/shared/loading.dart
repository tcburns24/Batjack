import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 36,
        width: 88,
        decoration: BoxDecoration(color: Colors.blueAccent[700], borderRadius: BorderRadius.all(Radius.circular(2))),
        child: Center(
          child: SpinKitThreeBounce(
            color: Colors.white,
            size: 18.0,
          ),
        ));
  }
}
