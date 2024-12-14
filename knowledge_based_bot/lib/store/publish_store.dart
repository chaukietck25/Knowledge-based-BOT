// lib/store/publish_store.dart
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../provider_state.dart'; // Ensure this path is correct

part 'publish_store.g.dart';

class IntegrationPlatform = _IntegrationPlatform with _$IntegrationPlatform;

abstract class _IntegrationPlatform with Store {
  final String name;

  _IntegrationPlatform(this.name);

  @observable
  bool isVerified = false;

  @observable
  String? token;

  @observable
  bool isSelected = false;

  @action
  void toggleSelection(bool? value) {
    isSelected = value ?? false;
    print('$name selection toggled to $isSelected');
  }
}

class PublishStore = _PublishStore with _$PublishStore;

abstract class _PublishStore with Store {
  final String assistantId;

  _PublishStore(this.assistantId) {
    platforms = ObservableList<IntegrationPlatform>.of([
      IntegrationPlatform('Slack'),
      IntegrationPlatform('Telegram'),
      IntegrationPlatform('Messenger'),
    ]);
  }

  @observable
  ObservableList<IntegrationPlatform> platforms = ObservableList<IntegrationPlatform>();

  @observable
  bool isPublishing = false;

  // Define verification endpoints for each platform
  final Map<String, String> _verificationEndpoints = {
    'Slack': 'https://knowledge-api.dev.jarvis.cx/kb-core/v1/bot-integration/slack/validation',
    'Telegram': 'https://knowledge-api.dev.jarvis.cx/kb-core/v1/bot-integration/telegram/validation',
    'Messenger': 'https://knowledge-api.dev.jarvis.cx/kb-core/v1/bot-integration/messenger/validation',
  };

  // Define publish endpoints for each platform
  final Map<String, String> _publishEndpoints = {
    'Slack': 'https://knowledge-api.dev.jarvis.cx/kb-core/v1/bot-integration/slack/publish/',
    'Telegram': 'https://knowledge-api.dev.jarvis.cx/kb-core/v1/bot-integration/telegram/publish/',
    'Messenger': 'https://knowledge-api.dev.jarvis.cx/kb-core/v1/bot-integration/messenger/publish/',
  };

  @action
  Future<bool> verifyPlatform(String platformName, String botToken) async {
    String? externalAccessToken = ProviderState.getExternalAccessToken();
    if (externalAccessToken == null) {
      throw Exception('External access token is null.');
    }

    final url = _verificationEndpoints[platformName];
    if (url == null) {
      throw Exception('No verification endpoint for $platformName');
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $externalAccessToken',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'botToken': botToken,
        }),
      );
      print('Verification Response for $platformName: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['ok'] == true) {
          final platform = platforms.firstWhere((p) => p.name == platformName);
          platform.isVerified = true;
          platform.token = botToken;
          platform.isSelected = true; // Automatically select upon verification
          print('$platformName isVerified: ${platform.isVerified}, isSelected: ${platform.isSelected}');
          return true;
        } else {
          return false;
        }
      } else {
        throw Exception('Failed to verify $platformName: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error verifying $platformName: $e');
    }
  }

  @action
  Future<Map<String, dynamic>> publishSelected() async {
    final selectedPlatforms = platforms.where((platform) => platform.isSelected).toList();

    if (selectedPlatforms.isEmpty) {
      throw Exception('No platforms selected for publishing.');
    }

    String? externalAccessToken = ProviderState.getExternalAccessToken();
    if (externalAccessToken == null) {
      throw Exception('External access token is null.');
    }

    isPublishing = true;
    print('Publishing to platforms: ${selectedPlatforms.map((p) => p.name).toList()}');

    Map<String, dynamic> results = {};

    try {
      List<Future<void>> publishFutures = selectedPlatforms.map((platform) async {
        final endpoint = _publishEndpoints[platform.name];
        if (endpoint == null) {
          results[platform.name] = 'No publish endpoint for ${platform.name}';
          return;
        }

        final url = '$endpoint${assistantId}'; // Append assistantId to endpoint

        try {
          final response = await http.post(
            Uri.parse(url),
            headers: {
              'Authorization': 'Bearer $externalAccessToken',
              'Content-Type': 'application/json',
            },
            body: json.encode({
              'botToken': platform.token,
            }),
          );

          print('Publish Response for ${platform.name}: ${response.statusCode} - ${response.body}');

          if (response.statusCode == 200) {
            final responseData = json.decode(response.body);
            if (responseData.containsKey('redirect')) {
              results[platform.name] = responseData['redirect'];
            } else {
              results[platform.name] = 'No redirect URL provided.';
            }
          } else {
            results[platform.name] = 'Publish failed: ${response.reasonPhrase}';
          }
        } catch (e) {
          results[platform.name] = 'Error publishing: $e';
        }
      }).toList();

      await Future.wait(publishFutures);
    } catch (e) {
      throw Exception('Error during publishing: $e');
    } finally {
      isPublishing = false;
      print('Publishing completed.');
    }

    return results;
  }

  @computed
  bool get canPublish => platforms.any((platform) => platform.isSelected && platform.isVerified);
}
