import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewChatMsg extends StatefulWidget {
  const NewChatMsg({super.key});

  @override
  State<NewChatMsg> createState() => _NewChatMsgState();
}

class _NewChatMsgState extends State<NewChatMsg> {
  final _msgCntrl = TextEditingController();

  @override
  void dispose() {
    _msgCntrl.dispose();
    super.dispose();
  }

  void sendMsg() async {
    final msg = _msgCntrl.text;
    if (msg.trim().isEmpty) {
      return;
    }
    _msgCntrl.clear();
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    FirebaseFirestore.instance.collection('chat').add({
      'text': msg,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'userName': userData.data()!['user_name'],
      'userImage': userData.data()!['img_url'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 14,
        bottom: 15,
        right: 1,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _msgCntrl,
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(
                  label: Text('Send Message',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 18,
                          ))),
            ),
          ),
          IconButton(color: Theme.of(context).colorScheme.primary, onPressed: sendMsg, icon: const Icon(Icons.send))
        ],
      ),
    );
  }
}
