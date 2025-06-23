import 'package:blacktom/shared/palettes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BatButton extends StatelessWidget {
  BatButton({required this.enabledBool, required this.tapFunc, required this.text, this.textColor = BatmanColors.yellow, this.textSize = 16.0, Key? key,}) : super(key: key);
  final bool enabledBool;
  final Function tapFunc;
  final String text;

  Color textColor;
  double textSize;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25), // Pill shape - adjust as needed
          side: BorderSide(
            color: Colors.yellow,
            width: 3.0, // Thick yellow border
          ),
        ),
        backgroundColor: Colors.transparent, // Black background
      ),
      child: Text(
        text,
        style: GoogleFonts.oxanium(
          fontSize: textSize,
          color: Colors.yellow, // Yellow text
        ),
      ),
      onPressed: () => tapFunc(),
    );
  }
}
