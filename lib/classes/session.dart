

class Session {
  String id;
  List<String> playersId= [];
  DateTime start;
  DateTime? end;
  String? winnerId;
  String sessionName;
  bool private = false;
  String? password;
  int numberOfPlayers;
  int numberOfLaps;
  String state;

  Session({
    required this.id,
    required this.start,
    required this.sessionName,
    required this.private,
    required this.numberOfPlayers,
    required this.numberOfLaps,
    required this.state
  });
}