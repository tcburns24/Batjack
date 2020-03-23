import 'package:blacktom/shared/palettes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 36,
        width: 88,
        decoration: BoxDecoration(color: BatmanColors.darkGrey, borderRadius: BorderRadius.all(Radius.circular(2))),
        child: Center(
          child: SpinKitThreeBounce(
            color: BatmanColors.yellow,
            size: 18.0,
          ),
        ));
  }
}
