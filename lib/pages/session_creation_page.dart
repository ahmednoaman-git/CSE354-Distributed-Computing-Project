import 'package:distributed_computing_project/classes/colors.dart';
import 'package:distributed_computing_project/components/forms/session_creation_form.dart';
import 'package:flutter/material.dart';

class SessionCreationPage extends StatelessWidget {
  const SessionCreationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: AppColors.appBackground,
        body: Center(
          child: SessionCreationForm(),
        ),
      ),
    );
  }
}
