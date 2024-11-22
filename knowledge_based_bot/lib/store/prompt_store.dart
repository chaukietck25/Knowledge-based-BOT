// lib/store/prompt_store.dart
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:knowledge_based_bot/data/models/respone_get_prompt_model.dart';
import 'package:knowledge_based_bot/data/models/prompt_model.dart';

import 'sign_in_store.dart';

part 'prompt_store.g.dart';

class PromptStore = _PromptStore with _$PromptStore;


  


abstract class _PromptStore with Store {
  @observable
  ObservableList<Prompt> prompts = ObservableList.of([]);

  // @observable
  // ObservableList<Prompt> privatePrompts = ObservableList.of([]);

  @observable
  ObservableList<Prompt> favoritePrompts = ObservableList.of([]);

  // list of prompts that are filtered by search query/ category
  @observable
  ObservableList<Prompt> filteredPrompts = ObservableList.of([]);

  @observable
  String msg = '';

  

  
  String? token = 
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjhmY2RiNzA1LThjYTAtNDkzZS1hODQ4LTI1OWE1MmVmM2I0NCIsImVtYWlsIjoicGhhbWRhbmc3MDdAZ21haWwuY29tIiwiaWF0IjoxNzMyMjYwNDE0LCJleHAiOjE3NjM3OTY0MTR9.jI_7hc4KRNG0TCI5FyzNgeGz0wkvoydlJK7vQafQ7B0';

  @action
  Future<void> fetchPrompts() async {
    filteredPrompts.clear();
    var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $token'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://api.dev.jarvis.cx/api/v1/prompts?query&offset=&limit=20&isFavorite=false&isPublic=true'));

    request.headers.addAll(headers);

    // var streamedResponse = await request.send();

    // var response = await http.Response.fromStream (streamedResponse);

    // final response = await http.get(request.url, headers: headers);

    // if (response.statusCode == 200) {
    //   print('Success');
    //   print(response.statusCode);
    //   print(response.value);

    // } else {
    //   print(response.statusCode);
    // }
    final response = await http.get(request.url, headers: headers);

    if (response.statusCode == 200) {
      //print('Success');
      // final JsonDecode = jsonDecode(response.body);
      // print(JsonDecode);

      //print(response.body);

      ApidogModel apiResponse = ApidogModel.fromJson(jsonDecode(response.body));
      for (var item in apiResponse.items) {
        addPrompt(
            item.id ?? '',
            item.createdAt ?? '',
            item.updatedAt ?? '',
            item.category ?? '',
            item.content ?? '',
            item.description ?? '',
            item.isPublic ?? false,
            item.language ?? '',
            item.title ?? '',
            item.userId ?? '',
            item.userName ?? '',
            item.isFavorite ?? false);
      }
      // prompts = ObservableList.of(apiResponse.items.map((item) => Prompt(
      //   id: item.id,
      //   category: item.category,
      //   content: item.content,
      //   createdAt: item.createdAt,
      //   description: item.description ?? '',
      //   isFavorite: item.isFavorite,
      //   isPublic: item.isPublic,

      print ('fetchPrompts');
    } else {
      print(response.statusCode);
    }
  }

  @action
  void addPrompt(
      String id,
      String createdAt,
      String updatedAt,
      String category,
      String content,
      String description,
      bool isPublic,
      String language,
      String title,
      String userId,
      String userName,
      bool isFavorite) {
    prompts.add(Prompt(
        id: id,
        createdAt: createdAt,
        updatedAt: updatedAt,
        category: category,
        content: content,
        description: description,
        isPublic: isPublic,
        language: language,
        title: title,
        userId: userId,
        userName: userName,
        isFavorite: isFavorite));
    filteredPrompts.add(Prompt(
        id: id,
        createdAt: createdAt,
        updatedAt: updatedAt,
        category: category,
        content: content,
        description: description,
        isPublic: isPublic,
        language: language,
        title: title,
        userId: userId,
        userName: userName,
        isFavorite: isFavorite));
  }

  @action
  Future<void> searchPrompts (String query)  async {
    filteredPrompts.clear();
    final searchLower = query.toLowerCase();
    for (var prompt in prompts) {
      final titleLower = prompt.title.toLowerCase();
      final descriptionLower = prompt.description.toLowerCase();
      if (titleLower.contains(searchLower) ||
          descriptionLower.contains(searchLower)) {
        filteredPrompts.add(prompt);
      }
    }
  }

  Future<void> searchByAPI(String query, bool isPublic) async {
    filteredPrompts.clear();

    var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $token'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://api.dev.jarvis.cx/api/v1/prompts?query=$query&offset=&limit=20&isFavorite=false&isPublic=$isPublic'));

    request.headers.addAll(headers);

    final response = await http.get(request.url, headers: headers);

    if (response.statusCode == 200) {
      ApidogModel apiResponse = ApidogModel.fromJson(jsonDecode(response.body));
      for (var item in apiResponse.items) {
        addPrompt(
            item.id ?? '',
            item.createdAt ?? '',
            item.updatedAt ?? '',
            item.category ?? '',
            item.content ?? '',
            item.description ?? '',
            item.isPublic ?? false,
            item.language ?? '',
            item.title ?? '',
            item.userId ?? '',
            item.userName ?? '',
            item.isFavorite ?? false);
      }
    } else {
      print(response.statusCode);
    }
  }

  Future<void> filterByCategory(String category) async {
    filteredPrompts.clear();

    if (category.toLowerCase() == 'all') {
      for (var prompt in prompts) {
        filteredPrompts.add(prompt);
      }
    } else {
      category = category.toLowerCase();
    }
    var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $token'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://api.dev.jarvis.cx/api/v1/prompts?query=&offset=&limit=20&category=$category&isFavorite=false&isPublic=true'));

    request.headers.addAll(headers);

    final response = await http.get(request.url, headers: headers);

    if (response.statusCode == 200) {
      ApidogModel apiResponse = ApidogModel.fromJson(jsonDecode(response.body));
      for (var item in apiResponse.items) {
        addPrompt(
            item.id ?? '',
            item.createdAt ?? '',
            item.updatedAt ?? '',
            item.category ?? '',
            item.content ?? '',
            item.description ?? '',
            item.isPublic ?? false,
            item.language ?? '',
            item.title ?? '',
            item.userId ?? '',
            item.userName ?? '',
            item.isFavorite ?? false);
      }
    } else {
      print(response.statusCode);
    }
  }

  @action
  Future<void> filterByFavorite() async {
    filteredPrompts.clear();

    var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $token'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://api.dev.jarvis.cx/api/v1/prompts?query=&offset=&limit=20&isFavorite=true&isPublic=true'));

    request.headers.addAll(headers);

    final response = await http.get(request.url, headers: headers);

    if (response.statusCode == 200) {
      ApidogModel apiResponse = ApidogModel.fromJson(jsonDecode(response.body));
      for (var item in apiResponse.items) {
        addPrompt(
            item.id ?? '',
            item.createdAt ?? '',
            item.updatedAt ?? '',
            item.category ?? '',
            item.content ?? '',
            item.description ?? '',
            item.isPublic ?? false,
            item.language ?? '',
            item.title ?? '',
            item.userId ?? '',
            item.userName ?? '',
            item.isFavorite ?? false);
      }
    } else {
      print(response.statusCode);
    }
  }

  @action
  Future<void> toggleFavorite(String id) async {
    var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $token'};
    var request = http.Request('POST',
        Uri.parse('https://api.dev.jarvis.cx/api/v1/prompts/$id/favorite'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      //print(await response.stream.bytesToString());
      print('added to favorite');
    } else {
      print('failed to add to favorite');
      print(response.reasonPhrase);
    }
  }

  @action
  Future<void> toggleNotFavorite(String id) async {
    var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $token'};
    var request = http.Request('DELETE',
        Uri.parse('https://api.dev.jarvis.cx/api/v1/prompts/$id/favorite'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      print('removed from favorite');
    } else {
      print('failed to remove from favorite');
      print(response.reasonPhrase);
    }
  }

  @action
  Future<void> createPrompt(String title, String content, String description,
      String category, String language, bool isPublic) async {
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('https://api.dev.jarvis.cx/api/v1/prompts'));
    request.body = json.encode({
      "title": title,
      "content": content,
      "description": description,
      "category": category.toLowerCase(),
      "language": language,
      "isPublic": isPublic
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      //print(response);
      print('Prompt created');
      fetchPrompts();
      privatePrompts();
    } else {
      //print(response.reasonPhrase);
      print('Failed to create prompt');
    }
  }

  @action
  Future<void> privatePrompts() async {
    filteredPrompts.clear();

    var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $token'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://api.dev.jarvis.cx/api/v1/prompts?query&offset=&limit=20&isFavorite=false&isPublic=false'));

    request.headers.addAll(headers);

    final response = await http.get(request.url, headers: headers);

    if (response.statusCode == 200) {
      //print('Success');
      // final JsonDecode = jsonDecode(response.body);
      // print(JsonDecode);

      //print(response.body);

      ApidogModel apiResponse = ApidogModel.fromJson(jsonDecode(response.body));
      for (var item in apiResponse.items) {
        addPrompt(
            item.id ?? '',
            item.createdAt ?? '',
            item.updatedAt ?? '',
            item.category ?? '',
            item.content ?? '',
            item.description ?? '',
            item.isPublic ?? false,
            item.language ?? '',
            item.title ?? '',
            item.userId ?? '',
            item.userName ?? '',
            item.isFavorite ?? false);
      }
      // prompts = ObservableList.of(apiResponse.items.map((item) => Prompt(
      //   id: item.id,
      //   category: item.category,
      //   content: item.content,
      //   createdAt: item.createdAt,
      //   description: item.description ?? '',
      //   isFavorite: item.isFavorite,
      //   isPublic: item.isPublic,

      print('privatePrompts');
    } else {
      print(response.statusCode);
    }
  }

  @action
  Future<void> updatePrompt(String id, String title, String content, String description,
      String category, String language, bool isPublic) async {
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'PATCH', Uri.parse('https://api.dev.jarvis.cx/api/v1/prompts/$id'));
    request.body = json.encode({
      "title": title,
      "content": content,
      "description": description,
      "category": "other",
      "language": "English",
      "isPublic": false
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      print('Prompt updated');
      privatePrompts();
    } else {
      print('Failed to update prompt');
      print(response.reasonPhrase);
    }
  }

  @action
  Future<void> removePrompt(String id) async {
    var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $token'};
    var request = http.Request(
        'DELETE', Uri.parse('https://api.dev.jarvis.cx/api/v1/prompts/$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      print('Prompt deleted');
      privatePrompts();
    } else {
      print('Failed to delete prompt');
      print(response.reasonPhrase);
    }
  }

  @action
  Future<void> addPromptToChatInput(
      String promptContent, String text, String language) async {
    // String updatedContent;

    // // Kiểm tra xem [text] có tồn tại ở cuối nội dung hay không
    // if (promptContent.endsWith('[Text]')) {
    //   // Thay thế [text] cuối cùng bằng giá trị của text
    //   updatedContent = promptContent.replaceFirst(RegExp(r'\[Text\]$'), text);
    // } else {
    //   // Thêm dòng trả lời theo text
    //   updatedContent = 'Prompt: $promptContent\n\nInput is: $text';
    // }

    // // Thêm dòng mô tả sẽ trả lời bằng ngôn ngữ theo language
    // String finalContent =
    //     '$updatedContent\n\nThe language of the response is: $language.';

    // // Gửi nội dung đã cập nhật tới chat input
    // msg = finalContent;

    // print('Prompt added to chat input: $msg');
    String updatedContent;

  // Sử dụng biểu thức chính quy để tìm và thay thế tất cả các phần tử có dạng [gì đó] bằng input
  updatedContent = promptContent.replaceAll(RegExp(r'\[.*?\]'), '['+text+']');

  // Thêm dòng mô tả sẽ trả lời bằng ngôn ngữ theo language
  String finalContent =
      '$updatedContent\n\nThe language of the response is: $language.';

  // Gửi nội dung đã cập nhật tới chat input
  msg = finalContent;

  print('Prompt added to chat input: $msg');
  }
}
