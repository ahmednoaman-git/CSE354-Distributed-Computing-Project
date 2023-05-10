import 'package:distributed_computing_project/backend/password_hasher.dart';
import 'package:distributed_computing_project/classes/colors.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../backend/api/api_client.dart';
import '../../classes/player.dart';
import 'form_text_field.dart';

class RegistrationForm extends StatelessWidget {
  const RegistrationForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController passwordConfirmController = TextEditingController();
    TextEditingController imageUrlController = TextEditingController();
    const int formWidth = 600;
    const int formHeight = 700;
    const int topBarHeight = 20;

    return Container(
      width: formWidth.toDouble(),
      height: formHeight.toDouble(),
      decoration: BoxDecoration(
        color: AppColors.containerBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: topBarHeight.toDouble(),
            decoration: const BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 70),
            height: (formHeight - topBarHeight).toDouble(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const CircleAvatar(
                    backgroundColor: AppColors.accent,
                    radius: 40,
                    child: Icon(Icons.app_registration, color: AppColors.highlight, size: 35)
                ),
                const Text(
                  'Registration',
                  style: TextStyle(
                      color: AppColors.highlight,
                      fontSize: 60,
                      fontWeight: FontWeight.bold
                  ),
                ),
                FormTextField(controller: usernameController, icon: Icons.person, obscureText: false,  hintText: 'Username').get(),
                FormTextField(controller: passwordController, icon: Icons.lock, obscureText: true, hintText: 'Password').get(),
                FormTextField(controller: passwordConfirmController, icon: Icons.lock_reset_outlined, obscureText: true,  hintText: 'Confirm password').get(),
                FormTextField(controller: imageUrlController, icon: Icons.link, obscureText: false,  hintText: 'Profile image url').get(),
                ElevatedButton(
                  onPressed: () async {
                    int response = 0;
                    if (
                      passwordController.text == passwordConfirmController.text &&
                      (usernameController.text.isNotEmpty && passwordController.text.isNotEmpty && passwordConfirmController.text.isNotEmpty && imageUrlController.text.isNotEmpty)
                    ) {
                      response = await ApiClient.addPlayer(_createPlayer(
                          usernameController.text,
                          PasswordHasher.hashPassword(passwordController.text),
                          imageUrlController.text
                      ));
                    }
                    if (response == 200) {
                      Navigator.of(context).pop();
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
                    'Sign Up',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Player _createPlayer(String userName, String password, String imageUrl) {
    String id = const Uuid().v4();
    return Player(playerID: id, userName: userName, password: password, imageUrl: imageUrl);
  }
}
