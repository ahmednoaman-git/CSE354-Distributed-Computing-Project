import 'package:distributed_computing_project/pages/home_page.dart';
import 'package:distributed_computing_project/pages/login_page.dart';
import 'package:distributed_computing_project/pages/registration_page.dart';
import 'package:distributed_computing_project/pages/session_creation_page.dart';
import 'package:distributed_computing_project/pages/session_room_page.dart';
import 'package:distributed_computing_project/pages/sessions_display_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(AppRoot());
}

class AppRoot extends StatelessWidget {
  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LogInPage()
      ),

      GoRoute(
        path: '/sessions',
        builder: (context, state) => const SessionsDisplayPage(),
        routes: [
          GoRoute(
            path: ':session',
            builder: (context, state) => SessionRoomPage(urlSessionID: state.pathParameters['session'] ?? '0')
          )
        ]
      ),

      GoRoute(
        path: '/register',
        builder: (context, state) => const RegistrationPage()
      ),

      GoRoute(
        path: '/create-session',
        builder: (context, state) => const SessionCreationPage()
      ),

      GoRoute(
        path: '/game',
        builder: (context, state) => const HomePage()
      )
    ]
  );

  AppRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Distributed Computing',
      routerConfig: _router,
    );
  }
}