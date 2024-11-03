import 'package:flutter/material.dart';
import 'dart:typed_data';

class ChatMessage extends StatelessWidget {
  final String? text;
  final Uint8List? imageBytes;
  final String? fileName;

  const ChatMessage({super.key, this.text, this.imageBytes, this.fileName, required String image});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: imageBytes != null
                    ? MemoryImage(imageBytes!)
                    : const AssetImage('assets/user_avatar.png') as ImageProvider,
              ),
              const SizedBox(width: 8),
              Text(fileName ?? 'User'),
            ],
          ),
          const SizedBox(height: 8),
          if (text != null) Text(text!),
          if (imageBytes != null)
            Container(
              margin: const EdgeInsets.only(top: 8),
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.memory(imageBytes!, fit: BoxFit.cover),
            ),
        ],
      ),
    );
  }
}