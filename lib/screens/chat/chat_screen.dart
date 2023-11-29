import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_messaging/firebase_messaging.dart'; //use for push notification
import 'package:flutter/material.dart';

import '../../widgets/chat_msgs.dart';
import '../../widgets/new_chat_msg_input.dart';

class ChatScreen extends StatelessWidget {
  // [  // void setUpPushNoti() async {
//   //   final fcm = FirebaseMessaging.instance;
//   //   await fcm.requestPermission();
//   //   fcm.subscribeToTopic('chat');
//   // }

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   setUpPushNoti();
//   // }
//] use for push notification ..must be use stf widget.
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.onPrimary,
              ))
        ],
      ),
      body: const Column(
        children: [Expanded(child: ChatMsgs()), NewChatMsg()],
      ),
    );
  }
}
