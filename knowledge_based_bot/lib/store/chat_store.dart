import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../data/models/assistant.dart';
import '../data/models/conservation_item.dart';
import '../data/models/conservation_detail_model.dart';
import '../../provider_state.dart';
import '../data/models/chat_response.dart';
import '../data/models/message_model.dart'; // Ensure correct import

part 'chat_store.g.dart';

class ChatStore = _ChatStore with _$ChatStore;

abstract class _ChatStore with Store {
  @observable
  bool isLoadingDetail = false;

  @observable
  int remainingUsage = 0;

  @observable
  ConversationDetailModel? conversationDetail;

  @observable
  ObservableList<Assistant> fetchedAssistants = ObservableList<Assistant>();

  @observable
  ObservableList<MessageModel> messages = ObservableList<MessageModel>();

  @observable
  ObservableList<ConversationItem> conversationItems =
      ObservableList<ConversationItem>();

  @observable
  bool isLoading = false;

  @observable
  String typeAI = 'gpt-4o-mini'; // Default AI model

  @observable
  String? conversationId; // Store conversation ID after first message

  // Default assistants
  final Map<String, String> defaultAssistants = {
    'gpt-4o-mini': 'GPT-4o-mini',
    'gpt-4o': 'GPT-4o',
    'claude-3-haiku-20240307': 'Claude-3 (Haiku)',
    'claude-3-5-sonnet-20240620': 'Claude-3.5 (Sonnet)',
    'gemini-1.5-flash-latest': 'Gemini-1.5-flash',
    'gemini-1.5-pro-latest': 'Gemini-1.5-pro',
  };

  _ChatStore() {
    fetchAssistants();
  }

  @action
  Future<void> fetchAssistants() async {
    final String? token =
        ProviderState.externalAccessToken; // Replace with your actual token
    final Uri uri =
        Uri.parse('https://knowledge-api.jarvis.cx/kb-core/v1/ai-assistant');

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> assistantsData = data['data'];
        fetchedAssistants.clear();
        for (var assistant in assistantsData) {
          fetchedAssistants
              .add(_mapApiAssistantToMessageChartAssistant(assistant));
        }
      } else {
        print('Failed to load assistants: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching assistants: $e');
    }
  }

  // Single definition of the mapping function
  Assistant _mapApiAssistantToMessageChartAssistant(Map<String, dynamic> json) {
    return Assistant.fromJson(json);
  }

  @action
  Future<void> fetchConversationDetails(String conversationId) async {
    print("conversationId in fetchConversationDetails: $conversationId");
    isLoadingDetail = true;
    
    String? accessToken = ProviderState.getAccessToken();
    print("accessToken in fetchConversationDetails: $accessToken");

    try {
      // Correctly construct the URI with path parameters and query parameters
      final Uri uri = Uri.https(
        'api.jarvis.cx',
        '/api/v1/ai-chat/conversations/$conversationId/messages',
        {
          'assistantId': typeAI,
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

  @action
  Future<void> fetchConversations(String? accessToken) async {
    isLoading = true;
    print("accessToken in fetchConversations: $accessToken");

    try {
      final response = await http.get(
        Uri.parse(
            'https://api.jarvis.cx/api/v1/ai-chat/conversations?assistantId=$typeAI&assistantModel=dify'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> items = data['data'] ?? data['items'];

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

  // lib/store/chat_store.dart
  @action
  Future<void> sendMessage(String text, String? accessToken) async {
    if (text.isEmpty) return;

    // Add user's message to the chat
    messages.insert(
      0,
      MessageModel(
        text: text,
        sender: 'You',
        isCurrentUser: true,
      ),
    );

    isLoading = true;

    try {
      http.Response response;
      final Assistant? currentAssistant = _getCurrentAssistant();

      if (currentAssistant == null) {
        throw Exception('No assistant selected');
      }

      if (currentAssistant.isDefault) {
        // Handle default assistants using existing logic
        if (conversationId == null) {
          // First message: initiate new conversation
          final body = {
            "assistant": {"id": typeAI, "model": "dify"},
            "content": text,
          };
          response = await http.post(
            Uri.parse('https://api.jarvis.cx/api/v1/ai-chat'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
            body: json.encode(body),
          );
        } else {
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
              "assistantName": _getAssistantName(typeAI),
            }
          };

          response = await http.post(
            Uri.parse('https://api.jarvis.cx/api/v1/ai-chat/messages'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
            body: json.encode(body),
          );
        }
      } else {
        // Handle non-default assistants using the new endpoint
        final String assistantId = currentAssistant.id; // Corrected usage
        final String openAiThreadId = currentAssistant.openAiThreadIdPlay ?? '';

        if (openAiThreadId.isEmpty) {
          throw Exception('Missing openAiThreadIdPlay for the assistant');
        }

        final Uri uri = Uri.parse(
            'https://knowledge-api.jarvis.cx/kb-core/v1/ai-assistant/$assistantId/ask'); // Correct endpoint

        final body = {
          "message": text,
          "openAiThreadId": openAiThreadId,
          "additionalInstruction": ""
        };
        String? externalAccessToken=ProviderState.externalAccessToken;
        response = await http.post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $externalAccessToken',
          },
          body: json.encode(body),
        );
      }

      print('response chat msg: ${response.body}');

      if (response.statusCode == 200) {
        // Parse the response using ChatResponse
        final data = json.decode(response.body);
        final chatResponse = ChatResponse.fromJson(data);

        if (currentAssistant.isDefault) {
          // Store conversation ID from first message
          if (conversationId == null && chatResponse.conversationId != null) {
            conversationId = chatResponse.conversationId;
            print('conversationId after response: $conversationId');
          }
        } else {
          // For non-default assistants, update openAiThreadIdPlay if provided
          if (data['openAiThreadIdPlay'] != null) {
            currentAssistant.openAiThreadIdPlay = data['openAiThreadIdPlay'];
          }
        }

        remainingUsage = chatResponse.remainingUsage;

        // Add AI's response to the chat
        messages.insert(
          0,
          MessageModel(
            text: chatResponse.message,
            sender: 'AI',
            isCurrentUser: false,
            assistant: Assistant(
              id: currentAssistant.id, // Corrected usage
              assistantName: _getAssistantName(typeAI),
              isDefault: currentAssistant.isDefault,
              openAiThreadIdPlay: currentAssistant.openAiThreadIdPlay,
            ),
          ),
        );
      } else {
        // Handle error
        messages.insert(
          0,
          MessageModel(
            text: 'An error occurred: ${response.statusCode}',
            sender: 'System',
            isCurrentUser: false,
          ),
        );
      }
    } catch (e) {
      messages.insert(
        0,
        MessageModel(
          text: 'An exception occurred: $e',
          sender: 'System',
          isCurrentUser: false,
        ),
      );
    }

    isLoading = false;
  }

  // Helper method to get the current assistant object
  Assistant? _getCurrentAssistant() {
    if (defaultAssistants.containsKey(typeAI)) {
      return fetchedAssistants.firstWhere(
        (assistant) => assistant.id == typeAI,
        orElse: () => Assistant(
          id: typeAI,
          assistantName: defaultAssistants[typeAI] ?? 'Unknown Assistant',
          isDefault: true,
        ),
      );
    } else {
      return fetchedAssistants.firstWhere(
        (assistant) => assistant.id == typeAI,
        orElse: () => Assistant(
          id: typeAI,
          assistantName: 'Unknown Assistant',
          isDefault: false,
        ),
      );
    }
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
    // Map of typeAI to assistant names including fetched assistants
    if (defaultAssistants.containsKey(typeAI)) {
      return defaultAssistants[typeAI]!;
    } else {
      final fetched =
          fetchedAssistants.firstWhere((assistant) => assistant.id == typeAI,
              orElse: () => Assistant(
                    id: typeAI,
                    assistantName: 'Unknown Assistant',
                    isDefault: false,
                  ));
      return fetched.assistantName;
    }
  }

  @action
  void setTypeAI(String newTypeAI) {
    typeAI = newTypeAI;
    resetConversation();
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
