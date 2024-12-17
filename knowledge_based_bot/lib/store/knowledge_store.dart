import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:knowledge_based_bot/data/models/knowledge_model.dart';
//import 'package:knowledge_based_bot/data/models/prompt_model.dart';

import 'package:knowledge_based_bot/provider_state.dart';

part 'knowledge_store.g.dart';

class KnowledgeStore = _KnowledgeStore with _$KnowledgeStore;

abstract class _KnowledgeStore with Store {
  // Define your class members and methods here

  @observable
  List<KnowledgeResDto> knowledgeList = [];
  @observable
  List<KnowledgeResDto> searchList = [];

  String kb_token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjE5MWUwMmVjLTlhMTgtNGQ5OC05NDU0LThkMWUyYmI1YTM3YSIsImVtYWlsIjoicHZoZDcwN0BleGFtcGxlLmNvbSIsImlhdCI6MTczNDMzMjYxOCwiZXhwIjoxNzM0NDE5MDE4fQ.sqCCtpMbSoCEmcUeWjfA-evbCgqNusT3mBsC8uVl73A";

  @action
  Future<void> fetchKnowledge() async {
    knowledgeList.clear();

    var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $kb_token'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://knowledge-api.dev.jarvis.cx/kb-core/v1/knowledge?q&order=DESC&order_field=createdAt&offset&limit=20'));

    request.headers.addAll(headers);

    final response = await http.get(request.url, headers: headers);

    if (response.statusCode == 200) {
      // parse the response
      var responseJson = json.decode(response.body);
      if (responseJson['data'] != null) {
        for (var item in responseJson['data']) {
          knowledgeList.add(KnowledgeResDto.fromJson(item));
        }
      }
      print("Knowledge fetched successfully: ${knowledgeList.length}");
      print(knowledgeList[0].knowledgeName);
    } else {
      print(response.reasonPhrase);
    }
  }

  //create knowledge
  @action
  Future<void> createKnowledge(String knowledgeName, String description) async {
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kb_token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST',
        Uri.parse('https://knowledge-api.dev.jarvis.cx/kb-core/v1/knowledge'));
    request.body = json.encode({
      "knowledgeName": knowledgeName,
      "description": description,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      print("Knowledge created successfully");
    } else {
      print("Knowledge creation failed");
      print(response.reasonPhrase);
    }
  }

  //search knowledge
  @action
  Future<void> searchKnowledge(String search) async {
    // searchList.clear();
    knowledgeList.clear();
    var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $kb_token'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://knowledge-api.dev.jarvis.cx/kb-core/v1/knowledge?q=$search&order=DESC&order_field=createdAt&offset&limit=20'));

    request.headers.addAll(headers);

    final response = await http.get(request.url, headers: headers);

    if (response.statusCode == 200) {
      // parse the response
      var responseJson = json.decode(response.body);
      if (responseJson['data'] != null) {
        for (var item in responseJson['data']) {
          knowledgeList.add(KnowledgeResDto.fromJson(item));
          // searchList.add(KnowledgeResDto.fromJson(item));
        }
      }
      print("search successfully: ${searchList.length}");
    } else {
      print(response.reasonPhrase);
    }
  }

  //delete knowledge
  @action
  Future<void> deleteKnowledge(String id) async {
    var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $kb_token'};
    var request = http.Request(
        'DELETE',
        Uri.parse(
            'https://knowledge-api.dev.jarvis.cx/kb-core/v1/knowledge/$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("Knowledge deleted successfully");
    } else {
      print(response.reasonPhrase);
    }
  }
}
