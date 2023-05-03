import 'package:distributed_computing_project/classes/player.dart';

import '../config.dart';

class Message {
  Player from;
  Player? to;
  bool private;
  String content;
  bool outgoingMessage = true;

  Message({
    required this.from,
    this.to,
    required this.private,
    required this.content
  }) {
    outgoingMessage = from.playerID == Config.currentPlayer.playerID;
  }
}