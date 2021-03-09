import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final Key key;
  final String userId;
  final String username;
  final String imageUrl;

  MessageBubble({
    this.message,
    this.isMe,
    this.key,
    this.userId,
    this.username,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: isMe ? Radius.circular(12) : Radius.circular(12),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(0),
                ),
              ),
              width: 140,
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 8,
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isMe
                            ? Colors.black
                            : Theme.of(context).accentTextTheme.title.color),
                  ),
                  Text(
                    message,
                    textAlign: isMe ? TextAlign.end : TextAlign.left,
                    style: TextStyle(
                        color: isMe
                            ? Colors.black
                            : Theme.of(context).accentTextTheme.title.color),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
            top: 1,
            left: isMe ? null : 125,
            right: isMe ? 125 : null,
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(imageUrl),
            )),
      ],
    );
  }
}
