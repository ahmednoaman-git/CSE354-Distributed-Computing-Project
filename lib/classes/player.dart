class Player {
  String playerID;
  String userName;
  String password;
  bool? connected;
  String? lastSeen;


  Player({
    required this.playerID,
    required this.userName,
    required this.password
  });
}