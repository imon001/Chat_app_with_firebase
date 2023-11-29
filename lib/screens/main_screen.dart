import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/screens/auth/auth_screen.dart';
import 'chat/chat_screen.dart';
import 'loading_splash/loading_splash_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.8),
      body: SafeArea(
        child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SplashLoadingScreen();
              }
              if (snapshot.hasData) {
                return const ChatScreen();
              }
              return const AuthScreen();
            }),
      ),
    );
  }
}
