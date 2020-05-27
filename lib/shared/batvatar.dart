import 'package:blacktom/shared/palettes.dart';
import 'package:flutter/material.dart';

class Batvatar extends StatefulWidget {
  Batvatar({this.radius, this.borderWidth, this.avatarImage, this.bgColor, this.isSelected});

  final double radius;
  final double borderWidth;
  final String avatarImage;
  Color bgColor = BatmanColors.lightGrey;

  bool isSelected = false;

  @override
  _BatvatarState createState() => _BatvatarState();
}

class _BatvatarState extends State<Batvatar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: (widget.radius * 2) + widget.borderWidth,
      width: (widget.radius * 2) + widget.borderWidth,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.isSelected ? BatmanColors.yellow : Colors.black,
      ),
      child: Center(
          child: CircleAvatar(
        radius: widget.radius,
        backgroundColor: widget.bgColor,
        backgroundImage: AssetImage(widget.avatarImage),
      )),
    );
  }
}
