import 'package:blacktom/shared/palettes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Leaderboard extends StatefulWidget {
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  ListView _allDocs(List arr) {
    // sort the arr items by chips (descending)
    arr.sort((a, b) => b.data()['chips'].compareTo(a.data()['chips']));
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
                            backgroundImage: AssetImage(arr[index].data()['batvatar']),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Flexible(
                    child: Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text('${arr[index].data()['username']}', overflow: TextOverflow.ellipsis, style: GoogleFonts.oxanium(color: Colors.white, fontSize: 16))),
                  ),
                ],
              ),
              trailing: Container(
                child: Text('${arr[index].data()['chips']} ', style: GoogleFonts.oxanium(color: Colors.white, fontSize: 16)),
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
        stream: FirebaseFirestore.instance.collection('gamblers').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return _allDocs((snapshot.data as QuerySnapshot).docs);
        },
      ),
    );
  }
}
