import 'package:distributed_computing_project/classes/colors.dart';
import 'package:distributed_computing_project/components/sessions/car_color_button.dart';
import 'package:distributed_computing_project/components/sessions/players_view.dart';
import 'package:distributed_computing_project/config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../classes/player.dart';
class SessionWaitingRoom extends StatefulWidget {
  const SessionWaitingRoom({Key? key}) : super(key: key);

  @override
  State<SessionWaitingRoom> createState() => _SessionWaitingRoomState();
}

class _SessionWaitingRoomState extends State<SessionWaitingRoom> {
  Future<List<Player>> _playersFuture = Future(() => []);
  List<Player> _players = [];
  String _leaderID = '';
  final IO.Socket _socket = Config.socket;

  final double _viewWidth = 800;
  final double _viewHeight = 650;

  Map<String, Map<String, dynamic>> _playerStates = {};

  final Map<String, Color> _colorOptions = {
    'Black': AppColors.carColorBlack,
    'Blue': AppColors.carColorBlue,
    'Green': AppColors.carColorGreen,
    'Red': AppColors.carColorRed,
    'Yellow': AppColors.carColorYellow,
  };

  String _currentColor = 'Black';
  int _typeIndex = 0;
  String _currentCarAssetUrl = '';

  Color _inkWellColor = AppColors.accent;
  bool _inkWellJustTapped = false;
  IconData _inkWellIcon = Icons.check_rounded;

  bool _ready = false;

  @override
  void initState() {
    Config.updatePlayerState = _updatePlayerState;
    Config.displayPlayer = _displayPlayers;
    Config.removePlayer = _removePlayer;
    Config.startGame = _startGame;

    _playersFuture = Config.currentSession.getPlayers();

    _currentCarAssetUrl = 'Assets/Cars/$_currentColor/car_${_currentColor.toLowerCase()}_${_typeIndex + 1}.png';

    _playerStates[Config.currentPlayer.playerID] = {
      'playerID': Config.currentPlayer.playerID,
      'sessionID': Config.currentSession.id,
      'ready': false,
      'car': _currentCarAssetUrl
    };

    _socket.emit('sessionState', _playerStates[Config.currentPlayer.playerID]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Player>>(
      future: _playersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: _viewWidth,
            height: _viewHeight,
            decoration: BoxDecoration(
              color: AppColors.containerBackgroundLighter,
              borderRadius: BorderRadius.circular(20)
            ),
            child: Center(child: SizedBox(width: _viewWidth/6, height: _viewWidth/6, child: const CircularProgressIndicator(color: AppColors.accent)))
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          _players = snapshot.data ?? [];

          return Stack(
            children: [
              Container(
                width: _viewWidth,
                height: _viewHeight,
                decoration: BoxDecoration(
                    color: AppColors.containerBackgroundLighter,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    PlayersView(players: _players, playerStates: _playerStates, leaderID: _leaderID, width: _viewWidth * 0.97, height: _viewHeight * 0.95 / 2),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        Container(
                          padding: const EdgeInsets.all(40),
                          width: 0.95 * 0.5 * _viewWidth,
                          height: _viewHeight * 0.95 / 2,
                          decoration: BoxDecoration(
                              color: AppColors.containerBackground,
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: SizedBox.fromSize(
                              size: Size.fromRadius(0.95 * 0.5 * _viewWidth * 0.5), // Image radius
                              child: Image.network('https://thumbs.dreamstime.com/b/cartoon-racing-map-game-49708152.jpg', fit: BoxFit.cover),
                            ),
                          ),
                        ),

                        Container(
                          width: 0.95 * 0.5 * _viewWidth,
                          height: _viewHeight * 0.95 / 2,
                          decoration: BoxDecoration(
                              color: AppColors.containerBackground,
                              borderRadius: BorderRadius.circular(20)
                          ),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  CircleAvatar(
                                    radius: 17,
                                    backgroundColor: AppColors.containerBackgroundLighter,
                                    child: IconButton(
                                      padding: const EdgeInsets.only(left: 10),
                                      onPressed: () {
                                        setState(() {
                                          if (_typeIndex == 4) {
                                            _typeIndex = 0;
                                          } else {
                                            _typeIndex++;
                                          }
                                          _currentCarAssetUrl = 'Assets/Cars/$_currentColor/car_${_currentColor.toLowerCase()}_${_typeIndex + 1}.png';
                                          _playerStates[Config.currentPlayer.playerID]!['car'] = _currentCarAssetUrl;
                                          _socket.emit('sessionState', _playerStates[Config.currentPlayer.playerID]);
                                        });
                                      },
                                      icon: const Icon(Icons.arrow_back_ios, color: AppColors.highlight,)
                                    ),
                                  ),
                                  Container(
                                      width: 0.2 * _viewWidth,
                                      height: 0.2 * _viewHeight,
                                      decoration: BoxDecoration(
                                          color: AppColors.highlight,
                                          borderRadius: BorderRadius.circular(20)
                                      ),
                                      child: Image.asset(_currentCarAssetUrl)
                                  ),
                                  CircleAvatar(
                                    radius: 17,
                                    backgroundColor: AppColors.containerBackgroundLighter,
                                    child: IconButton(
                                      padding: const EdgeInsets.only(left: 2),
                                      hoverColor: AppColors.highlight,
                                      onPressed: () {
                                        setState(() {
                                          if (_typeIndex == 0) {
                                            _typeIndex = 4;
                                          } else {
                                            _typeIndex--;
                                          }
                                          _currentCarAssetUrl = 'Assets/Cars/$_currentColor/car_${_currentColor.toLowerCase()}_${_typeIndex + 1}.png';
                                          _playerStates[Config.currentPlayer.playerID]!['car'] = _currentCarAssetUrl;
                                          _socket.emit('sessionState', _playerStates[Config.currentPlayer.playerID]);
                                        });
                                      },
                                      icon: const Icon(Icons.arrow_forward_ios, color: AppColors.highlight),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: _colorOptions.entries.map((option) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        _currentColor = option.key;
                                        _currentCarAssetUrl = 'Assets/Cars/$_currentColor/car_${_currentColor.toLowerCase()}_${_typeIndex + 1}.png';
                                        _playerStates[Config.currentPlayer.playerID]!['car'] = _currentCarAssetUrl;
                                        _socket.emit('sessionState', _playerStates[Config.currentPlayer.playerID]);
                                      });
                                    },
                                    child: CarColorButton(color: option.value, value: option.key)
                                  );
                                }).toList()
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),

              Positioned(
                left: _viewWidth / 2 - 41,
                top: _viewHeight * 0.886,
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    if (Config.currentPlayer.playerID == _leaderID) {
                      Map<String, dynamic> gameSettings = {'map': 1, 'laps': Config.currentSession.numberOfLaps, 'sessionID': Config.currentSession.id, 'players':[]};
                      for (String playerID in _playerStates.keys) {
                        String unformattedCarUrl = _playerStates[playerID]!['car'];
                        String formattedCarUrl = unformattedCarUrl.substring(7, unformattedCarUrl.length-4);
                        gameSettings['players'].add({
                          'playerID': playerID,
                          'isClientPlayer': false,
                          'car': formattedCarUrl
                        });
                      }
                      _socket.emit('startGame', gameSettings);
                      return;
                    }

                    setState(() {
                      _inkWellJustTapped = true;
                      _inkWellColor = _ready ? AppColors.accent : AppColors.sessionClosedAccent;
                      _inkWellIcon = _ready ? Icons.check_rounded : Icons.close_rounded;
                      _ready = !_ready;
                      _playerStates[Config.currentPlayer.playerID]!['ready'] = _ready;
                      _socket.emit('sessionState', _playerStates[Config.currentPlayer.playerID]);
                    });
                  },

                  onHover: (hover) {
                    if (hover && !_inkWellJustTapped) {
                      setState(() {
                        _inkWellColor = AppColors.appBackground;
                      });
                    } else {
                      setState(() {
                        _inkWellJustTapped = false;
                        _inkWellColor = _ready ? AppColors.sessionClosedAccent : AppColors.accent;
                      });
                    }
                  },

                  child: CircleAvatar(
                    radius: 41,
                    backgroundColor: AppColors.containerBackgroundLighter,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: _inkWellColor,
                      child: Icon(Config.currentPlayer.playerID == _leaderID ? Icons.play_arrow :   _inkWellIcon, color: AppColors.highlight, size: 30)
                    ),
                  ),
                ),
              )
            ],
          );
        }
      },
    );
  }

  void _displayPlayers() {
    print('Updating players');
    setState(() {
      _leaderID = Config.currentSessionLeader;
      _playersFuture = Config.currentSession.getPlayers();
    });
  }

  void _updatePlayerState(Map<String, dynamic> state) {
    setState(() {
      _playerStates[state['playerID']] = state;
    });
  }

  void _removePlayer(String uuid) {
    for (int i  = 0; i < _players.length; i++) {
      if (_players[i].playerID == uuid) {
        setState(() {
          _players.removeAt(i);
        });
      }
    }
  }

  void _startGame() {
    Config.currentSessionPlayers = _players;
    context.go('/game');
  }
}