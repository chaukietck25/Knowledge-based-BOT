import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:knowledge_based_bot/data/models/response_chat.dart';

part 'chat_store.g.dart';

class ChatStore = _ChatStore with _$ChatStore;

abstract class _ChatStore with Store {
  @observable
  ObservableList<ChatResponse> chats = ObservableList<ChatResponse>();

  String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjhmY2RiNzA1LThjYTAtNDkzZS1hODQ4LTI1OWE1MmVmM2I0NCIsImVtYWlsIjoicGhhbWRhbmc3MDdAZ21haWwuY29tIiwiaWF0IjoxNzMyMDcwMDY1LCJleHAiOjE3MzIwNzAxMjV9.cTY5qPV3H6Kz17mKpTOxfkgcNrwDxHlad3Gf2t5EL2U';

  @action
  Future<void> fetchChats() async {
    var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $token'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://api.dev.jarvis.cx/api/v1/ai-chat/conversations?assistantId=gpt-4o-mini&assistantModel=dify'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // var responseBody = await response.stream.bytesToString();
      // var jsonResponse = json.decode(responseBody) as List;
      // chats = ObservableList.of(jsonResponse.map((chat) => AiChatModel.fromJson(chat)).toList());
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> getConversations() async {
    var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $token'};
    var request = http.Request(
        'GET',
        Uri.parse(
            '/api/v1/ai-chat/conversations?assistantId=gpt-4o-mini&assistantModel=dify'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  @action
  Future<void> sendMessage(String content) async {
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('/api/v1/ai-chat/messages'));

    request.body = json.encode({
      "content": "how are you ?",
      "metadata": {
        "conversation": {
          "id": "f32a6751-9200-4357-9281-d22e5785434c",
          "messages": [
            {
              "role": "user",
              "content": content,
              "assistant": {
                "id": "gpt-4o-mini",
                "model": "dify",
                "name": "GPT-4o mini"
              }
            },
            {
              "role": "model",
              "content":
                  "Hello! It's nice to meet you. I'm Jarvis, an AI assistant created by Anthropic. I'm here to help with any questions or tasks you might have. How can I assist you today?",
              "assistant": {
                "id": "gpt-4o-mini",
                "model": "dify",
                "name": "GPT-4o mini"
              },
              "isErrored": true
            }
          ]
        }
      },
      "assistant": {
        "id": "claude-3-haiku-20240307",
        "model": "dify",
        "name": "Claude 3 Haiku"
      }
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    // response = await http.get(request.url, headers: headers);

    if (response.statusCode == 200) {
      // var responseBody = await response.stream.bytesToString();
      // var jsonResponse = json.decode(responseBody);
      // var newChat = ChatResponse.fromJson(jsonResponse);
      // chats.add(newChat);
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  @action
  Future<void> aiChat(String content) async {
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('/api/v1/ai-chat'));

    request.body = json.encode({
      "assistant": {"id": "gpt-4o-mini", "model": "dify"},
      "content": "hi"
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    // response = await http.get(request.url, headers: headers);

    if (response.statusCode == 200) {
      // var responseBody = await response.stream.bytesToString();
      // var jsonResponse = json.decode(responseBody);
      // var newChat = ChatResponse.fromJson(jsonResponse);
      // chats.add(newChat);
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
