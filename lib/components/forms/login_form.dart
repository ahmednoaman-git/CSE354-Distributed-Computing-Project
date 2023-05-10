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
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    const int formWidth = 600;
    const int formHeight = 600;
    const int topBarHeight = 20;
    return Container(
      width: 600,
      height: 600,
      decoration: BoxDecoration(
        color: AppColors.containerBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 20,
            decoration: const BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 70),
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
    print(players);
    for (Player player in players) {
      print(player.password);
      print(PasswordHasher.hashPassword(password));
      if (player.userName == username && player.password == PasswordHasher.hashPassword(password)) {
        return player;
      }
    }
    return null;
  }
}
