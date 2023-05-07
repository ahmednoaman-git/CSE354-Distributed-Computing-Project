import 'package:distributed_computing_project/classes/colors.dart';
import 'package:distributed_computing_project/classes/player.dart';
import 'package:distributed_computing_project/components/forms/registration_form.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.appBackground,
        body: Center(
          child: RegistrationForm(),
        ),
      ),
    );
  }

  Player _createPlayer(String userName, String password, String imageUrl) {
    String ID = const Uuid().v4();
    return Player(playerID: ID, userName: userName, password: password, imageUrl: imageUrl);
  }
}