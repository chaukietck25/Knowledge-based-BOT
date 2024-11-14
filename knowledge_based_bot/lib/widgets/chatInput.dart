import 'package:flutter/material.dart';

class ChatInput extends StatelessWidget {
  final Function(String) onSendMessage;
  final VoidCallback onSendImage;

  const ChatInput({
    super.key,
    required this.onSendMessage,
    required this.onSendImage,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: onSendImage,
          ),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Enter your message',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              onSendMessage(controller.text);
              controller.clear();
            },
          ),
        ],
      ),
    );
  }
}