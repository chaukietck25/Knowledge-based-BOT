// lib/views/chat/chat_screen.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:knowledge_based_bot/views/ads/interstitial_ad.dart';
import 'package:knowledge_based_bot/views/conversation/conversation_history.dart';
import '../../store/chat_store.dart';
import 'package:knowledge_based_bot/widgets/chat_input_field.dart';
import 'package:knowledge_based_bot/widgets/chat_bubble.dart';
import 'package:knowledge_based_bot/views/bot_management/add_bot_screen.dart';
import '../../data/models/message_model.dart'; // Correct Import
import '../../data/models/assistant.dart'; // Ensure Assistant is imported from assistant.dart

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatStore chatStore = ChatStore();

  String chatTitle = "Chat with GPT-4o-mini";

  @override
  void initState() {
    super.initState();

    chatStore.fetchAssistants();


    if(!kIsWeb) {
      InterstitialAds.loadInterstitialAd();
    }
  }

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
            icon: const Icon(Icons.add, color: Color.fromARGB(255, 81, 80, 80)),
            onPressed: () {
              setState(() {
                chatTitle = "Chat with ${chatStore.defaultAssistants[chatStore.typeAI] ?? 'Unknown'}";
                chatStore.resetConversation();
              });
            },
            tooltip: 'Reset Chat',
          ),
          IconButton(
            icon: const Icon(Icons.history, color: Color.fromARGB(255, 81, 80, 80)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConversationHistory(),
                ),
              );
            },
            tooltip: 'Conversation History',
          ),
          IconButton(
            icon: const Icon(Icons.arrow_drop_down_circle, color: Color.fromARGB(255, 81, 80, 80)),
            onPressed: () {
              showMenu<String>(
                context: context,
                position: RelativeRect.fromLTRB(100, 80, 0, 0),
                items: [
                  PopupMenuItem(
                    child: Text("Create Bot"),
                    value: 'create_bot',
                  ),
                  // Default Assistants
                  ...chatStore.defaultAssistants.entries.map((entry) {
                    return PopupMenuItem(
                      child: Text(entry.value),
                      value: entry.key,
                    );
                  }).toList(),
                  // Fetched Assistants
                  ...chatStore.fetchedAssistants.map((assistant) {
                    return PopupMenuItem(
                      child: Text(assistant.assistantName),
                      value: assistant.id,
                    );
                  }).toList(),
                ],
              ).then((value) {
                if (value != null) {
                  if (value == 'create_bot') {
                    // Navigate to AddBotScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddBotScreen(),
                      ),
                    ).then((_) {
                      // Refresh assistants after adding a new bot
                      chatStore.fetchAssistants();
                    });
                  } else {
                    setState(() {
                      String assistantName = chatStore.defaultAssistants[value] ??
                          chatStore.fetchedAssistants
                              .firstWhere(
                                (a) => a.id == value,
                                orElse: () => Assistant(
                                  id: value,
                                  assistantName: 'Unknown Assistant', // Correct field
                                ),
                              )
                              .assistantName; // Use 'assistantName' instead of 'name'
                      chatTitle = "Chat with $assistantName";
                      chatStore.setTypeAI(value);
                    });
                  }
                }
              });
            },
            tooltip: 'Select AI Assistant',
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
                  return ChatBubble(message: message); // Correct usage
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
