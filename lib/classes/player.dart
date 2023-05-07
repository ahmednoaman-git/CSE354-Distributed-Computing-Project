class Player {
  String playerID;
  String userName;
  String password;
  bool? connected;
  String? lastSeen;
  String imageUrl;


  Player({
    required this.playerID,
    required this.userName,
    required this.password,
    this.connected,
    this.lastSeen,
    required this.imageUrl
  });
}