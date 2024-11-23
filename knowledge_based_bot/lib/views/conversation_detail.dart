// lib/Views/conversation_detail.dart
import 'package:flutter/material.dart';
import 'package:knowledge_based_bot/store/chat_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ConversationDetail extends StatefulWidget {
  final String conversationId;

  const ConversationDetail({Key? key, required this.conversationId})
      : super(key: key);

  @override
  _ConversationDetailState createState() => _ConversationDetailState();
}

class _ConversationDetailState extends State<ConversationDetail> {
  final ChatStore chatStore = ChatStore();

  @override
  void initState() {
    super.initState();
    // Fetch detailed conversation using the conversationId
    chatStore.fetchConversationDetails(widget.conversationId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversation Detail',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Observer(
          builder: (_) {
            if (chatStore.isLoadingDetail) {
              return const Center(child: CircularProgressIndicator());
            } else if (chatStore.conversationDetail == null) {
              return const Center(child: Text('Conversation not found.'));
            } else {
              final detail = chatStore.conversationDetail!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    detail.title,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Created at: ${detail.formattedDate}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const Divider(height: 20, thickness: 2),
                  Expanded(
                    child: ListView.builder(
                      itemCount: detail.messages.length,
                      itemBuilder: (context, index) {
                        final message = detail.messages[index];
                        return Align(
                          alignment: message.isCurrentUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: message.isCurrentUser
                                  ? Colors.blue[100]
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(message.text),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}