import 'package:flutter/material.dart';
import '../store/chat_store.dart';
import '../provider_state.dart';

// ignore: must_be_immutable
class ChatInputField extends StatelessWidget {
  final ChatStore chatStore;
  ChatInputField({super.key, required this.chatStore});

  final TextEditingController _controller = TextEditingController();
  String? refreshToken = ProviderState.getRefreshToken();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.camera_alt), onPressed: () {}),
          IconButton(icon: const Icon(Icons.photo), onPressed: () {}),
          IconButton(icon: const Icon(Icons.insert_drive_file), onPressed: () {}),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Message",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey[200],
                filled: true,
              ),
              onSubmitted: (value) {
                chatStore.sendMessage(value, refreshToken);
                _controller.clear();
              },
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              chatStore.sendMessage(_controller.text, refreshToken);
              _controller.clear();
            },
          ),
        ],
      ),
    );
  }
}