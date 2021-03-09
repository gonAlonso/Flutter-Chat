import 'dart:developer' as dev;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
  final _textController = TextEditingController();

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final userAuth = await FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .document(userAuth.uid)
        .get();
    Firestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'date': Timestamp.now(),
      'uid': userAuth.uid,
      'username': userData.data()['username'],
      'userimage': userData.data()['image_url'],
    });
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              autocorrect: true,
              textCapitalization: TextCapitalization.sentences,
              enableSuggestions: true,
              decoration: InputDecoration(labelText: 'Send a message..'),
              onChanged: (val) {
                setState(() {
                  _enteredMessage = val?.trim();
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            color: Theme.of(context).primaryColor,
            onPressed: (_enteredMessage.isEmpty) ? null : _sendMessage,
          ),
        ],
      ),
    );
  }
}
