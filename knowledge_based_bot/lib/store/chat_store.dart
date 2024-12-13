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

    // String? accessToken = ProviderState.getAccessToken();
    String? refreshToken = ProviderState.getRefreshToken();

    // print("accessToken in fetchConversationDetails: $accessToken");
    print("refreshToken in fetchConversationDetails: $refreshToken");

    try {
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
          'Authorization': 'Bearer $refreshToken',
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
            'https://api.dev.jarvis.cx/api/v1/ai-chat/conversations?assistantId=$typeAI&assistantModel=dify'),
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
          print("lan 1");
          print("send request to uri: https://api.dev.jarvis.cx/api/v1/ai-chat");
          print("send request with body: $body");
          print("accessToken: $accessToken");

          response = await http.post(
            Uri.parse('https://api.dev.jarvis.cx/api/v1/ai-chat'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $accessToken',
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
          print("accessToken: $accessToken");

          response = await http.post(
            Uri.parse('https://api.dev.jarvis.cx/api/v1/ai-chat/messages'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $accessToken',
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
          } catch (e) {
            print("JSON decode error: $e");
            messages.insert(
              0,
              MessageModel(
                text: 'Could not parse JSON response: ${e.toString()}',
                sender: 'System',
                isCurrentUser: false,
              ),
            );
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

          // Nếu API non-default không trả về JSON mà là text thường,
          // ta lấy chuỗi này làm message.
          final message = decodedResponse.isNotEmpty
              ? decodedResponse
              : "No message returned";

          // Nếu API non-default có thể trả về threadId trong header hoặc không,
          // bạn có thể check headers ở đây (nếu cần). Hiện tại chúng ta giả sử là không.

          remainingUsage = 99999; // Giá trị mặc định, nếu cần

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
