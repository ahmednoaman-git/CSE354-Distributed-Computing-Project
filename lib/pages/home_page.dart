import 'package:distributed_computing_project/components/chatbox/chatbox.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF2E2E2E),
        appBar: AppBar(
          leading: const Icon(Icons.menu),
        ),
        body: const Center(child: ChatBox()),
      ),
    );
  }
}
