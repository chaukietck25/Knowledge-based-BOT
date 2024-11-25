// lib/views/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:knowledge_based_bot/views/conversation_history.dart';
import '../store/chat_store.dart';
import 'package:knowledge_based_bot/widgets/chat_input_field.dart';
import 'package:knowledge_based_bot/widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatStore chatStore = ChatStore();

  String chatTitle = "Chat with GPT-4o-mini";

  // Optional: Map typeAI to assistant display names
  final Map<String, String> assistantNames = {
    'gpt-4o-mini': 'GPT-4o-mini',
    'gpt-4o': 'GPT-4o',
    'claude-3-haiku-20240307': 'Claude-3 (Haiku)',
    'claude-3-5-sonnet-20240620': 'Claude-3.5 (Sonnet)',
    'gemini-1.5-flash-latest': 'Gemini-1.5-flash',
    'gemini-1.5-pro-latest': 'Gemini-1.5-pro',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          chatTitle,
          style: TextStyle(color: Colors.black),
        ),
        actions: [
           Observer(
            builder: (_) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(
                child: Text(
                  'TOKEN: ${chatStore.remainingUsage}',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add,
                color: Color.fromARGB(255, 81, 80, 80)),
            onPressed: () {
              setState(() {
                chatTitle = "Chat with ${assistantNames[chatStore.typeAI]}";
                chatStore.resetConversation();
              });
            },
          ),

          IconButton(
            icon: const Icon(Icons.history,
                color: Color.fromARGB(255, 81, 80, 80)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConversationHistory(),
                ),
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.arrow_drop_down_circle,
                color: Color.fromARGB(255, 81, 80, 80)),
            onPressed: () {
              showMenu<String>(
                context: context,
                position: RelativeRect.fromLTRB(100, 80, 0, 0),
                items: [
                  PopupMenuItem(
                    child: Text("Claude-3 (Haiku)"),
                    value: 'claude-3-haiku-20240307',
                  ),
                  PopupMenuItem(
                    child: Text("Claude-3.5 (Sonnet)"),
                    value: 'claude-3-5-sonnet-20240620',
                  ),
                  PopupMenuItem(
                    child: Text("Gemini-1.5-flash"),
                    value: 'gemini-1.5-flash-latest',
                  ),
                  PopupMenuItem(
                    child: Text("Gemini-1.5-pro"),
                    value: 'gemini-1.5-pro-latest',
                  ),
                  PopupMenuItem(
                    child: Text("GPT-4o"),
                    value: 'gpt-4o',
                  ),
                  PopupMenuItem(
                    child: Text("GPT-4o-mini"),
                    value: 'gpt-4o-mini',
                  ),
                ],
              ).then((value) {
                if (value != null) {
                  setState(() {
                    chatTitle = "Chat with ${assistantNames[value] ?? value}";
                    print("chatTitle: $chatTitle");
                    // chatStore.resetConversation();
                    chatStore.setTypeAI(value); // Now `value` is non-nullable
                  });
                }
              });
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Observer(
              builder: (_) => ListView.builder(
                itemCount: chatStore.messages.length,
                reverse: true,
                itemBuilder: (context, index) {
                  final message = chatStore.messages[index];
                  return ChatBubble(message: message);
                },
              ),
            ),
          ),
          if (chatStore.isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          ChatInputField(chatStore: chatStore),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}