import 'package:distributed_computing_project/backend/api/api_client.dart';
import 'package:distributed_computing_project/classes/colors.dart';
import 'package:distributed_computing_project/classes/session.dart';
import 'package:distributed_computing_project/config.dart';
import 'package:distributed_computing_project/pages/home_page.dart';
import 'package:flutter/material.dart';

class SessionCard extends StatelessWidget {
  Session session;
  Map<String, Color> activityColors = {'open': AppColors.accentLighter,'running': AppColors.sessionRunningAccent, 'closed': AppColors.sessionClosedAccent};
  SessionCard({Key? key, required this.session}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const int cardWidth = 500;
    const int cardHeight = 70;
    return Container(
      width: cardWidth.toDouble(),
      height: cardHeight.toDouble(),
      decoration: BoxDecoration(
        color: AppColors.containerBackgroundDarker,
        borderRadius: BorderRadius.circular(20)
      ),
      child: Row(
        children: [
          Container(
            width: cardHeight.toDouble(),
            height: cardHeight.toDouble(),
            decoration: BoxDecoration(
              color: activityColors[session.state],
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20))
            ),
            child: session.private ? const Icon(Icons.lock, color: AppColors.highlight,) : null,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  session.sessionName,
                  style: const TextStyle(
                    color: AppColors.highlight,
                    fontSize: 19
                  ),
                ),
                VerticalDivider(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Players', style: TextStyle(
                      color: AppColors.highlight,
                      fontSize: 15
                    )),
                    Text('${session.playersId.length}/${session.numberOfPlayers}', style: const TextStyle(
                      color: AppColors.highlight,
                      fontSize: 15
                    ))
                  ],
                ),
                VerticalDivider(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Laps', style: TextStyle(
                      color: AppColors.highlight,
                      fontSize: 15
                    )),
                    Text(session.numberOfLaps.toString(), style: const TextStyle(
                      color: AppColors.highlight,
                      fontSize: 15
                    ))
                  ],
                ),
              ],
            ),
          ),
          Container(
            child: session.state == 'open' ? CircleAvatar(
              backgroundColor: AppColors.accent,
              child: IconButton(
                onPressed: () async {
                  Config.currentSession = session;
                  Config.currentChatId = await ApiClient.getChatId(Config.currentSession.id);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const HomePage())
                  );
                },
                icon: const Icon(Icons.arrow_forward, color: AppColors.highlight),
              ),
            ) : null
          ),
          const SizedBox(width: 10)
        ],
      ),
    );
  }
}