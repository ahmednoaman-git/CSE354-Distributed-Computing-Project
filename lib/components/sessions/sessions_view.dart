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


  final int _viewWidth = 520;
  final int _viewHeight = 800;
  final int _topBarHeight = 20;

  @override
  void initState() {
    super.initState();
    _sessionsFuture = ApiClient.getSessions();
  }

  @override
  Widget build(BuildContext context) {


    return FutureBuilder<List<Session>>(
      future: _sessionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: SizedBox(width: _viewWidth/6, height: _viewWidth/6, child: const CircularProgressIndicator(color: AppColors.accent)));
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          _sessions = snapshot.data ?? [];
          return Center(
            child: Container(
              padding: EdgeInsets.all(30),
              width: _viewWidth.toDouble(),
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
