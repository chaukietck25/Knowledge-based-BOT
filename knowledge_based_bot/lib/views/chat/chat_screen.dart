import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:knowledge_based_bot/views/ads/interstitial_ad.dart';
import 'package:knowledge_based_bot/views/conversation/conversation_history.dart';
import '../../store/chat_store.dart';
import 'package:knowledge_based_bot/widgets/chat_input_field.dart';
import 'package:knowledge_based_bot/widgets/chat_bubble.dart';
import 'package:knowledge_based_bot/views/bot_management/add_bot_screen.dart';
import '../../data/models/message_model.dart';
import '../../data/models/assistant.dart';

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

    if (!kIsWeb) {
      InterstitialAds.loadInterstitialAd();
    }
  }

  Future<void> _showScrollableMenu() async {
    final entries = [
      PopupMenuItem<String>(value: 'create_bot', child: Text("Create Bot")),
      ...chatStore.defaultAssistants.entries.map((entry) {
        return PopupMenuItem<String>(
          value: entry.key,
          child: Text(entry.value),
        );
      }).toList(),
      ...chatStore.fetchedAssistants.map((assistant) {
        return PopupMenuItem<String>(
          value: assistant.id,
          child: Text(assistant.assistantName),
        );
      }).toList(),
    ];

    final selectedValue = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select AI Assistant"),
          content: Container(
            width: double.maxFinite,
            height: 300, // fixed height to allow scrolling
            child: Scrollbar(
              child: ListView(
                shrinkWrap: true,
                children: entries.map((e) {
                  // Thay vì PopupMenuItem, ta dùng InkWell hoặc GestureDetector
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pop(e.value);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: e.child,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );

    if (selectedValue != null) {
      if (selectedValue == 'create_bot') {
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
          String assistantName = chatStore.defaultAssistants[selectedValue] ??
              chatStore.fetchedAssistants
                  .firstWhere(
                    (a) => a.id == selectedValue,
                    orElse: () => Assistant(
                      id: selectedValue,
                      assistantName: 'Unknown Assistant',
                    ),
                  )
                  .assistantName;
          chatTitle = "Chat with $assistantName";
          chatStore.setTypeAI(selectedValue);
        });
      }
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
              _showScrollableMenu();
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
