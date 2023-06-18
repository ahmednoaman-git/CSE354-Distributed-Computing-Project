

import 'package:distributed_computing_project/backend/api/api_client.dart';
import 'package:distributed_computing_project/classes/player.dart';

class Session {
  String id;
  List<String> playersId = [];
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

  Future<List<Player>> getPlayers() async {
    List<Player> players = [];
    for (String playerID in playersId) {
      Player? player = await ApiClient.getPlayer(playerID);
      if (player != null) {
        players.add(player);
      }
    }
    return players;
  }
}