// ignore_for_file: depend_on_referenced_packages

import 'package:distributed_computing_project/components/chatbox/messagebubble.dart';
import 'package:distributed_computing_project/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../classes/message.dart';

List<Message> messages = [];

class ChatBox extends StatefulWidget {
  const ChatBox({Key? key}) : super(key: key);

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  TextEditingController messageInputController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 500,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF3E3E3E)
      ),
      child: Column(
        children: [
          Container(
            width: 350,
            height: 435,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: messages.map((message) {
                    return Row(
                      mainAxisAlignment: message.outgoingMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        MessageBubble(message: message),
                      ],
                    );
                  }).toList()
                ),
              ),
            ),
          ),


          /// ## Message Input ## ///
          Container(
            width: 350,
            height: 500-435,
            decoration: const BoxDecoration(
              color: Color(0xFF383838),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
            ),
            child: Center(
              child: Container(
                margin: const EdgeInsets.only(left: 5, right: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFD0D0D0),
                    width: 1.5
                  ),
                  borderRadius: BorderRadius.circular(40)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 3),
                      child: TextField(
                        controller: messageInputController,
                        decoration: const InputDecoration(
                          hintText: 'Send a message...',
                          hintStyle: TextStyle(color: Color(0xFFD0D0D0), fontWeight: FontWeight.w100),
                          border: InputBorder.none,
                          constraints: BoxConstraints(
                            minWidth: 275,
                            maxWidth: 275
                          )
                        ),
                        cursorColor: const Color(0xFFD0D0D0),
                        style: const TextStyle(
                          color: Color(0xFFD0D0D0)
                        ),
                        onSubmitted: (text) {
                          setState(() {
                            _addMessage();
                          });
                        },
                      ),
                    ),
                    GestureDetector(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: const Color(0xFF007166),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: const Center(child: FaIcon(FontAwesomeIcons.solidPaperPlane, color: Color(0xFFD0D0D0), size: 17,)),
                      ),
                      onTap: () {
                        setState(() {
                          _addMessage();
                        });
                      },
                    )
                  ],
                )
              ),
            ),
          )
        ],
      ),
    );
  }

  void _addMessage() {
    if (messageInputController.text.isNotEmpty) {
      messages.add(
        Message(
          from: Config.currentPlayer,
          private: false,
          content: messageInputController.text
        )
      );
      messageInputController.clear();
      SchedulerBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      });
    }
  }
}
