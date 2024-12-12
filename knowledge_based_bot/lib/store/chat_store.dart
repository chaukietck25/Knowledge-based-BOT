// lib/store/chat_store.dart
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../data/models/message_chart.dart';
import '../data/models/conservation_item.dart';
import '../data/models/conservation_detail_model.dart';
import '../../provider_state.dart';
import '../data/models/chat_response.dart';

part 'chat_store.g.dart';

class ChatStore = _ChatStore with _$ChatStore;

abstract class _ChatStore with Store {
  @observable
  bool isLoadingDetail = false;
  @observable
  int remainingUsage = 0;

  @observable
  ConversationDetailModel? conversationDetail;

  @action
  Future<void> fetchConversationDetails(String conversationId) async {
    print("conversationId in fetchConversationDetails: $conversationId");
    isLoadingDetail = true;
    String? refreshToken = ProviderState.getRefreshToken();
    String? accessToken = ProviderState.getAccessToken();
    print("accessToken in fetchConversationDetails: $accessToken");

    try {
      // Correctly construct the URI with path parameters and query parameters
      final Uri uri = Uri.https(
        'api.jarvis.cx',
        '/api/v1/ai-chat/conversations/$conversationId/messages',
        {
          'assistantId': 'gpt-4o-mini',
          'assistantModel': 'dify',
        },
      );

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      print("response in fetchConversationDetails: ${response.body}");
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        conversationDetail = ConversationDetailModel.fromJson(data);
      } else {
        print('Failed to load conversation details: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    } catch (e) {
      print('Error fetching conversation details: $e');
    }

    isLoadingDetail = false;
  }

  @observable
  ObservableList<Message> messages = ObservableList<Message>();

  @observable
  ObservableList<ConversationItem> conversationItems =
      ObservableList<ConversationItem>();

  @observable
  bool isLoading = false;

  @observable
  String typeAI = 'gpt-4o-mini'; // Default AI model

  @observable
  String? conversationId; // Store conversation ID after first message

  @action
  void setTypeAI(String newTypeAI) {
    // Accept non-nullable String
    typeAI = newTypeAI;
    resetConversation();
  }

  @action
  Future<void> fetchConversations(String? accessToken) async {
    isLoading = true;
    print("accessToken in fetconservation: $accessToken");

    try {
      final response = await http.get(
        Uri.parse(
            'https://api.jarvis.cx/api/v1/ai-chat/conversations?assistantId=gpt-4o-mini&assistantModel=dify'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> items = data['items'];

        conversationItems.clear();
        for (var item in items) {
          conversationItems.add(ConversationItem.fromJson(item));
        }
      } else {
        print('Failed to load conversations: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching conversations: $e');
    }

    isLoading = false;
  }

  @action
  Future<void> sendMessage(String text, String? accessToken) async {
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
        print("chat accessToken: $accessToken");

        response = await http.post(
          Uri.parse('https://api.jarvis.cx/api/v1/ai-chat'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          body: json.encode(body),
        );
         
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
          Uri.parse('https://api.jarvis.cx/api/v1/ai-chat/messages'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          body: json.encode(body),
        );
      }

      print('response chat msg: ${response.body}');

      if (response.statusCode == 200) {
        // Parse the response using ChatResponse
        final data = json.decode(response.body);
        final chatResponse = ChatResponse.fromJson(data);

        // Store conversation ID from first message
        if (conversationId == null && chatResponse.conversationId != null) {
          conversationId = chatResponse.conversationId;
          print('conversationId after response: $conversationId');
        }
        remainingUsage = chatResponse.remainingUsage;
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
  String getConversationId() {
    return conversationId ?? '';
  }
}
