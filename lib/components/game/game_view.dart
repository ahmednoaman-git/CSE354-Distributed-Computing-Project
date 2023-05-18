import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class GameView extends StatelessWidget {
  const GameView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnityWidget(
      onUnityCreated: onUnityCreated,
    );
  }

  void onUnityCreated(controller) {
    print('created successfully');
  }
}
