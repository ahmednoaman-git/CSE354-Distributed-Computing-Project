import 'package:distributed_computing_project/classes/message.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  const MessageBubble({
    Key? key,
    required this.message
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(7),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: message.outgoingMessage ? const Color(0xFF007166) : const Color(0xFF2E2E2E),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: (message.outgoingMessage ? const Radius.circular(20) : const Radius.circular(0)),
          bottomRight: (message.outgoingMessage ? const Radius.circular(0) : const Radius.circular(20))
        )
      ),
      child: Text(
        message.content,
        style: const TextStyle(
          color: Color(0xFFD0D0D0)
        ),
      ),
    );
  }
}
