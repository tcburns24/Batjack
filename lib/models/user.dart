class User {
  User({this.uid});
  final String uid;
}

class UserData {
  UserData({this.uid, this.chips, this.username, this.batpoints, this.batvatar});

  final String uid;
  final int chips;
  final String username;
  final int batpoints;
  final String batvatar;
}
