import 'package:blacktom/shared/palettes.dart';
import 'package:flutter/material.dart';

class BatButton extends StatelessWidget {
  BatButton({this.enabledBool, this.tapFunc, this.text, this.textStyle});
  final bool enabledBool;
  final Function tapFunc;
  final String text;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.0)),
          side: BorderSide(color: enabledBool == true ? BatmanColors.yellow : BatmanColors.darkGrey, width: 2.0)),
      color: BatmanColors.black,
      textColor: enabledBool == true ? BatmanColors.yellow : BatmanColors.lightGrey,
      child: Text(text, style: textStyle),
      onPressed: tapFunc,
    );
  }
}
