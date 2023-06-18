import 'package:distributed_computing_project/backend/api/api_client.dart';
import 'package:distributed_computing_project/classes/colors.dart';
import 'package:distributed_computing_project/components/chatbox/chatbox.dart';
import 'package:distributed_computing_project/components/navbar/navbar.dart';
import 'package:distributed_computing_project/components/sessions/session_waiting_room.dart';
import 'package:distributed_computing_project/config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../classes/session.dart';

class SessionRoomPage extends StatefulWidget {
  final String urlSessionID;
  const SessionRoomPage({Key? key, required this.urlSessionID}) : super(key: key);

  @override
  State<SessionRoomPage> createState() => _SessionRoomPageState();
}

class _SessionRoomPageState extends State<SessionRoomPage> {
  Future<Session?> _sessionFuture = Future(() => null);
  Future<String?> _chatIDFuture = Future(() => null);

  @override
  void initState() {
    super.initState();
    if (Config.currentSession.id != widget.urlSessionID) {
      _sessionFuture = ApiClient.getSession(widget.urlSessionID);
      _chatIDFuture = ApiClient.getChatId(widget.urlSessionID);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!Config.isLoggedIn) {
      context.go('/');
    }

    if (Config.currentSession.id == widget.urlSessionID) {
      return displayRoom();
    }

    return FutureBuilder(
      future: Future.wait([_sessionFuture, _chatIDFuture]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: AppColors.accent));

        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');

        } else {
          Config.currentSession = snapshot.data![0] as Session;
          Config.currentChatId = snapshot.data![1] as String;

          return displayRoom();
        }
      },
    );
  }

  MaterialApp displayRoom() {
    Config.initSocket();
    Config.socket.connect();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.appBackground,
        body: Column(
          children: [
            const NavBar(),
            const Divider(height: 4, thickness: 1, indent: 8, endIndent: 8, color: AppColors.highlightDarkest),
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    SessionWaitingRoom(),
                    ChatBox(height: 650),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
