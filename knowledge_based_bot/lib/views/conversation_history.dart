// lib/Views/conversation_history_screen.dart
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:knowledge_based_bot/views/ads/interstitial_ad.dart';
import 'package:knowledge_based_bot/views/bot_management/bot_management_screen.dart';
import 'package:knowledge_based_bot/Views/bot_screen.dart';
import 'package:knowledge_based_bot/Views/chat_screen.dart';
import 'package:knowledge_based_bot/Views/prompts%20library/prompts_library_screens.dart';
import 'package:knowledge_based_bot/Views/createBotScreen.dart';
import 'package:knowledge_based_bot/Views/prompt_library_screen.dart';
import 'package:knowledge_based_bot/store/chat_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart'; // Import intl for date formatting

import 'package:knowledge_based_bot/store/prompt_store.dart';
import 'package:knowledge_based_bot/Views/conversation_detail.dart'; // Import ConversationDetail
import '../../provider_state.dart';

class ConversationHistory extends StatefulWidget {
  const ConversationHistory({super.key});

  @override
  State<ConversationHistory> createState() => _ConversationHistoryState();
}

class _ConversationHistoryState extends State<ConversationHistory> {
  final ChatStore chatStore = ChatStore();
  String? refeshToken = ProviderState.getRefreshToken();

  @override
  void initState() {
    super.initState();
    chatStore.fetchConversations(refeshToken); // Replace with your actual token

    InterstitialAds.loadInterstitialAd();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Conversation History', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.add, color: Color.fromARGB(255, 81, 80, 80)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Observer(
          builder: (_) {
            if (chatStore.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (chatStore.conversationItems.isEmpty) {
              return const Center(child: Text('No conversations found.'));
            } else {
              return ListView.builder(
                itemCount: chatStore.conversationItems.length,
                itemBuilder: (context, index) {
                  final item = chatStore.conversationItems[index];
                  return _buildOptionButton(context, item.title, item.createdAt, item.id);
                },
              );
            }
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        bottom: false,
        child: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.circle, color: Colors.black, size: 30),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.memory, color: Colors.black, size: 30),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BotScreen()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.add_box_outlined,
                    color: Colors.black, size: 30),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateBotScreen()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.search, color: Colors.black, size: 30),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MonicaSearch()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.bookmark,
                    color: Colors.black, size: 30),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PromptLibraryScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, String title, int createdAt, String id) {
    // Convert epoch seconds to DateTime
    DateTime date = DateTime.fromMillisecondsSinceEpoch(createdAt * 1000);
    // Format DateTime to 'dd-MM-yyyy HH:mm'
    String formattedDate = DateFormat('dd-MM-yyyy HH:mm').format(date);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          backgroundColor: Colors.grey[200],
          foregroundColor: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () {
          // Navigate to ConversationDetail with the specific conversationId
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConversationDetail(conversationId: id),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              formattedDate,
              style: const TextStyle(color: Color.fromARGB(255, 162, 160, 160)),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_forward_ios,
                size: 15, color: Color.fromARGB(255, 162, 160, 160)),
          ],
        ),
      ),
    );
  }
}

void showPromptOverlay(BuildContext context) {
  final PromptStore promptStore = PromptStore();
  final prompts = promptStore.prompts;
  OverlayState overlayState = Overlay.of(context);
  late OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 150,
      left: MediaQuery.of(context).size.width * 0.1,
      right: MediaQuery.of(context).size.width * 0.6,
      child: Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(10),
        child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
                height: 60,
                width: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Open Prompt Library'),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => const PromptLibraryModal(),
                                isScrollControlled: true,
                              );

                              overlayEntry.remove();
                            },
                            child: const Text('Open')),
                        ElevatedButton(
                          onPressed: () {
                            overlayEntry.remove();
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    )
                  ],
                ))),
      ),
    ),
  );

  overlayState.insert(overlayEntry);
}