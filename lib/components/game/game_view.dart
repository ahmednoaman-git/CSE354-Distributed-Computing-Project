import 'dart:convert';

import 'package:distributed_computing_project/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class GameView extends StatefulWidget {
  Map<String, dynamic> gameSettings = {};

  GameView({Key? key, required this.gameSettings}) : super(key: key);

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  UnityWidgetController? _unityWidgetController;

  final IO.Socket _socket = Config.socket;
  bool rec = false;

  @override
  void initState() {
    Config.updateExternalCar = _updateExternalCar;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return UnityWidget(
      onUnityCreated: onUnityCreated,
      onUnityUnloaded: onUnityLoaded,
      onUnityMessage: onUnityMessage,
    );
  }

  void onUnityCreated(controller) {
    _unityWidgetController = controller;
  }

  void onUnityLoaded() {
  }

  void onUnityMessage(dynamic message) {
    if (message == 'SceneControllerInitialized') {
      _unityWidgetController?.postMessage('SceneController', 'loadGameSettings', jsonEncode(widget.gameSettings));
    } else {
      Map<String, dynamic> parsedMessage = jsonDecode(message);
      parsedMessage['sessionID'] = Config.currentSession.id;
      _socket.emit('carState', parsedMessage);
    }
  }

  void _updateExternalCar(Map<String, dynamic> state) {
    _unityWidgetController?.postMessage(state['playerID'], 'updateCarState', jsonEncode(state));
  }
}
