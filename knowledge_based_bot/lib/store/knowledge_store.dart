import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:knowledge_based_bot/data/models/knowledge_model.dart';
import 'package:knowledge_based_bot/data/models/kb_unit_model.dart';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import '../provider_state.dart';
//import 'package:knowledge_based_bot/data/models/prompt_model.dart';

part 'knowledge_store.g.dart';

class KnowledgeStore = _KnowledgeStore with _$KnowledgeStore;

abstract class _KnowledgeStore with Store {
  // Define your class members and methods here

  @observable
  List<KnowledgeResDto> knowledgeList = [];
  @observable
  List<KnowledgeResDto> searchList = [];
  @observable
  List<KnowledgeUnitsResDto> knowledgeUnitList = [];
  @observable
  String? noti_message = '';

  // String? kb_token = ProviderState.externalAccessToken;
  String? kb_token = ProviderState.externalAccessToken;

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
      //print(knowledgeList[0].knowledgeName);
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

  //update knowledge
  @action
  Future<void> updateKnowledge(
      String id, String knowledgeName, String description) async {
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kb_token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'PATCH',
        Uri.parse(
            'https://knowledge-api.dev.jarvis.cx/kb-core/v1/knowledge/$id'));
    request.body = json.encode({
      "knowledgeName": knowledgeName,
      "description": description,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("Knowledge updated successfully");
    } else {
      print(response.reasonPhrase);
    }
  }

  //get knowledge units
  @action
  Future<void> fetchKnowledgeUnits(String knowledgeId) async {
    knowledgeUnitList.clear();

    var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $kb_token'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://knowledge-api.dev.jarvis.cx/kb-core/v1/knowledge/$knowledgeId/units?q&order=DESC&order_field=createdAt&offset=&limit=20'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // parse the response
      var responseJson = json.decode(await response.stream.bytesToString());
      if (responseJson['data'] != null) {
        for (var item in responseJson['data']) {
          knowledgeUnitList.add(KnowledgeUnitsResDto.fromMap(item));
        }
      }
      print(
          "Knowledge units fetched successfully: ${knowledgeUnitList.length}");
    } else {
      print(response.reasonPhrase);
    }
  }

  // update knowledge units : local file
  @action
  Future<void> uploadLocalFile(String knowledgeId, String filePath) async {
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kb_token',
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://knowledge-api.dev.jarvis.cx/kb-core/v1/knowledge/$knowledgeId/local-file'));

    request.headers.addAll(headers);
    // Thêm file vào yêu cầu
    var file = await http.MultipartFile.fromPath(
      'file', // Tên của trường file trong yêu cầu
      filePath,
      filename: "test", // Tên file
    );

    request.files.add(file);

    // Gửi yêu cầu
    var response = await request.send();

    if (response.statusCode == 200) {
      print('File uploaded successfully on mobile');
    } else {
      print('Failed to upload file: ${response.reasonPhrase}');
    }
  }

  @action
  Future<void> uploadLocalFileWeb(
      String knowledgeId, Uint8List fileBytes, String fileName) async {
    noti_message = '';

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kb_token',
    };

    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://knowledge-api.dev.jarvis.cx/kb-core/v1/knowledge/$knowledgeId/local-file'));

    request.headers.addAll(headers);

    // Xác định loại MIME của file
    final mimeType = lookupMimeType(fileName, headerBytes: fileBytes);
    final mediaType = mimeType != null
        ? MediaType.parse(mimeType)
        : MediaType('application', 'octet-stream');

    // Thêm file vào yêu cầu
    var file = http.MultipartFile.fromBytes(
      'file', // Tên của trường file trong yêu cầu
      fileBytes,
      filename: fileName, // Tên file
      contentType: mediaType, // Loại nội dung của file
    );
    request.files.add(file);

    // Gửi yêu cầu
    var response = await request.send();

    if (response.statusCode == 200) {
      print('kbstore: File uploaded successfully web');
    } else {
      print('kbstore: Failed to upload file: ${response.reasonPhrase}');
      final responseBody = await response.stream.bytesToString();
      print('Response body: $responseBody');

      noti_message = response.reasonPhrase;
    }
  }

  // upload web url
  @action
  Future<void> uploadWebUrl(
      String knowledgeId, String url, String unitName) async {

    noti_message = '';
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kb_token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://knowledge-api.dev.jarvis.cx/kb-core/v1/knowledge/$knowledgeId/web'));
    request.body = json.encode({"unitName": unitName, "webUrl": url});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("Web url uploaded successfully");
    } else {
      print("Web url upload failed: ${response.reasonPhrase}");

      noti_message = response.reasonPhrase;
    }
  }

  // upload slack
  @action
  Future<void> uploadSlack(String knowledgeId, String unitName,
      String slackWorkspace, String slackBotToken) async {

    noti_message = '';

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kb_token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('/kb-core/v1/knowledge/$knowledgeId/slack'));
    request.body = json.encode({
      "unitName": unitName,
      "slackWorkspace": slackWorkspace,
      "slackBotToken": slackBotToken
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("Slack uploaded successfully");
    } else {
      print("Slack upload failed: ${response.reasonPhrase}");
      noti_message = response.reasonPhrase;
      // get detail error
    }
  }

  // upload confluence
  @action
  Future<void> uploadConfluence(
      String knowledgeId,
      String unitName,
      String wikiPageUrl,
      String confluenceUsername,
      String confluenceAccessToken) async {

    noti_message = '';

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kb_token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('/kb-core/v1/knowledge/$knowledgeId/confluence'));
    request.body = json.encode({
      "unitName": unitName,
      "wikiPageUrl": wikiPageUrl,
      "confluenceUsername": confluenceUsername,
      "confluenceAccessToken": confluenceAccessToken
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("Confluence uploaded successfully");

    } else {
      print("Confluence upload failed: ${response.reasonPhrase}");
      noti_message = response.reasonPhrase;
    }
  }
}
