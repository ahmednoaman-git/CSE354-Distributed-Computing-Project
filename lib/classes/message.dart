import '../config.dart';

class Message {
  String id;
  String chatId;
  String from;
  String? to;
  bool private;
  String content;
  DateTime time = DateTime.now();
  bool outgoingMessage = true;

  Message({
    required this.id,
    required this.chatId,
    required this.from,
    this.to,
    required this.private,
    required this.content
  }) {
    outgoingMessage = from == Config.currentPlayer.playerID;
  }
}