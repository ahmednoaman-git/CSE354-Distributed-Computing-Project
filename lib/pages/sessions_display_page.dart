import 'package:distributed_computing_project/pages/session_creation_page.dart';
import 'package:flutter/material.dart';

import '../classes/colors.dart';
import '../components/sessions/sessions_view.dart';

class SessionsDisplayPage extends StatelessWidget {
  const SessionsDisplayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: AppColors.appBackground,
        body: const SessionsView(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SessionCreationPage())
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
