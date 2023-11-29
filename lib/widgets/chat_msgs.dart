import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'msg_bubble.dart';

class ChatMsgs extends StatelessWidget {
  const ChatMsgs({super.key});

  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('chat').orderBy('createdAt', descending: true).snapshots(),
        builder: (ctx, chatSnapshots) {
          if (chatSnapshots.connectionState == ConnectionState.waiting) {
            Center(
              child: SizedBox(
                width: 60,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballSpinFadeLoader,
                  colors: [
                    Theme.of(context).colorScheme.onBackground,
                  ],
                  strokeWidth: 4,
                ),
              ),
            );
          }
          if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
            return const Center(
              child: Text('No messages found.'),
            );
          }
          if (chatSnapshots.hasError) {
            return const Center(
              child: Text('Something went wrong.'),
            );
          }
          final loadedMsgs = chatSnapshots.data!.docs;

          return ListView.builder(
              padding: const EdgeInsets.only(bottom: 40, left: 10, right: 10),
              reverse: true,
              itemCount: loadedMsgs.length,
              itemBuilder: (ctx, index) {
                final chatMessages = loadedMsgs[index].data();
                final nextMsg = index + 1 < loadedMsgs.length ? loadedMsgs[index + 1].data() : null;

                final currentMsgUserId = chatMessages['userId'];
                final nextCurrentMsgUserId = nextMsg != null ? nextMsg['userId'] : null;
                final nextUserIsSame = currentMsgUserId == nextCurrentMsgUserId;

                if (nextUserIsSame) {
                  return MessageBubble.next(message: chatMessages['text'], isMe: authUser.uid == currentMsgUserId);
                } else {
                  return MessageBubble.first(userImage: chatMessages['userImage'], username: chatMessages['userName'], message: chatMessages['text'], isMe: authUser.uid == currentMsgUserId);
                }
              });
        });
  }
}
