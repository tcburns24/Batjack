import 'package:blacktom/shared/palettes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BatButton extends StatelessWidget {
  BatButton({this.enabledBool, this.tapFunc, this.text});
  final bool enabledBool;
  final Function tapFunc;
  final String text;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.0)),
          side: BorderSide(color: enabledBool == true ? BatmanColors.yellow : BatmanColors.darkGrey, width: 2.0)),
      color: BatmanColors.black,
      textColor: enabledBool == true ? BatmanColors.yellow : BatmanColors.lightGrey,
      child: Text(text, style: GoogleFonts.oxanium(fontSize: 16)),
      onPressed: tapFunc,
    );
  }
}
