import 'package:blacktom/shared/palettes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Leaderboard extends StatefulWidget {
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

// Text(arr[index].data['username'].toString())

class _LeaderboardState extends State<Leaderboard> {
  ListView _allDocs(List arr) {
    return ListView.separated(
        separatorBuilder: (context, index) => Divider(
              color: BatmanColors.lightGrey,
            ),
        itemCount: arr.length,
        itemBuilder: (context, index) => ListTile(
              leading: Container(
                  child: Text(
                '${index + 1}.',
                style: GoogleFonts.oxanium(color: Colors.white, fontSize: 16),
              )),
              title: Row(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                        height: 42,
                        width: 42,
                        child: Center(
                          child: CircleAvatar(
                            backgroundImage: AssetImage(arr[index].data['batvatar']),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Text('${arr[index].data['username']}', overflow: TextOverflow.ellipsis, style: GoogleFonts.oxanium(color: Colors.white, fontSize: 16))),
                ],
              ),
              trailing: Container(
                child: Text('${arr[index].data['chips']} ', style: GoogleFonts.oxanium(color: Colors.white, fontSize: 16)),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BatmanColors.darkGrey,
      appBar: AppBar(
        backgroundColor: BatmanColors.black,
        title: Text('Leaderboard'),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('gamblers').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _allDocs(snapshot.data.documents);
          }
        },
      ),
    );
  }
}
