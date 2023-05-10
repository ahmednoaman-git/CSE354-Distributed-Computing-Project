// ignore_for_file: depend_on_referenced_packages

import 'package:distributed_computing_project/classes/colors.dart';
import 'package:distributed_computing_project/components/chatbox/messagebubble.dart';
import 'package:distributed_computing_project/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../backend/api/api_client.dart';
import '../../classes/message.dart';

class ChatBox extends StatefulWidget {
  const ChatBox({Key? key}) : super(key: key);

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  Future<List<Message>> _messagesFuture = Future(() => []);
  List<Message> _messages = [];

  TextEditingController messageInputController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _messagesFuture = ApiClient.getMessagesBySession(Config.currentSession.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Message>>(
      future: _messagesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          _messages = snapshot.data ?? [];

          return Container(
            width: 350,
            height: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.containerBackground
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
                        children: _messages.map((message) {
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
                    color: AppColors.containerBackgroundDarker,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
                  ),
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.highlight,
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
                                  hintStyle: TextStyle(color: AppColors.highlight, fontWeight: FontWeight.w100),
                                  border: InputBorder.none,
                                  constraints: BoxConstraints(
                                    minWidth: 275,
                                    maxWidth: 275
                                  )
                                ),
                                cursorColor: AppColors.highlight,
                                style: const TextStyle(
                                  color: AppColors.highlight
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
                                  color: AppColors.accent,
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                child: const Center(child: FaIcon(FontAwesomeIcons.solidPaperPlane, color: AppColors.highlight, size: 17,)),
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
      },
    );
  }

  void _addMessage() {
    if (messageInputController.text.isNotEmpty) {
      String id = const Uuid().v4();
      Message message = Message(
        id: id,
        chatId: Config.currentChatId,
        from: Config.currentPlayer.playerID,
        private: false,
        content: messageInputController.text
      );
      _messages.add(message);
      messageInputController.clear();
      SchedulerBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      });
      ApiClient.addMessage(message);
    }
  }
}
