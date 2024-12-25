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
  String chatTitle = "Chat with GPT-4o-mini";

  @override
  void initState() {
    super.initState();
    chatStore.fetchAssistants();

    // Chỉ tải quảng cáo nếu không phải chạy trên web
    if (!kIsWeb) {
      InterstitialAds.loadInterstitialAd();
    }
  }

  /// Hàm hiển thị menu chọn AI Assistant (có cả tùy chọn "Create Bot")
  Future<void> _showScrollableMenu() async {
    // Lấy theme hiện tại của context để dùng màu và style
    final theme = Theme.of(context);

    // Chuẩn bị danh sách các menu item
    final entries = [
      // Mục đặc biệt: Create Bot
      PopupMenuItem<String>(value: 'create_bot', child: Text("Create Bot")),
      // Mục defaultAssistants (những assistant mặc định)
      ...chatStore.defaultAssistants.entries.map((entry) {
        return PopupMenuItem<String>(
          value: entry.key,
          child: Text(entry.value),
        );
      }).toList(),
      // Mục fetchedAssistants (những assistant lấy về từ server)
      ...chatStore.fetchedAssistants.map((assistant) {
        return PopupMenuItem<String>(
          value: assistant.id,
          child: Text(assistant.assistantName),
        );
      }).toList(),
    ];

    // Hiển thị một dialog tùy biến, chứa list scrollable
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
            height: 300, // Chiều cao cố định để có thể scroll
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView(
                shrinkWrap: true,
                children: entries.map((entry) {
                  // Kiểm tra xem item hiện tại có phải "Create Bot" không
                  final isCreateBot = entry.value == 'create_bot';

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
                          Icon(
                            isCreateBot
                                ? Icons.add_circle_outline
                                : Icons.android,
                            color: isCreateBot
                                ? theme.primaryColor
                                : Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          // Nếu là Create Bot thì tô đậm, đổi màu
                          DefaultTextStyle(
                            style: isCreateBot
                                ? theme.textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.primaryColor,
                                  )
                                : theme.textTheme.bodyMedium!,
                            // SỬA LỖI Ở DÒNG NÀY:
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

    // Xử lý logic sau khi người dùng chọn 1 item trong menu
    if (selectedValue != null) {
      if (selectedValue == 'create_bot') {
        // Chuyển đến trang AddBotScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddBotScreen(),
          ),
        ).then((_) {
          // Sau khi tạo bot xong, fetch lại danh sách Assistants
          chatStore.fetchAssistants();
        });
      } else {
        setState(() {
          // Lấy tên assistant từ defaultAssistants hoặc fetchedAssistants
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
          // Hiển thị số token còn lại
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
          // Reset chat
          IconButton(
            icon: const Icon(Icons.add, color: Color.fromARGB(255, 81, 80, 80)),
            onPressed: () {
              setState(() {
                chatTitle =
                    "Chat with ${chatStore.defaultAssistants[chatStore.typeAI] ?? 'Unknown'}";
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
