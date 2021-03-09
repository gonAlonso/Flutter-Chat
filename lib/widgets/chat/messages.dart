import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      builder: (ctx, futureSnapshot) =>
          (futureSnapshot.connectionState == ConnectionState.waiting)
              ? Center(child: CircularProgressIndicator())
              : StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('chat')
                      .orderBy('date', descending: true)
                      .snapshots(),
                  builder: (ctx, chatSnapshot) {
                    if (chatSnapshot.connectionState == ConnectionState.waiting)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    final chatDoc = chatSnapshot.data.docs;
                    return ListView.builder(
                      reverse: true,
                      itemCount: chatDoc.length,
                      itemBuilder: (ctx, ind) => MessageBubble(
                        message: chatDoc[ind].data()['text'],
                        isMe: chatDoc[ind].data()['uid'] == user.uid,
                        key: ValueKey(chatDoc[ind].id),
                        userId: chatDoc[ind].data()['uid'],
                        username: chatDoc[ind].data()['username'],
                        imageUrl: chatDoc[ind].data()['userimage'],
                      ),
                    );
                  },
                ),
    );
  }
}
