import 'package:distributed_computing_project/classes/colors.dart';
import 'package:distributed_computing_project/classes/session.dart';
import 'package:distributed_computing_project/components/sessions/session_card.dart';
import 'package:flutter/material.dart';

import '../../backend/api/api_client.dart';

class SessionsView extends StatefulWidget {
  const SessionsView({Key? key}) : super(key: key);

  @override
  State<SessionsView> createState() => _SessionsViewState();
}

class _SessionsViewState extends State<SessionsView> {
  Future<List<Session>> _sessionsFuture = Future(() => []);
  List<Session> _sessions = [];

  @override
  void initState() {
    super.initState();
    _sessionsFuture = ApiClient.getSessions();
  }

  @override
  Widget build(BuildContext context) {
    const int viewWidth = 600;
    const int viewHeight = 800;
    const int topBarHeight = 20;

    return FutureBuilder<List<Session>>(
      future: _sessionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          _sessions = snapshot.data ?? [];
          return Center(
            child: Container(
              width: viewWidth.toDouble(),
              height: viewHeight.toDouble(),
              decoration: BoxDecoration(
                color: AppColors.containerBackgroundLighter,
                borderRadius: BorderRadius.circular(20)
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: _sessions.map((session) => SessionCard(session: session)).toList(),
                  ),
                ),
              ),
            )
          );
        }
      },
    );
  }
}
