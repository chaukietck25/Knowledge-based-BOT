import 'package:flutter/material.dart';
import 'package:knowledge_based_bot/data/models/message_model.dart';

class ChatBubble extends StatelessWidget {
  final MessageModel message;

  ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final alignment = message.isCurrentUser
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;

    final bgColor =
        message.isCurrentUser ? Colors.blue[200] : Colors.grey[200];
    final textColor = Colors.black;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        if (message.sender.isNotEmpty)
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
            child: Text(
              message.sender,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            message.text,
            style: TextStyle(color: textColor),
          ),
        ),
      ],
    );
  }
}
