import 'package:distributed_computing_project/components/navbar/navbar.dart';
import 'package:distributed_computing_project/config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../classes/colors.dart';
import '../components/sessions/sessions_view.dart';

class SessionsDisplayPage extends StatelessWidget {
  const SessionsDisplayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Config.socket.dispose();
    return MaterialApp(
      home: Scaffold(
        backgroundColor: AppColors.appBackground,
        body: Column(
          children: [
            const NavBar(),
            const Divider(height: 4, thickness: 1, indent: 8, endIndent: 8, color: AppColors.highlightDarkest),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SessionsView(),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.go('/create-session');
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
