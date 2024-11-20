import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:knowledge_based_bot/data/models/respone_get_prompt_model.dart';
import 'package:knowledge_based_bot/data/models/ai_chat_model.dart';


// class ChatStore = _ChatStore with _$ChatStore;

// abstract class _ChatStore with Store {
//   @observable
//   ObservableList<AiChatModel> chats = ObservableList<AiChatModel>();

//   @action
//   Future<void> fetchChats() async {
//     var headers = {
//       'x-jarvis-guid': '',
//       'Authorization': 'Bearer {{token}}'
//     };
//     var request = http.Request('GET', Uri.parse('/api/v1/ai-chat/conversations?assistantId=gpt-4o-mini&assistantModel=dify'));

//     request.headers.addAll(headers);

//     http.StreamedResponse response = await request.send();

//     if (response.statusCode == 200) {
//       var responseBody = await response.stream.bytesToString();
//       var jsonResponse = json.decode(responseBody) as List;
//       chats = ObservableList.of(jsonResponse.map((chat) => AiChatModel.fromJson(chat)).toList());
//     } else {
//       print(response.reasonPhrase);
//     }
//   }

//   @action
//   Future<void> sendMessage(String content) async {
//     var headers = {
//       'x-jarvis-guid': '',
//       'Authorization': 'Bearer {{token}}',
//       'Content-Type': 'application/json'
//     };
//     var request = http.Request('POST', Uri.parse('/api/v1/ai-chat/messages'));
//     request.headers.addAll(headers);

//     // http.StreamedResponse response = await request.send();

//     final response = await http.get(request.url, headers: headers);

//     if (response.statusCode == 200) {
//       var responseBody = await response.stream.bytesToString();
//       var jsonResponse = json.decode(responseBody);
//       var newChat = AiChatModel.fromJson(jsonResponse);
//       chats.add(newChat);
//     } else {
//       print(response.reasonPhrase);
//     }
//   }
// }

// var headers = {
//    'x-jarvis-guid': '',
//    'Authorization': 'Bearer {{token}}',
//    'Content-Type': 'application/json'
// };
// var request = http.Request('POST', Uri.parse('/api/v1/ai-chat'));
// request.body = json.encode({
//    "assistant": {
//       "id": "gpt-4o-mini",
//       "model": "dify"
//    },
//    "content": "hi"
// });
// request.headers.addAll(headers);

// http.StreamedResponse response = await request.send();

// if (response.statusCode == 200) {
//    print(await response.stream.bytesToString());
// }
// else {
//    print(response.reasonPhrase);
// }



// var headers = {
//    'x-jarvis-guid': '',
//    'Authorization': 'Bearer {{token}}'
// };
// var request = http.Request('GET', Uri.parse('/api/v1/ai-chat/conversations?assistantId=gpt-4o-mini&assistantModel=dify'));

// request.headers.addAll(headers);


// http.StreamedResponse response = await request.send();

// if (response.statusCode == 200) {
//    print(await response.stream.bytesToString());
// }
// else {
//    print(response.reasonPhrase);
// }



// var headers = {
//    'x-jarvis-guid': '',
//    'Authorization': 'Bearer {{token}}'
// };
// var request = http.Request('GET', Uri.parse('/api/v1/ai-chat/conversations//messages?assistantId=gpt-4o-mini&assistantModel=dify'));

// request.headers.addAll(headers);

// http.StreamedResponse response = await request.send();

// if (response.statusCode == 200) {
//    print(await response.stream.bytesToString());
// }
// else {
//    print(response.reasonPhrase);
// }


