import '../config.dart';

class Message {
  String id;
  String chatId;
  String from;
  String? to;
  bool private;
  String content;
  DateTime time = DateTime.now();
  String username;
  String imageUrl;
  bool outgoingMessage = true;

  Message({
    required this.id,
    required this.chatId,
    required this.from,
    this.to,
    required this.private,
    required this.content,
    required this.username,
    required this.imageUrl
  }) {
    outgoingMessage = from == Config.currentPlayer.playerID;
  }
}