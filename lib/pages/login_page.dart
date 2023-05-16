import 'package:distributed_computing_project/classes/colors.dart';
import 'package:flutter/material.dart';

import '../components/forms/login_form.dart';

class LogInPage extends StatelessWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.appBackground,
        body: Center(
          child: LoginForm(),
        ),
      ),
    );
  }
}