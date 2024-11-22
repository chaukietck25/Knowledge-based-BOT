// lib/store/prompt_store.dart
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:knowledge_based_bot/data/models/respone_get_prompt_model.dart';
import 'package:knowledge_based_bot/data/models/prompt_model.dart';

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

  // Fetch prompts from the API
  // Get Prompts
  // @action
  // Future<void> fetchPrompts() async {
  //   var headers = {
  //     'x-jarvis-guid': '',
  //     'Authorization':
  //         'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjU5YWY1NWRjLTNlOWMtNDNhYi1hMWIyLTA5NTY4ZjQ0OTBjMyIsImVtYWlsIjoiYWxleGllOTkxMUBnbWFpbC5jb20iLCJpYXQiOjE3MzE2OTI2MTAsImV4cCI6MTczMTY5NDQxMH0.zTmadKhUMYOQyR0yiq7K3PDK2YfhoTwfOS2wuF4GLJQ'
  //   };
  //   var request = http.Request(
  //       'GET',
  //       Uri.parse(
  //           '/api/v1/prompts?query&offset=&limit=20&isFavorite=false&isPublic=true'));

  //   request.headers.addAll(headers);

  //   http.StreamedResponse response = await request.send();

  //   // if (response.statusCode == 200) {
  //   //   List<dynamic> data = json.decode(await response.stream.bytesToString());
  //   //   prompts = ObservableList.of(data.map((e) => e as Map<String, String>));
  //   // } else {
  //   //   throw Exception('Failed to load prompts');
  //   // }

  //   // if (response.statusCode == 200) {
  //   //   print('Success');
  //   //   String responseBody = await response.stream.bytesToString();
  //   //   ApidogModel apiResponse = ApidogModel.fromRawJson(responseBody);
  //   //   prompts = ObservableList.of(apiResponse.items.map((item) => {'title': item.title ?? '', 'description': item.description ?? ''}));
  //   // } else {
  //   //   throw Exception('Failed to load prompts');
  //   // }

  //   if (response.statusCode == 200) {

  //     String responseBody = await response.stream.bytesToString();
  //     //print (responseBody);
  //     ApidogModel apiResponse = ApidogModel.fromRawJson(responseBody);
  //     prompts = ObservableList.of(apiResponse.items.map((item) => {
  //       'title': item.title,
  //       'description': item.description ?? ''
  //     }).toList());

  //     // prompts = ObservableList.of(apiResponse.items.map((item) => {
  //     //   'title': item.title,
  //     //   'description': item.description ?? ''
  //     // }).toList());
  //   } else {
  //     print(response.statusCode);
  //   }
  // }

  String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjhmY2RiNzA1LThjYTAtNDkzZS1hODQ4LTI1OWE1MmVmM2I0NCIsImVtYWlsIjoicGhhbWRhbmc3MDdAZ21haWwuY29tIiwiaWF0IjoxNzMyMjAyMjk1LCJleHAiOjE3MzIyMDIzNTV9.E4SUs7_PkQx1GwGrmr84qaAhisp1VYmfWQopXHwOD8s';

  @action
  Future<void> fetchPrompts() async {
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
  void searchPrompts(String query) {
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

  @action
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

  @action
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

    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      print('added to favorite');
    } else {
      print('failed to add to favorite');
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

    if (response.statusCode == 200) {
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
  void privatePrompts() async {
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
    } else {
      print(response.statusCode);
    }
  }

  @action
  void updatePrompt(String id, String title, String content, String description,
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
  void removePrompt(String id) async {
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
  void addPromptToChatInput(
      String promptContent, String text, String language) {
    String updatedContent;

    // Kiểm tra xem [text] có tồn tại ở cuối nội dung hay không
    if (promptContent.endsWith('[Text]')) {
      // Thay thế [text] cuối cùng bằng giá trị của text
      updatedContent = promptContent.replaceFirst(RegExp(r'\[Text\]$'), text);
    } else {
      // Thêm dòng trả lời theo text
      updatedContent = 'Prompt: $promptContent\n\nInput is: $text';
    }

    // Thêm dòng mô tả sẽ trả lời bằng ngôn ngữ theo language
    String finalContent =
        '$updatedContent\n\nThe language of the response is: $language.';

    // Gửi nội dung đã cập nhật tới chat input
    msg = finalContent;

    print('Prompt added to chat input: $msg');
  }
}
