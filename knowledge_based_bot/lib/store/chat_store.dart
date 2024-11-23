// lib/store/chat_store.dart
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../data/models/message_chart.dart';
import '../data/models/response_chat.dart';

part 'chat_store.g.dart';

class ChatStore = _ChatStore with _$ChatStore;

abstract class _ChatStore with Store {
  @observable
  ObservableList<Message> messages = ObservableList<Message>();

  @observable
  bool isLoading = false;

  @observable
  String typeAI = 'gpt-4o-mini'; // Make it non-nullable

  @observable
  String? conversationId; // Store conversation ID after first message

  @action
  void setTypeAI(String newTypeAI) { // Accept non-nullable String
    typeAI = newTypeAI;
  }

  @action
  Future<void> sendMessage(String text, String? refreshToken) async {
    if (text.isEmpty) return;

    // Add user's message to the chat
    messages.insert(0, Message(text: text, sender: 'You', isCurrentUser: true));

    isLoading = true;

    try {
      http.Response response;

      if (conversationId == null) {
        print("lan 1");
        print('conversationId in do ai: $conversationId');
        // First message: initiate new conversation
        final body = {
          "assistant": {"id": typeAI, "model": "dify"},
          "content": text,
        };

        response = await http.post(
          Uri.parse('https://api.dev.jarvis.cx/api/v1/ai-chat'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $refreshToken',
          },
          body: json.encode(body),
        );
        conversationId = json.decode(response.body)['conversationId'];
        print("conversationId after fetching DO AI: $conversationId");

      } else {
        print('conversationId in chat msg: $conversationId');
        print("lan 2+");
        // Subsequent messages: continue existing conversation
        final body = {
          "content": text,
          "metadata": {
            "conversation": {
              "id": conversationId,
              "messages": _buildPreviousMessages(),
            }
          },
          "assistant": {
            "id": typeAI,
            "model": "dify",
            "name": _getAssistantName(typeAI),
          }
        };

        print("chat msg body: $body");

        response = await http.post(
          Uri.parse('https://api.dev.jarvis.cx/api/v1/ai-chat/messages'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $refreshToken',
          },
          body: json.encode(body),
        );
      }

      if (response.statusCode == 200) {
        // Parse the response using ChatResponse
        final data = json.decode(response.body);
        final chatResponse = ChatResponse.fromJson(data);

        // Store conversation ID from first message
        if (conversationId == null && chatResponse.conversationId != null) {
          conversationId = chatResponse.conversationId;
        }

        // Add AI's response to the chat
        messages.insert(
          0,
          Message(
            text: chatResponse.message,
            sender: 'AI',
            isCurrentUser: false,
            assistant: Assistant(
              id: typeAI,
              model: 'dify',
              name: _getAssistantName(typeAI),
            ),
          ),
        );
      } else {
        // Handle error
        messages.insert(
          0,
          Message(
            text: 'An error occurred: ${response.statusCode}',
            sender: 'System',
            isCurrentUser: false,
          ),
        );
      }
    } catch (e) {
      messages.insert(
        0,
        Message(
          text: 'An exception occurred: $e',
          sender: 'System',
          isCurrentUser: false,
        ),
      );
    }

    isLoading = false;
  }

  List<Map<String, dynamic>> _buildPreviousMessages() {
    // Build the list of previous messages to include in the metadata
    List<Map<String, dynamic>> previousMessages = [];

    // Since messages are inserted at the beginning of the list, we need to reverse it
    final reversedMessages = messages.reversed.toList();

    for (var message in reversedMessages) {
      previousMessages.add({
        "role": message.isCurrentUser ? "user" : "model",
        "content": message.text,
        if (!message.isCurrentUser && message.assistant != null)
          "assistant": message.assistant!.toJson(),
      });
    }

    return previousMessages;
  }

  String _getAssistantName(String typeAI) {
    // Map of typeAI to assistant names
    Map<String, String> assistantNames = {
      'gpt-4o-mini': 'GPT-4o-mini',
      'gpt-4o': 'GPT-4o',
      'claude-3-haiku-20240307': 'Claude-3 (Haiku)',
      'claude-3-5-sonnet-20240620': 'Claude-3.5 (Sonnet)',
      'gemini-1.5-flash-latest': 'Gemini-1.5 flash',
      'gemini-1.5-pro-latest': 'Gemini-1.5 pro',
    };

    return assistantNames[typeAI] ?? 'Unknown Assistant';
  }

  @action
  void resetConversation() {
    messages.clear();
    conversationId = null;
  }
  @action
  String? getConversationId() {
    return conversationId!;
  }
}