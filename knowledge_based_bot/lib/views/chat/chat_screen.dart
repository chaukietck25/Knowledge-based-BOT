import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:knowledge_based_bot/views/ads/interstitial_ad.dart';
import 'package:knowledge_based_bot/views/conversation/conversation_history.dart';
import '../../store/chat_store.dart';
import 'package:knowledge_based_bot/widgets/chat_input_field.dart';
import 'package:knowledge_based_bot/widgets/chat_bubble.dart';
import 'package:knowledge_based_bot/views/bot_management/add_bot_screen.dart';
import '../../data/models/assistant.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatStore chatStore = ChatStore();
  String chatTitle = "GPT-4o-mini";
  // Định nghĩa bản đồ liên kết assistant ID với đường dẫn icon
  final Map<String, String> assistantIcons = {
    'gpt-4o-mini': 'assets/images/gpt4o_mini.png',
    'gpt-4o': 'assets/images/gpt4o_mini.png',
    'claude-3-haiku-20240307': 'assets/images/claude3_haiku.png',
    'claude-3-5-sonnet-20240620': 'assets/images/claude3_haiku.png',
    'gemini-1.5-flash-latest': 'assets/images/gemini1_5_flash.png',
    'gemini-1.5-pro-latest': 'assets/images/gemini1_5_flash.png',
  };

  @override
  void initState() {
    super.initState();
    // Removed duplicate fetchToken call from constructor
    // chatStore.fetchAssistants();
    // chatStore.fetchToken();

    // Chỉ tải quảng cáo nếu không phải chạy trên web
    if (!kIsWeb) {
      InterstitialAds.loadInterstitialAd();
    }
  }

  /// Hàm hiển thị menu chọn AI Assistant (có cả tùy chọn "Create Bot")
  Future<void> _showScrollableMenu() async {
    final theme = Theme.of(context);

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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "Select AI Assistant",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Container(
            width: double.maxFinite,
            height: 300,
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView(
                shrinkWrap: true,
                children: entries.map((entry) {
                  final isCreateBot = entry.value == 'create_bot';
                  final String? assistantId =
                      isCreateBot ? null : entry.value;
                  // Lấy đường dẫn icon nếu có
                  String? iconPath;
                  if (!isCreateBot) {
                    iconPath = assistantIcons[entry.value];
                  }

                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pop(entry.value);
                    },
                    splashColor: theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isCreateBot
                            ? theme.primaryColor.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          if (isCreateBot)
                            Icon(
                              Icons.add_circle_outline,
                              color: theme.primaryColor,
                            )
                          else if (iconPath != null)
                            Image.asset(
                              iconPath,
                              width: 24,
                              height: 24,
                            )
                          else
                            Icon(
                              Icons.android,
                              color: Colors.grey,
                            ),
                          const SizedBox(width: 12),
                          DefaultTextStyle(
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            child: entry.child ?? const SizedBox(),
                          ),
                        ],
                      ),
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddBotScreen(),
          ),
        ).then((_) {
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
          chatTitle = assistantName;
          chatStore.setTypeAI(selectedValue);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chatTitle,
              style: TextStyle(color: Colors.black),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Observer(
              builder: (_) => Text(
                '${chatStore.availableTokensText}',
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
            ),
          ],
        ),
        actions: [
          // Reset chat
          IconButton(
            icon: const Icon(Icons.add, color: Color.fromARGB(255, 81, 80, 80)),
            onPressed: () {
              setState(() {
                chatTitle =
                    "${chatStore.defaultAssistants[chatStore.typeAI] ?? 'Unknown'}";
                chatStore.resetConversation();
              });
            },
            tooltip: 'Reset Chat',
          ),
          // Mở conversation history
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
            tooltip: 'Conversation History',
          ),
          // Hiển thị danh sách AI Assistant
          IconButton(
            icon: const Icon(Icons.arrow_drop_down_circle,
                color: Color.fromARGB(255, 81, 80, 80)),
            onPressed: _showScrollableMenu,
            tooltip: 'Select AI Assistant',
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          // Danh sách tin nhắn
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
          // Hiển thị loading indicator nếu đang chờ bot trả lời
          if (chatStore.isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          // Ô nhập tin nhắn
          ChatInputField(chatStore: chatStore),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}