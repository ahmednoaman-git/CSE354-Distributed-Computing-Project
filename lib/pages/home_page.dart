import 'package:distributed_computing_project/classes/colors.dart';
import 'package:distributed_computing_project/components/home/home_page_body.dart';
import 'package:distributed_computing_project/components/navbar/navbar.dart';
import 'package:distributed_computing_project/config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.appBackground,
        body: Column(
          children: const [
            NavBar(),
            Divider(height: 4, thickness: 1, indent: 8, endIndent: 8, color: AppColors.highlightDarkest),
            Expanded(child: Center(
              child: HomePageBody(),
            ))
          ],
        ),

        floatingActionButton: Config.isLoggedIn ? SizedBox(
          width: 130,
          height: 50,
          child: FloatingActionButton(
            onPressed: () => context.go('/sessions'),
            backgroundColor: AppColors.accent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            ),
            child: const Text(
              'Sessions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w100,
                color: AppColors.highlight
              ),
            ),
          ),
        ) : const SizedBox.shrink(),
      ),
    );
  }
}
