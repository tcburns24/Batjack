class AppUser {
  final String uid;
  AppUser({required this.uid});
}

class UserData {
  final String uid;
  final int chips;
  final String username;
  final int batpoints;
  final String batvatar;

  UserData({
    required this.uid,
    required this.chips,
    required this.username,
    required this.batpoints,
    required this.batvatar,
  });
}
