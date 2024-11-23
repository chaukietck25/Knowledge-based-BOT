// chat_store.dart
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
  List<String> conversationTitles = [];

  @observable
  String? typeAI = 'gpt-4o-mini'; // Default AI model

  @action
  void setTypeAI(String? newTypeAI) {
    typeAI = newTypeAI;
  }

  @action
  Future<void> sendMessage(String text, String? refeshToken) async {
    if (text.isEmpty) return;

    // Add user's message to the chat
    messages.insert(0, Message(text: text, sender: 'You', isCurrentUser: true));

    isLoading = true;

    // Prepare the request body
    final body = {
      "assistant": {"id": typeAI, "model": "dify"},
      "content": text,
    };

    try {
      // Make the POST request
      final response = await http.post(
        Uri.parse('https://api.dev.jarvis.cx/api/v1/ai-chat'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $refeshToken', // Replace with your token
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        // Parse the response using ChatResponse
        final data = json.decode(response.body);
        final chatResponse = ChatResponse.fromJson(data);

        // Add AI's response to the chat
        messages.insert(
          0,
          Message(
            text: chatResponse.message,
            sender: 'AI',
            isCurrentUser: false,
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

  @action
  Future<void> fetchConversations(String? refeshToken) async {
    var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $refeshToken'};

    isLoading = true;

    var request = http.Request(
        'GET',
        Uri.parse(
            'https://api.dev.jarvis.cx/api/v1/ai-chat/conversations?assistantId=$typeAI&assistantModel=dify'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseBody);
      var conversations = jsonResponse['items'] as List;
      conversationTitles =
          conversations.map((item) => item['title'] as String).toList();
    } else {
      print(response.reasonPhrase);

    }
    isLoading = false;
  }
}
