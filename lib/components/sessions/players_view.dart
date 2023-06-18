// ignore_for_file: must_be_immutable

import 'package:distributed_computing_project/classes/colors.dart';
import 'package:distributed_computing_project/config.dart';
import 'package:flutter/material.dart';

import '../../classes/player.dart';

class PlayersView extends StatefulWidget {
  double? width = 750;
  double? height = 350;
  List<Player> players;
  Map<String, dynamic> playerStates;
  String leaderID;
  PlayersView({Key? key, required this.players, required this.playerStates, required this.leaderID, this.width, this.height}) : super(key: key);

  @override
  State<PlayersView> createState() => _PlayersViewState();
}

class _PlayersViewState extends State<PlayersView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: AppColors.containerBackground,
        borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        mainAxisAlignment: widget.players.length == 4 ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.start,
        children: widget.players.map((player) {
          return Container(
            padding: const EdgeInsets.all(4),
            margin: widget.players.length != 4 ? const EdgeInsets.only(top: 6, left: 6, right: 6) : const EdgeInsets.symmetric(horizontal: 6),
            height: widget.height! / 4.5,
            decoration: BoxDecoration(
              color: AppColors.containerBackgroundLighter,
              border: Border.all(
                width: 1,
                color: AppColors.highlightDarkest
              ),
              borderRadius: BorderRadius.circular(20)
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      foregroundImage: NetworkImage(player.imageUrl),
                      backgroundColor: AppColors.containerBackground
                    ),

                    const VerticalDivider(color: AppColors.appBackground, width: 20),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          player.userName,
                          style: const TextStyle(
                            color: AppColors.highlight,
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                          ),
                        ),

                        Text(
                          player.playerID == widget.leaderID ? 'Room Leader' : 'Player',
                          style: const TextStyle(
                            color: AppColors.highlightDarker,
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                          ),
                        )
                      ],
                    ),
                  ],
                ),

                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.highlight,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Image.asset(widget.playerStates[player.playerID]?['car'] ?? 'Assets/Cars/Black/car_black_1.png', width: 40, height: 40)
                    ),

                    const SizedBox(width: 10),

                    CircleAvatar(
                      radius: 15,
                      backgroundColor: widget.playerStates[player.playerID]['ready'] || player.playerID == Config.currentSessionLeader ? AppColors.accent : AppColors.sessionClosedAccent,
                    ),

                    const SizedBox(width: 10)
                  ],
                )
              ],
            ),
          );
        }).toList()
      ),
    );
  }
}
