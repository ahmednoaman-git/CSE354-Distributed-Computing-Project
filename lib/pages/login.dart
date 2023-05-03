import 'package:flutter/material.dart';

class LogInPage extends StatelessWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[300],
        body: Center(
          child: Container(
            width: 300,
            height: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.computer, size:100),
                const Text('CSE354:Distributed Computing'),
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'Username',
                    labelText: 'Username',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)
                    )
                  ),
                ),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Password'
                  ),
                ),
                ElevatedButton(
                  onPressed: () {

                  },
                  child: Text('submit'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
