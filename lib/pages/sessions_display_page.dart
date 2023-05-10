import 'package:flutter/material.dart';

import '../classes/colors.dart';
import '../components/sessions/sessions_view.dart';

class SessionsDisplayPage extends StatelessWidget {
  const SessionsDisplayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: AppColors.appBackground,
        body: SessionsView(),
      ),
    );
  }
}
