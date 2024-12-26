// lib/store/chat_store.dart

import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

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
  bool isSending = false; // **Added**: Observable to track sending state

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
    final String? token = ProviderState.externalAccessToken;
    final Uri uri =
        Uri.parse('https://knowledge-api.dev.jarvis.cx/kb-core/v1/ai-assistant');

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
        // Log non-200 response
        FirebaseCrashlytics.instance.recordError(
          Exception('Failed to load assistants: ${response.statusCode}'),
          null,
          reason: 'fetchAssistants received non-200 response',
        );
      }
    } catch (e, stack) {
      print('Error fetching assistants: $e');
      FirebaseCrashlytics.instance.recordError(e, stack,
          reason: 'fetchAssistants exception');
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
    String? refreshToken = ProviderState.getRefreshToken();
    print("refreshToken in fetchConversationDetails: $refreshToken");

    try {
      final Uri uri = Uri.https(
        'api.dev.jarvis.cx', // **Updated Host**
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
          'Authorization': 'Bearer $refreshToken',
        },
      );
      print("response in fetchConversationDetails: ${response.body}");
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        conversationDetail = ConversationDetailModel.fromJson(data);
        
        // **Set the conversationId to indicate existing conversation**
        this.conversationId = conversationId;
        print('Set conversationId to: $conversationId');

        // Initialize messages from conversationDetail
        _initializeMessagesFromConversationDetail();
      } else {
        print('Failed to load conversation details: ${response.statusCode}');
        print('Response Body: ${response.body}');
        // Log non-200 response
        FirebaseCrashlytics.instance.recordError(
          Exception('Failed to load conversation details: ${response.statusCode}'),
          null,
          reason: 'fetchConversationDetails received non-200 response',
        );
      }
    } catch (e, stack) {
      print('Error fetching conversation details: $e');
      FirebaseCrashlytics.instance.recordError(e, stack,
          reason: 'fetchConversationDetails exception');
    }

    isLoadingDetail = false;
  }

  /// Helper method to initialize messages from conversationDetail
  void _initializeMessagesFromConversationDetail() {
    if (conversationDetail != null && conversationDetail!.items.isNotEmpty) {
      messages.clear();
      for (var item in conversationDetail!.items) {
        // User's message
        messages.add(MessageModel(
          text: item.query,
          sender: 'You',
          isCurrentUser: true,
        ));
        // AI's response
        messages.add(MessageModel(
          text: item.answer,
          sender: 'AI',
          isCurrentUser: false,
          assistant: Assistant(
            id: typeAI,
            assistantName: _getAssistantName(typeAI),
            isDefault: _getCurrentAssistant()?.isDefault ?? true,
            openAiThreadIdPlay: _getCurrentAssistant()?.openAiThreadIdPlay,
          ),
        ));
      }
    }
  }

  @action
  Future<void> fetchConversations(String? refreshToken) async {
    isLoading = true;
    print("refreshToken in fetchConversations: $refreshToken");

    try {
      final response = await http.get(
        Uri.parse(
            'https://api.dev.jarvis.cx/api/v1/ai-chat/conversations?assistantId=$typeAI&assistantModel=dify'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $refreshToken',
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
        // Log non-200 response
        FirebaseCrashlytics.instance.recordError(
          Exception('Failed to load conversations: ${response.statusCode}'),
          null,
          reason: 'fetchConversations received non-200 response',
        );
      }
    } catch (e, stack) {
      print('Error fetching conversations: $e');
      FirebaseCrashlytics.instance.recordError(e, stack,
          reason: 'fetchConversations exception');
    }

    isLoading = false;
  }

  @action
  Future<void> sendMessage(String text, String? refreshToken) async {
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

    isSending = true; // **Set isSending to true**
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
          print("lan 1");
          print("send request to uri: https://api.dev.jarvis.cx/api/v1/ai-chat");
          print("send request with body: $body");
          print("accessToken: $refreshToken");

          response = await http.post(
            Uri.parse('https://api.dev.jarvis.cx/api/v1/ai-chat'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $refreshToken',
            },
            body: json.encode(body),
          );
          print("response chat msg 1: ${response.body}");
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
          print("lan 2");
          print("send request to uri: https://api.dev.jarvis.cx/api/v1/ai-chat/messages");
          print("send request with body: $body");
          print("refreshToken: $refreshToken");

          response = await http.post(
            Uri.parse('https://api.dev.jarvis.cx/api/v1/ai-chat/messages'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $refreshToken',
            },
            body: json.encode(body),
          );
          print("response chat msg 2+: ${response.body}");
        }
      } else {
        // Handle non-default assistants
        final String assistantId = currentAssistant.id;
        final String openAiThreadId = currentAssistant.openAiThreadIdPlay ?? '';

        if (openAiThreadId.isEmpty) {
          print('Warning: openAiThreadIdPlay is empty. Proceeding without it.');
        }

        final Uri uri = Uri.parse(
            'https://knowledge-api.dev.jarvis.cx/kb-core/v1/ai-assistant/$assistantId/ask');

        final requestBody = {
          "message": text,
          "openAiThreadId": openAiThreadId.isNotEmpty ? openAiThreadId : null,
          "additionalInstruction": ""
        };

        String? externalAccessToken = ProviderState.externalAccessToken;
        print("send request to uri: $uri");
        print("send request with body: $requestBody");
        response = await http.post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $externalAccessToken',
          },
          body: json.encode(requestBody),
        );
      }

      print('response chat msg: ${response.body}');

      if (response.statusCode == 200) {
        if (currentAssistant.isDefault) {
          // Default assistant: parse as JSON
          Map<String, dynamic> data;
          try {
            data = json.decode(response.body);
          } catch (e, stack) {
            print("JSON decode error: $e");
            messages.insert(
              0,
              MessageModel(
                text: 'Could not parse JSON response: ${e.toString()}',
                sender: 'System',
                isCurrentUser: false,
              ),
            );
            // Log JSON decode error
            FirebaseCrashlytics.instance.recordError(
              e,
              stack,
              reason: 'JSON decode error in sendMessage',
            );
            isSending = false; // **Set isSending to false**
            isLoading = false;
            return;
          }

          final chatResponse = ChatResponse.fromJson(data);

          if (conversationId == null && chatResponse.conversationId != null) {
            conversationId = chatResponse.conversationId;
            print('conversationId after response: $conversationId');
          }

          remainingUsage = chatResponse.remainingUsage;

          // Add AI response
          messages.insert(
            0,
            MessageModel(
              text: chatResponse.message,
              sender: 'AI',
              isCurrentUser: false,
              assistant: Assistant(
                id: currentAssistant.id,
                assistantName: _getAssistantName(typeAI),
                isDefault: currentAssistant.isDefault,
                openAiThreadIdPlay: currentAssistant.openAiThreadIdPlay,
              ),
            ),
          );
        } else {
          // Non-default assistant: assume text response (not JSON)
          // Decode UTF-8 để hiển thị tiếng Việt đúng
          String decodedResponse = utf8.decode(response.bodyBytes);

          // If non-default API returns text, use it as message
          final message = decodedResponse.isNotEmpty
              ? decodedResponse
              : "No message returned";

          remainingUsage = 99999; // Default value, if needed

          messages.insert(
            0,
            MessageModel(
              text: message,
              sender: 'AI',
              isCurrentUser: false,
              assistant: Assistant(
                id: currentAssistant.id,
                assistantName: _getAssistantName(typeAI),
                isDefault: currentAssistant.isDefault,
                openAiThreadIdPlay: currentAssistant.openAiThreadIdPlay,
              ),
            ),
          );
        }
      } else {
        print('An error occurred: ${response.statusCode}');
        messages.insert(
          0,
          MessageModel(
            text: 'An error occurred: ${response.statusCode}',
            sender: 'System',
            isCurrentUser: false,
          ),
        );
        // Log non-200 response
        FirebaseCrashlytics.instance.recordError(
          Exception('Failed to send message: ${response.statusCode}'),
          null,
          reason: 'sendMessage received non-200 response',
        );
      }
    } catch (e, stack) {
      print('An exception occurred: $e');
      FirebaseCrashlytics.instance.recordError(e, stack,
          reason: 'sendMessage exception');
      messages.insert(
        0,
        MessageModel(
          text: 'An exception occurred: $e',
          sender: 'System',
          isCurrentUser: false,
        ),
      );
    }

    isSending = false; // **Set isSending to false**
    isLoading = false;
  }

  // Helper method to get the current assistant object
  Assistant? _getCurrentAssistant() {
    if (defaultAssistants.containsKey(typeAI)) {
      // Tìm trong fetchedAssistants assistant có id = typeAI, nếu ko có thì tạo default assistant
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
    if (defaultAssistants.containsKey(typeAI)) {
      return defaultAssistants[typeAI]!;
    } else {
      final fetched = fetchedAssistants.firstWhere(
        (assistant) => assistant.id == typeAI,
        orElse: () => Assistant(
          id: typeAI,
          assistantName: 'Unknown Assistant',
          isDefault: false,
        ),
      );
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

  @action
  void clearErrorMessage() {
    // Implement this if handling error messages
  }
}
