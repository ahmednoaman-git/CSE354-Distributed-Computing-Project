// ignore_for_file: must_be_immutable

import 'package:distributed_computing_project/backend/password_hasher.dart';
import 'package:distributed_computing_project/classes/colors.dart';
import 'package:distributed_computing_project/classes/player.dart';
import 'package:distributed_computing_project/components/forms/form_text_field.dart';
import 'package:distributed_computing_project/config.dart';
import 'package:distributed_computing_project/pages/registration_page.dart';
import 'package:distributed_computing_project/pages/sessions_display_page.dart';
import 'package:flutter/material.dart';

import '../../backend/api/api_client.dart';

class LoginForm extends StatelessWidget {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final double formWidth = 600;
  final double formHeight = 600;
  final double topBarHeight = 20;

  LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    /// - MAIN CONTAINER - ///
    return Container(
      width: formWidth,
      height: formHeight,
      decoration: BoxDecoration(
        color: AppColors.containerBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          /// - TOP BAR - ///
          Container(
            height: topBarHeight,
            decoration: const BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))
            ),
          ),

          /// - FORM CONTAINER - ///
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 70),
            height: (formHeight - topBarHeight).toDouble(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                const CircleAvatar(
                  backgroundColor: AppColors.accent,
                  radius: 40,
                  child: Icon(Icons.person, color: AppColors.highlight, size: 35,)
                ),

                const Text(
                  'Welcome',
                  style: TextStyle(
                    color: AppColors.highlight,
                    fontSize: 60,
                    fontWeight: FontWeight.bold
                  ),
                ),

                FormTextField(controller: usernameController, icon: Icons.person, obscureText: false, hintText: 'Username').get(),
                FormTextField(controller: passwordController, icon: Icons.lock, obscureText: true, hintText: 'Password').get(),

                /// - LOGIN BUTTON - ///
                ElevatedButton(
                  onPressed: () async {
                    Player? validatedPlayer = await _validateCredentials(usernameController.text, passwordController.text);
                    if (validatedPlayer != null) {
                      Config.currentPlayer = validatedPlayer;
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const SessionsDisplayPage())
                      );
                    } else {
                      //TODO:UI FOR INVALID
                      print('invalid credentials');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                    ),
                    backgroundColor: AppColors.accent
                  ),
                  child: const Text(
                    'Log In',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                /// - REGISTRATION LINK - ///
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account? ',
                      style: TextStyle(color: AppColors.highlight, fontSize: 20),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const RegistrationPage())
                        );
                      },
                      child: const Text(
                      'Sign Up',
                      style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 20),
                    ))
                  ]
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<Player?> _validateCredentials(String username, String password) async {
    List<Player> players = await ApiClient.getPlayers();
    for (Player player in players) {
      if (player.userName == username && player.password == PasswordHasher.hashPassword(password)) {
        return player;
      }
    }
    return null;
  }
}
