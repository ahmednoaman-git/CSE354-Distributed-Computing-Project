// ignore_for_file: depend_on_referenced_packages, library_prefixes

import 'package:distributed_computing_project/classes/colors.dart';
import 'package:distributed_computing_project/components/chatbox/messagebubble.dart';
import 'package:distributed_computing_project/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
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
  IO.Socket socket = Config.socket;

  TextEditingController messageInputController = TextEditingController();
  ScrollController scrollController = ScrollController();

  final double chatBoxWidth = 350;
  final double chatBoxHeight = 500;
  final double inputHeight = 65;

  @override
  void initState() {
    super.initState();

    _messagesFuture = ApiClient.getMessagesBySession(Config.currentSession.id);

    Config.displayMessage = _displayMessage;
  }

  @override
  Widget build(BuildContext context) {
    print(GoRouter.of(context).location);

    return FutureBuilder<List<Message>>(
      future: _messagesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          _messages = snapshot.data ?? [];

          print(GoRouter.of(context).location);
          /// - PARENT CONTAINER - ///
          return Container(
            width: chatBoxWidth,
            height: chatBoxHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.containerBackgroundLighter
            ),
            child: Column(
              children: [

                /// - MESSAGES CONTAINER - ///
                Container(
                  width: chatBoxWidth,
                  height: chatBoxHeight-inputHeight,
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


                /// - Message Input - ///
                Container(
                  width: chatBoxWidth,
                  height: inputHeight,
                  decoration: const BoxDecoration(
                    color: AppColors.containerBackground,
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

                            /// - INPUT BUTTON - ///
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
                                _addMessage();
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

      _displayMessage(message);
      messageInputController.clear();

      socket.emit('message', '''
        {
          "messageID": "${message.id}",
          "chatID": "${message.chatId}",
          "from": "${message.from}",
          "to": ${message.to == null ? null : '"${message.to}"'},
          "private": ${message.private},
          "content": "${message.content}",
          "time": "${message.time}"
        }
      ''');
      ApiClient.addMessage(message);
    }
  }

  void _displayMessage(Message message) {
    setState(() {
      _messages.add(message);
      SchedulerBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      });
    });
  }

  // IO.Socket _initSocket(IO.Socket socket) {
  //   socket.on('connect', (_) {
  //     debugPrint('Flutter player connected on ${Config.currentChatId}');
  //     socket.emit('joinChat', Config.currentChatId);
  //   });
  //
  //   socket.on('message', (data) {
  //     Map<String, dynamic> messageData = jsonDecode(data);
  //     Message message = Message(
  //         id: messageData['messageID'],
  //         chatId: messageData['chatID'],
  //         from: messageData['from'],
  //         to: messageData['to'],
  //         private: messageData['private'],
  //         content: messageData['content']
  //     );
  //     message.time = DateTime.parse(messageData['time']);
  //
  //     _displayMessage(message);
  //   });
  //
  //   socket.on('res', (data) {
  //     debugPrint(data);
  //   });
  //
  //   return socket;
  // }
}