import 'package:distributed_computing_project/classes/colors.dart';
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
    if (!message.outgoingMessage) {
      return SizedBox(
          width: 300,
          child: getMessageBubble()
      );
    } else {
      return getMessageBubble();
    }
  }

  Stack getMessageBubble() {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 7),
          padding: const EdgeInsets.all(10),

          decoration: BoxDecoration(
            color: message.outgoingMessage ? AppColors.accent : AppColors.containerBackgroundDarker,
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
              color: AppColors.highlight
            ),
          )
        ),

        if (!message.outgoingMessage)
        Positioned(left: 0, top: 0, child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.containerBackgroundLighter,
              child: CircleAvatar(
                radius: 11,
                backgroundColor: AppColors.containerBackground,
                foregroundImage: NetworkImage(message.imageUrl),
              ),
            ),

            SizedBox(
              width: 50,
              child: Text(
                message.username.split(' ')[0],
                style: const TextStyle(
                  color: AppColors.highlightDarker,
                  fontSize: 13,
                  fontWeight: FontWeight.w500
                ),
              ),
            )
          ],
        )),
      ]
    );
  }
}
