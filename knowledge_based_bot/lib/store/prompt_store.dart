import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:knowledge_based_bot/data/models/respone_get_prompt_model.dart';
import 'package:knowledge_based_bot/data/models/prompt_model.dart';

part 'prompt_store.g.dart';

class PromptStore = _PromptStore with _$PromptStore;

abstract class _PromptStore with Store {
  @observable

  // ObservableList<Map<String, String>> prompts = ObservableList.of([]);
  ObservableList<Prompt> prompts = ObservableList.of([]);

  // list of prompts that are filtered by search query/ category
  @observable
  ObservableList<Prompt> filteredPrompts = ObservableList.of([]);

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

  String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjhmY2RiNzA1LThjYTAtNDkzZS1hODQ4LTI1OWE1MmVmM2I0NCIsImVtYWlsIjoicGhhbWRhbmc3MDdAZ21haWwuY29tIiwiaWF0IjoxNzMyMDcwMDY1LCJleHAiOjE3MzIwNzAxMjV9.cTY5qPV3H6Kz17mKpTOxfkgcNrwDxHlad3Gf2t5EL2U';
  @action
  Future<void> fetchPrompts() async {
    var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $token'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://api.dev.jarvis.cx/api/v1/prompts?query&offset=&limit=20&isFavorite=false&isPublic=true'));

    request.headers.addAll(headers);

    // var streamedResponse = await request.send();

    // var response = await http.Response.fromStream(streamedResponse);

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

      print(response.body);

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

  void searchByAPI(String query, bool isPublic) async {
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

  void filterByCategory(String category) async {
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
  void filterByFavorite() async {
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
  void toggleFavorite(String id) async {
    var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $token'};
    var request = http.Request('POST',
        Uri.parse('https://api.dev.jarvis.cx/api/v1/prompts/$id/favorite'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  @action
  void createPrompt(String title, String content, String description,
      String category, String language, bool isPublic) async {
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://api.dev.jarvis.cx/api/v1/prompts'));
    request.body = json.encode({
   "title": title,
   "content": content,
   "description": description,
   "category": category.toLowerCase(),
   "language": language,
   "isPublic": true
});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(response);
    } else {
      print(response.reasonPhrase);
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

    // var streamedResponse = await request.send();

    // var response = await http.Response.fromStream(streamedResponse);

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

      print(response.body);

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
    } else {
      print(response.statusCode);
    }
}
    }
