import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:knowledge_based_bot/data/models/knowledge_model.dart';
import 'package:knowledge_based_bot/data/models/kb_unit_model.dart';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import '../provider_state.dart';

part 'knowledge_store.g.dart';

class KnowledgeStore = _KnowledgeStore with _$KnowledgeStore;

abstract class _KnowledgeStore with Store {
  // Observable Lists
  @observable
  List<KnowledgeResDto> knowledgeList = [];

  @observable
  List<KnowledgeResDto> searchList = [];

  @observable
  List<KnowledgeUnitsResDto> knowledgeUnitList = [];

  @observable
  List<String> importedKnowledgeIds =
      []; // New Observable for Imported Knowledge IDs

  @observable
  String? noti_message = '';

  // Authorization Token
  String? kb_token = ProviderState.externalAccessToken;

  // Fetch All Knowledge Items
  @action
  Future<void> fetchKnowledge() async {
    knowledgeList.clear();

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kb_token',
    };
    var url =
        'https://knowledge-api.dev.jarvis.cx/kb-core/v1/knowledge?q&order=DESC&order_field=createdAt&offset&limit=20';

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body);
        if (responseJson['data'] != null) {
          for (var item in responseJson['data']) {
            knowledgeList.add(KnowledgeResDto.fromJson(item));
          }
        }
        print("Knowledge fetched successfully: ${knowledgeList.length}");
      } else {
        print("Failed to fetch knowledge: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error fetching knowledge: $e");
    }
  }

  // Fetch Imported Knowledge IDs
  @action
  Future<void> fetchImportedKnowledges(String assistantId) async {
    importedKnowledgeIds.clear();

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kb_token',
    };
    var url =
        'https://knowledge-api.dev.jarvis.cx/kb-core/v1/ai-assistant/$assistantId/knowledges';

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body);
        if (responseJson['data'] != null) {
          for (var item in responseJson['data']) {
            importedKnowledgeIds.add(item['id']);
          }
        }
        print(
            "Imported knowledges fetched successfully: ${importedKnowledgeIds.length}");
      } else {
        print("Failed to fetch imported knowledges: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error fetching imported knowledges: $e");
    }
  }

  // Import Knowledge into Assistant
  @action
  Future<void> importKnowledge(String assistantId, String knowledgeId) async {
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kb_token',
      'Content-Type': 'application/json',
    };
    var url =
        'https://knowledge-api.dev.jarvis.cx/kb-core/v1/ai-assistant/$assistantId/knowledges/$knowledgeId';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Knowledge imported successfully");
        await fetchImportedKnowledges(
            assistantId); // Refresh Imported Knowledge IDs
      } else {
        print("Failed to import knowledge: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error importing knowledge: $e");
    }
  }

  // Delete Knowledge from Assistant
  @action
  Future<void> deleteKnowledgeFromAssistant(
      String assistantId, String knowledgeId) async {
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kb_token',
    };
    var url =
        'https://knowledge-api.dev.jarvis.cx/kb-core/v1/ai-assistant/$assistantId/knowledges/$knowledgeId';

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print("Knowledge deleted successfully from assistant");
        await fetchImportedKnowledges(
            assistantId); // Refresh Imported Knowledge IDs
      } else {
        print("Failed to delete knowledge: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error deleting knowledge: $e");
    }
  }

  // Create Knowledge
  @action
  Future<void> createKnowledge(String knowledgeName, String description) async {
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kb_token',
      'Content-Type': 'application/json'
    };
    var url = 'https://knowledge-api.dev.jarvis.cx/kb-core/v1/knowledge';
    var body = json.encode({
      "knowledgeName": knowledgeName,
      "description": description,
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 201) {
        print("Knowledge created successfully");
        await fetchKnowledge(); // Refresh Knowledge List
      } else {
        print("Knowledge creation failed: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error creating knowledge: $e");
    }
  }

  // Search Knowledge
  @action
  Future<void> searchKnowledge(String search) async {
    knowledgeList.clear();
    searchList.clear();

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kb_token',
    };
    var url =
        'https://knowledge-api.dev.jarvis.cx/kb-core/v1/knowledge?q=$search&order=DESC&order_field=createdAt&offset&limit=20';

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body);
        if (responseJson['data'] != null) {
          for (var item in responseJson['data']) {
            var knowledge = KnowledgeResDto.fromJson(item);
            knowledgeList.add(knowledge);
            searchList.add(knowledge);
          }
        }
        print(
            "Search completed successfully: ${searchList.length} results found");
      } else {
        print("Search failed: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error searching knowledge: $e");
    }
  }

  // Delete Knowledge Completely
  @action
  Future<void> deleteKnowledge(String assistantId, String id) async {
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kb_token',
    };
    var url = 'https://knowledge-api.dev.jarvis.cx/kb-core/v1/knowledge/$id';

    try {
      final response = await http.delete(Uri.parse(url), headers: headers);

      if (response.statusCode == 200 || response.statusCode == 204) {
        print("Knowledge deleted successfully");
        await fetchKnowledge(); // Refresh Knowledge List
        await fetchImportedKnowledges(
            assistantId); // Refresh Imported Knowledge IDs
      } else {
        print("Failed to delete knowledge: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error deleting knowledge: $e");
    }
  }

  // Update Knowledge
  @action
  Future<void> updateKnowledge(
      String id, String knowledgeName, String description) async {
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kb_token',
      'Content-Type': 'application/json'
    };
    var url = 'https://knowledge-api.dev.jarvis.cx/kb-core/v1/knowledge/$id';
    var body = json.encode({
      "knowledgeName": knowledgeName,
      "description": description,
    });

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print("Knowledge updated successfully");
        await fetchKnowledge(); // Refresh Knowledge List
      } else {
        print("Failed to update knowledge: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error updating knowledge: $e");
    }
  }

  // Fetch Knowledge Units
  @action
  Future<void> fetchKnowledgeUnits(String knowledgeId) async {
    knowledgeUnitList.clear();

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kb_token',
    };
    var url =
        'https://knowledge-api.dev.jarvis.cx/kb-core/v1/knowledge/$knowledgeId/units?q&order=DESC&order_field=createdAt&offset=&limit=20';

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body);
        if (responseJson['data'] != null) {
          for (var item in responseJson['data']) {
            knowledgeUnitList.add(KnowledgeUnitsResDto.fromMap(item));
          }
        }
        print(
            "Knowledge units fetched successfully: ${knowledgeUnitList.length}");
      } else {
        print("Failed to fetch knowledge units: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error fetching knowledge units: $e");
    }
  }

  // Upload Local File (Mobile)
  @action
  Future<void> uploadLocalFile(String knowledgeId, String filePath) async {
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kb_token',
    };
    var url =
        'https://knowledge-api.dev.jarvis.cx/kb-core/v1/knowledge/$knowledgeId/local-file';

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(headers);

      // Add file to request
      var file = await http.MultipartFile.fromPath(
        'file', // Field name
        filePath,
        filename: "test", // Filename
      );
      request.files.add(file);

      // Send request
      var response = await request.send();

      if (response.statusCode == 200) {
        print('File uploaded successfully on mobile');
      } else {
        print('Failed to upload file: ${response.reasonPhrase}');
      }
    } catch (e) {
      print("Error uploading local file: $e");
    }
  }

  // Upload Local File (Web)
  @action
  Future<void> uploadLocalFileWeb(
      String knowledgeId, Uint8List fileBytes, String fileName) async {
    noti_message = '';

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kb_token',
    };
    var url =
        'https://knowledge-api.dev.jarvis.cx/kb-core/v1/knowledge/$knowledgeId/local-file';

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(headers);

      // Determine MIME type
      final mimeType = lookupMimeType(fileName, headerBytes: fileBytes);
      final mediaType = mimeType != null
          ? MediaType.parse(mimeType)
          : MediaType('application', 'octet-stream');

      // Add file to request
      var file = http.MultipartFile.fromBytes(
        'file', // Field name
        fileBytes,
        filename: fileName,
        contentType: mediaType,
      );
      request.files.add(file);

      // Send request
      var response = await request.send();

      if (response.statusCode == 200) {
        print('kbstore: File uploaded successfully web');
      } else {
        print('kbstore: Failed to upload file: ${response.reasonPhrase}');
        var responseBody = await response.stream.bytesToString();
        print('Response body: $responseBody');
        noti_message = response.reasonPhrase;
      }
    } catch (e) {
      print("Error uploading local file on web: $e");
      noti_message = 'Error uploading file';
    }
  }

  // Upload Web URL
  @action
  Future<void> uploadWebUrl(
      String knowledgeId, String url, String unitName) async {
    noti_message = '';
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kb_token',
      'Content-Type': 'application/json'
    };
    var endpoint =
        'https://knowledge-api.dev.jarvis.cx/kb-core/v1/knowledge/$knowledgeId/web';
    var body = json.encode({"unitName": unitName, "webUrl": url});

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print("Web URL uploaded successfully");
      } else {
        print("Web URL upload failed: ${response.reasonPhrase}");
        noti_message = response.reasonPhrase;
      }
    } catch (e) {
      print("Error uploading web URL: $e");
      noti_message = 'Error uploading web URL';
    }
  }

  // Upload Slack Integration
  @action
  Future<void> uploadSlack(String knowledgeId, String unitName,
      String slackWorkspace, String slackBotToken) async {
    noti_message = '';

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kb_token',
      'Content-Type': 'application/json'
    };
    var endpoint =
        'https://knowledge-api.dev.jarvis.cx/kb-core/v1/knowledge/$knowledgeId/slack';
    var body = json.encode({
      "unitName": unitName,
      "slackWorkspace": slackWorkspace,
      "slackBotToken": slackBotToken
    });

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print("Slack uploaded successfully");
      } else {
        print("Slack upload failed: ${response.reasonPhrase}");
        noti_message = response.reasonPhrase;
      }
    } catch (e) {
      print("Error uploading Slack integration: $e");
      noti_message = 'Error uploading Slack integration';
    }
  }

  // Upload Confluence Integration
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
    var endpoint =
        'https://knowledge-api.dev.jarvis.cx/kb-core/v1/knowledge/$knowledgeId/confluence';
    var body = json.encode({
      "unitName": unitName,
      "wikiPageUrl": wikiPageUrl,
      "confluenceUsername": confluenceUsername,
      "confluenceAccessToken": confluenceAccessToken
    });

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print("Confluence uploaded successfully");
      } else {
        print("Confluence upload failed: ${response.reasonPhrase}");
        noti_message = response.reasonPhrase;
      }
    } catch (e) {
      print("Error uploading Confluence integration: $e");
      noti_message = 'Error uploading Confluence integration';
    }
  }
}
