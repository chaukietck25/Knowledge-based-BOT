// lib/store/prompt_store.dart
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:knowledge_based_bot/data/models/respone_get_prompt_model.dart';
import 'package:knowledge_based_bot/data/models/prompt_model.dart';

import 'package:knowledge_based_bot/provider_state.dart';

part 'prompt_store.g.dart';

class PromptStore = _PromptStore with _$PromptStore;

abstract class _PromptStore with Store {
  ProviderState providerState = ProviderState();

  // list of all prompts
  @observable
  ObservableList<Prompt> prompts = ObservableList.of([]);

  // list of favorite prompts
  @observable
  ObservableList<Prompt> favoritePrompts = ObservableList.of([]);

  // list of prompts that are filtered by search query/ category
  @observable
  ObservableList<Prompt> filteredPrompts = ObservableList.of([]);

  // msg to be sent to chat input àfter merging prompt content with user input
  @observable
  String msg = '';

  // token to be used for API calls
  @observable
  String? token;

  _PromptStore() {
    token = ProviderState.getRefreshToken();
    //print('token'+ token!);
  }

  @observable
  String? curUser;

  // fetch prompts from API
  @action
  Future<void> fetchPrompts() async {
    prompts.clear();

    filteredPrompts.clear();

    // set the headers for the API call
    var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $token'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://api.jarvis.cx/api/v1/prompts?query&offset=&limit=500&isFavorite=false&isPublic=true'));

    request.headers.addAll(headers);

    // make the API call
    final response = await http.get(request.url, headers: headers);

    // if the API call is successful
    if (response.statusCode == 200) {
      // parse the response
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
        addToFilterList(
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
    }
    // if the API call is not successful
    else {
      print(response.statusCode);
    }
  }

  // add a prompt to the list of prompts
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
  }

  @action
  void addToFilterList(
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

  // search prompts by query
  @action
  Future<void> searchPrompts(String query) async {
    // clear the list of filtered prompts to store the new filtered prompts
    filteredPrompts.clear();
    // convert the query to lowercase
    final searchLower = query.toLowerCase();
    // loop through all prompts
    for (var prompt in prompts) {
      final titleLower = prompt.title.toLowerCase();
      final descriptionLower = prompt.description.toLowerCase();
      // if the title or description of the prompt contains the search query
      if (titleLower.contains(searchLower) ||
          descriptionLower.contains(searchLower)) {
        filteredPrompts.add(prompt);
      }
    }
  }

  // search prompts by query using API
  Future<void> searchByAPI(String query, bool isPublic) async {
    // clear the list of filtered prompts to store the new filtered prompts
    filteredPrompts.clear();

    // set the headers for the API call
    var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $token'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://api.jarvis.cx/api/v1/prompts?query=$query&offset=&limit=500&isFavorite=false&isPublic=$isPublic'));

    request.headers.addAll(headers);

    // make the API call
    final response = await http.get(request.url, headers: headers);

    // if the API call is successful
    if (response.statusCode == 200) {
      ApidogModel apiResponse = ApidogModel.fromJson(jsonDecode(response.body));
      for (var item in apiResponse.items) {
        addToFilterList(
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

  // filter prompts by category
  Future<void> filterByCategory(String category) async {
    // clear the list of filtered prompts to store the new filtered prompts
    filteredPrompts.clear();
    // if the category is 'all', add all prompts to the list of filtered prompts
    if (category.toLowerCase() == 'all') {
      for (var prompt in prompts) {
        filteredPrompts.add(prompt);
      }
    }
    // if the category is not 'all', add only the prompts with the specified category to the list of filtered prompts
    else {
      category = category.toLowerCase();
    }

    // set the headers for the API call
    var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $token'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://api.jarvis.cx/api/v1/prompts?query=&offset=&limit=500&category=$category&isFavorite=false&isPublic=true'));

    request.headers.addAll(headers);

    final response = await http.get(request.url, headers: headers);

    // if the API call is successful
    if (response.statusCode == 200) {
      ApidogModel apiResponse = ApidogModel.fromJson(jsonDecode(response.body));
      for (var item in apiResponse.items) {
        addToFilterList(
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

  // get favorite prompts
  @action
  Future<void> filterByFavorite() async {
    // clear the list of filtered prompts to store the new filtered prompts
    filteredPrompts.clear();
    // set the headers for the API call
    var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $token'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://api.jarvis.cx/api/v1/prompts?query=&offset=&limit=500&isFavorite=true&isPublic=true'));

    request.headers.addAll(headers);

    final response = await http.get(request.url, headers: headers);
    // if the API call is successful
    if (response.statusCode == 200) {
      ApidogModel apiResponse = ApidogModel.fromJson(jsonDecode(response.body));
      for (var item in apiResponse.items) {
        addToFilterList(
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

  // toggle favorite status of a prompt
  @action
  Future<void> addToFavoriteList(String id) async {
    var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $token'};
    var request = http.Request('POST',
        Uri.parse('https://api.jarvis.cx/api/v1/prompts/$id/favorite'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      print('added to favorite');
    } else {
      print('failed to add to favorite');
      print(response.reasonPhrase);
    }
  }

  // toggle not favorite status of a prompt
  @action
  Future<void> removeFavoriteList(String id) async {
    var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $token'};
    var request = http.Request('DELETE',
        Uri.parse('https://api.jarvis.cx/api/v1/prompts/$id/favorite'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print('removed from favorite');
    } else {
      print('failed to remove from favorite');
      print(response.reasonPhrase);
    }
  }

  // create a prompt
  @action
  Future<void> createPrompt(String title, String content, String description,
      String category, String language, bool isPublic) async {
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('https://api.jarvis.cx/api/v1/prompts'));
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

    // if the prompt is created successfully
    if (response.statusCode == 201) {
      print('Prompt created');
      // fetch the prompts again to update the list of prompts
      //fetchPrompts();
      //privatePrompts();
    } else {
      //print(response.reasonPhrase);
      print('Failed to create prompt');
    }
  }

  // get private prompts
  @action
  Future<void> privatePrompts() async {
    filteredPrompts.clear();

    var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $token'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://api.jarvis.cx/api/v1/prompts?query&offset=&limit=500&isFavorite=false&isPublic=false'));

    request.headers.addAll(headers);

    final response = await http.get(request.url, headers: headers);

    if (response.statusCode == 200) {
      ApidogModel apiResponse = ApidogModel.fromJson(jsonDecode(response.body));

      for (var item in apiResponse.items) {
        addToFilterList(
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
      // cập nhật danh sách các prompt riêng tư

      print('privatePrompts');
    } else {
      print(response.statusCode);
    }
  }

  // update a prompt
  @action
  Future<void> updatePrompt(
      String id,
      String title,
      String content,
      String description,
      String category,
      String language,
      bool isPublic) async {
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'PATCH', Uri.parse('https://api.jarvis.cx/api/v1/prompts/$id'));
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
      print('Prompt updated');
      // fetch the prompts again to update the list of prompts
      // only private prompts can be updated
      //privatePrompts();
    } else {
      print('Failed to update prompt');
      print(response.reasonPhrase);
    }
  }

  @action
  Future<void> removePrompt(String id) async {
    var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $token'};
    var request = http.Request(
        'DELETE', Uri.parse('https://api.jarvis.cx/api/v1/prompts/$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      print('Prompt deleted');
      // fetch the prompts again to update the list of prompts
      // only private prompts can be deleted
      //privatePrompts();
    } else {
      print('Failed to delete prompt');
      print(response.reasonPhrase);
    }
  }

  @action
  Future<void> addPromptToChatInput(
      String promptContent, String text, String language) async {
    String updatedContent;

    /// Use regular expressions to find and replace all elements in the form of [something] with input
    updatedContent =
        promptContent.replaceAll(RegExp(r'\[.*?\]'), '[' + text + ']');

    /// Add a description line that will respond in the language specified by the 'language' parameter.
    String finalContent =
        '$updatedContent\n\nThe language of the response is: $language.';

    // update msg
    msg = finalContent;

    ProviderState().setMsg(msg);

    print('Prompt added to chat input: $msg');
  }

  @action
  Future<void> getCurUser() async {
    var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $token'};
    var request = http.MultipartRequest('GET', Uri.parse('https://api.jarvis.cx/api/v1/auth/me'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseBody);
      
      curUser = jsonResponse['id'];
    } else {
      print(response.reasonPhrase);
    }
  }
}
