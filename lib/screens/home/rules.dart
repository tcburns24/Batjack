import 'package:blacktom/shared/palettes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Rules extends StatelessWidget {
  List<String> rules = [
    'Standard win returns 1x bet',
    'Batjack returns 2x bet',
    'Limit 1 split per hand',
    'Can double only before first hit',
    'Dealer stands on soft 17s',
    'Player cannot double or split without sufficient chips',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: BatmanColors.blueGrey,
        appBar: AppBar(
          backgroundColor: BatmanColors.darkGrey,
          title: Text('Rules'),
        ),
        body: ListView.separated(
            itemBuilder: (context, index) => ListTile(
                  leading: Icon(Icons.arrow_right, color: Colors.white),
                  title: Text(rules[index], style: GoogleFonts.itim(color: Colors.white, fontSize: 18)),
                ),
            separatorBuilder: (context, index) => Divider(
                  color: BatmanColors.lightGrey,
                ),
            itemCount: rules.length));
  }
}
