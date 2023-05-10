import 'package:distributed_computing_project/backend/api/api_client.dart';
import 'package:distributed_computing_project/backend/password_hasher.dart';
import 'package:distributed_computing_project/classes/colors.dart';
import 'package:distributed_computing_project/components/forms/counterbutton/counter_button.dart';
import 'package:distributed_computing_project/components/forms/form_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../classes/session.dart';

class SessionCreationForm extends StatefulWidget {
  const SessionCreationForm({Key? key}) : super(key: key);

  @override
  State<SessionCreationForm> createState() => _SessionCreationFormState();
}

class _SessionCreationFormState extends State<SessionCreationForm> {
  bool _private = false;

  @override
  Widget build(BuildContext context) {
    const int formHeight = 600;
    const int formWidth = 600;
    const int topBarHeight = 20;

    TextEditingController sessionNameController = TextEditingController();
    TextEditingController sessionPasswordController = TextEditingController();
    CounterButtonController numberOfPlayersController = CounterButtonController();
    CounterButtonController numberOfLapsController = CounterButtonController();



    return Container(
      width: 600,
      height: 600,
      decoration: BoxDecoration(
        color: AppColors.containerBackground,
        borderRadius: BorderRadius.circular(20)
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
                    child: Icon(Icons.list_alt_outlined, color: AppColors.highlight, size: 35,)
                ),
                const Text(
                  'Create a new session',
                  style: TextStyle(
                      color: AppColors.highlight,
                      fontSize: 40,
                      fontWeight: FontWeight.bold
                  ),
                ),
                FormTextField(controller: sessionNameController, icon: Icons.drive_file_rename_outline, obscureText: false, hintText: 'Session name').get(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                      width: formWidth / 4,
                      decoration: BoxDecoration(
                        color: AppColors.containerBackgroundDarker,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            'Private',
                            style: TextStyle(
                              color: AppColors.highlight,
                              fontSize: 16,
                            ),
                          ),
                          CupertinoSwitch(
                            value: _private,
                            activeColor: AppColors.accent,
                            trackColor: AppColors.containerBackgroundLighter,
                            onChanged: (value) {
                              setState(() => _private = value);
                            }
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: formWidth - (formWidth/1.9),
                      child: FormTextField(controller: sessionPasswordController, icon: Icons.lock, obscureText: true, hintText: 'Session Password').get()
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CounterButton(controller: numberOfPlayersController, buttonName: 'Number of Players', minimum: 1, maximum: 4),
                    CounterButton(controller: numberOfLapsController, buttonName: 'Number of Laps', minimum: 1, maximum: 10)
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (sessionNameController.text.isNotEmpty && (!_private || (_private && sessionPasswordController.text.isNotEmpty))) {
                      Session session = _createSession(
                        sessionNameController.text, _private,
                        sessionPasswordController.text,
                        numberOfPlayersController.count,
                        numberOfLapsController.count
                      );
                      int response = await ApiClient.addSession(session);
                      print(response);
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
                    'Create Session',
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

  Session _createSession(String sessionName, bool private, String password, int numberOfPlayers, int numberOfLaps) {
    String id =  const Uuid().v4();
    DateTime start = DateTime.now();

    Session session =  Session(
      id: id,
      start: start,
      sessionName: sessionName,
      private: private,
      numberOfPlayers: numberOfPlayers,
      numberOfLaps: numberOfLaps,
      state: 'open'
    );

    if (private) {
      password = PasswordHasher.hashPassword(password);
      session.password = password;
    }

    return session;
  }
}
