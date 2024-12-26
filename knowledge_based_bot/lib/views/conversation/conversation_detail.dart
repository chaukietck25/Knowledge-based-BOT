// lib/Views/conversation_detail.dart

import 'package:flutter/material.dart';
import 'package:knowledge_based_bot/store/chat_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../data/models/message_model.dart';
import '../../provider_state.dart'; // For retrieving tokens and variables

class ConversationDetail extends StatefulWidget {
  final String conversationId;

  const ConversationDetail({Key? key, required this.conversationId})
      : super(key: key);

  @override
  _ConversationDetailState createState() => _ConversationDetailState();
}

class _ConversationDetailState extends State<ConversationDetail> {
  final ChatStore chatStore = ChatStore();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Fetch conversation details with the provided conversationId
    chatStore.fetchConversationDetails(widget.conversationId).then((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Scroll to the bottom of the chat list
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Handle sending a message
  void _handleSendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      // Use ProviderState to get the accessToken
      String? accessToken = ProviderState.getAccessToken();
      chatStore.sendMessage(text, accessToken).then((_) {
        _messageController.clear();
        _scrollToBottom();
      });
    }
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
      body: Column(
        children: [
          // Display Conversation Details (Title, Created At)
          Padding(
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
                      if (detail.items.isNotEmpty)
                        Text(
                          detail.items.first.query,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      if (detail.items.isNotEmpty) const SizedBox(height: 10),
                      if (detail.items.isNotEmpty)
                        Text(
                          'Created at: ${_formatTimestamp(detail.items.first.createdAt)}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      if (detail.items.isNotEmpty)
                        const Divider(height: 20, thickness: 2),
                    ],
                  );
                }
              },
            ),
          ),
          const Divider(height: 1),
          // Expanded Chat Messages List
          Expanded(
            child: Observer(
              builder: (_) {
                if (chatStore.isLoadingDetail) {
                  return const Center(child: CircularProgressIndicator());
                } else if (chatStore.messages.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                } else {
                  return ListView.builder(
                    controller: _scrollController,
                    reverse: true, // To show latest messages at the bottom
                    itemCount: chatStore.messages.length,
                    itemBuilder: (context, index) {
                      final message = chatStore.messages[index];
                      return _buildMessageBubble(message);
                    },
                  );
                }
              },
            ),
          ),
          const Divider(height: 1),
          // Chat Input Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            color: Colors.white,
            child: SafeArea(
              child: Row(
                children: [
                  // Text Input
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _handleSendMessage(),
                      decoration: const InputDecoration(
                        hintText: 'Type your message...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  // Send Button
                  Observer(
                    builder: (_) {
                      return IconButton(
                        icon: chatStore.isSending
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.send, color: Colors.blue),
                        onPressed: chatStore.isSending
                            ? null
                            : _handleSendMessage,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper method to format timestamp
  String _formatTimestamp(int epochSeconds) {
    final date = DateTime.fromMillisecondsSinceEpoch(epochSeconds * 1000);
    return "${date.day}-${date.month}-${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }

  /// Helper method to build message bubbles
  Widget _buildMessageBubble(MessageModel message) {
    final isCurrentUser = message.isCurrentUser;
    final alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    final color = isCurrentUser ? Colors.green[100] : Colors.blue[100];
    final textColor = Colors.black;

    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message.text,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
