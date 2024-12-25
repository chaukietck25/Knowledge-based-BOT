import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../provider_state.dart'; // Đảm bảo đường dẫn đúng

part 'publish_store.g.dart';

// -------------------------------------
// Lớp đại diện cho 1 nền tảng tích hợp
// -------------------------------------
class IntegrationPlatform = _IntegrationPlatform with _$IntegrationPlatform;

abstract class _IntegrationPlatform with Store {
  final String name;

  _IntegrationPlatform(this.name);

  @observable
  bool isVerified = false;

  @observable
  bool isSelected = false;

  // Common fields
  @observable
  String? botToken;

  // Slack-specific fields
  @observable
  String? clientId;

  @observable
  String? clientSecret;

  @observable
  String? signingSecret;

  @observable
  String? redirectUrl; // Stores Slack's redirect URL

  // Messenger-specific fields
  @observable
  String? pageId;

  @observable
  String? appSecret;

  @action
  void toggleSelection(bool? value) {
    isSelected = value ?? false;
    print('$name selection toggled to $isSelected');
  }

  @action
  void setBotToken(String token) {
    botToken = token;
  }

  @action
  void setSlackCredentials({
    required String clientId,
    required String clientSecret,
    required String signingSecret,
  }) {
    this.clientId = clientId;
    this.clientSecret = clientSecret;
    this.signingSecret = signingSecret;
  }

  @action
  void setMessengerCredentials({
    required String pageId,
    required String appSecret,
    required String botToken,
  }) {
    this.pageId = pageId;
    this.appSecret = appSecret;
    this.botToken = botToken;
  }

  @action
  void setRedirectUrl(String url) {
    redirectUrl = url;
  }
}

// -------------------------------------
// Lớp đại diện cho kết quả verify
// -------------------------------------
class VerificationResult {
  final bool success;
  final String? redirectUrl;

  VerificationResult({required this.success, this.redirectUrl});

  // Nếu muốn in log "đẹp" hơn, bạn có thể override toString():
  // @override
  // String toString() => 'VerificationResult(success: $success, redirectUrl: $redirectUrl)';
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

  // -------------------------------------
  // Endpoint verify
  // -------------------------------------
  final Map<String, String> _verificationEndpoints = {
    'Slack': 'https://knowledge-api.dev.jarvis.cx/kb-core/v1/bot-integration/slack/validation',
    'Telegram': 'https://knowledge-api.dev.jarvis.cx/kb-core/v1/bot-integration/telegram/validation',
    'Messenger': 'https://knowledge-api.dev.jarvis.cx/kb-core/v1/bot-integration/messenger/validation',
  };

  // -------------------------------------
  // Endpoint publish
  // -------------------------------------
  final Map<String, String> _publishEndpoints = {
    'Slack': 'https://knowledge-api.dev.jarvis.cx/kb-core/v1/bot-integration/slack/publish/',
    'Telegram': 'https://knowledge-api.dev.jarvis.cx/kb-core/v1/bot-integration/telegram/publish/',
    'Messenger': 'https://knowledge-api.dev.jarvis.cx/kb-core/v1/bot-integration/messenger/publish/',
  };

  // -------------------------------------
  // Action: verifyPlatform
  // -------------------------------------
  @action
  Future<VerificationResult> verifyPlatform(String platformName, Map<String, String> data) async {
    String? externalAccessToken = ProviderState.getExternalAccessToken();
    if (externalAccessToken == null) {
      throw Exception('External access token is null.');
    }

    String? url = _verificationEndpoints[platformName];
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
        body: json.encode(data),
      );

      print('Verification Response for $platformName: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        // Dưới đây là các logic tuỳ theo platform
        if (platformName == 'Slack') {
          dynamic responseData;
          bool isJson = false;
          try {
            responseData = json.decode(response.body);
            isJson = true;
          } catch (_) {
            isJson = false;
          }

          // Nếu Slack trả về JSON có key 'redirect'
          if (isJson && responseData is Map && responseData.containsKey('redirect')) {
            final platform = platforms.firstWhere((p) => p.name == platformName);
            platform.isVerified = true;
            platform.isSelected = true; // Tự động chọn
            platform.setRedirectUrl(responseData['redirect']);
            print('$platformName isVerified: ${platform.isVerified}, isSelected: ${platform.isSelected}');
            return VerificationResult(success: true, redirectUrl: responseData['redirect']);
          } else {
            // Trường hợp Slack ko trả về redirect
            final platform = platforms.firstWhere((p) => p.name == platformName);
            platform.isVerified = true;
            platform.isSelected = true; // Tự động chọn
            platform.setSlackCredentials(
              clientId: data['clientId']!,
              clientSecret: data['clientSecret']!,
              signingSecret: data['signingSecret']!,
            );
            platform.setBotToken(data['botToken']!);
            print('$platformName isVerified: ${platform.isVerified}, isSelected: ${platform.isSelected}');
            return VerificationResult(success: true);
          }
        } else if (platformName == 'Telegram') {
          // Telegram xem 'ok' == true
          dynamic responseData;
          bool isJson = false;
          try {
            responseData = json.decode(response.body);
            isJson = true;
          } catch (_) {
            isJson = false;
          }

          if (isJson && responseData['ok'] == true) {
            final platform = platforms.firstWhere((p) => p.name == platformName);
            platform.isVerified = true;
            platform.isSelected = true; // Tự động chọn
            platform.setBotToken(data['botToken']!);
            print('$platformName isVerified: ${platform.isVerified}, isSelected: ${platform.isSelected}');
            return VerificationResult(success: true);
          } else {
            return VerificationResult(success: false);
          }
        } else if (platformName == 'Messenger') {
          // ---------------------------------------------
          // BỎ kiểm tra JSON, chỉ cần statusCode == 200
          // => success = true, isVerified = true
          // ---------------------------------------------
          final platform = platforms.firstWhere((p) => p.name == platformName);
          platform.isVerified = true;
          platform.isSelected = true; // Tự động chọn
          platform.setMessengerCredentials(
            pageId: data['pageId']!,
            appSecret: data['appSecret']!,
            botToken: data['botToken']!,
          );
          print('$platformName isVerified: ${platform.isVerified}, isSelected: ${platform.isSelected}');
          return VerificationResult(success: true);

        } else {
          return VerificationResult(success: false);
        }
      } else {
        // Status != 200 => Exception
        throw Exception('Failed to verify $platformName: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error verifying $platformName: $e');
    }
  }

  // -------------------------------------
  // Action: publishSelected
  // -------------------------------------
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

        // Tạo publish URL kèm assistantId
        final url = '${endpoint}$assistantId';

        try {
          Map<String, dynamic> body = {};

          if (platform.name == 'Telegram') {
            // Telegram cần botToken
            if (platform.botToken == null || platform.botToken!.isEmpty) {
              results[platform.name] = 'Bot Token is missing for Telegram.';
              return;
            }
            body['botToken'] = platform.botToken!;
          } else if (platform.name == 'Messenger') {
            // Messenger cần botToken, pageId, appSecret
            if (platform.botToken == null ||
                platform.botToken!.isEmpty ||
                platform.pageId == null ||
                platform.pageId!.isEmpty ||
                platform.appSecret == null ||
                platform.appSecret!.isEmpty) {
              results[platform.name] = 'Bot Token, Page ID, or App Secret is missing for Messenger.';
              return;
            }
            body['botToken'] = platform.botToken!;
            body['pageId'] = platform.pageId!;
            body['appSecret'] = platform.appSecret!;
          } else if (platform.name == 'Slack') {
            // Slack cần botToken, clientId, clientSecret, signingSecret
            if (platform.botToken == null ||
                platform.botToken!.isEmpty ||
                platform.clientId == null ||
                platform.clientId!.isEmpty ||
                platform.clientSecret == null ||
                platform.clientSecret!.isEmpty ||
                platform.signingSecret == null ||
                platform.signingSecret!.isEmpty) {
              results[platform.name] = 'One or more Slack credentials are missing.';
              return;
            }
            body['botToken'] = platform.botToken!;
            body['clientId'] = platform.clientId!;
            body['clientSecret'] = platform.clientSecret!;
            body['signingSecret'] = platform.signingSecret!;
          }

          final response = await http.post(
            Uri.parse(url),
            headers: {
              'Authorization': 'Bearer $externalAccessToken',
              'Content-Type': 'application/json',
            },
            body: json.encode(body),
          );

          print('Publish Response for ${platform.name}: ${response.statusCode} - ${response.body}');

          if (response.statusCode == 200) {
            bool isJson = false;
            dynamic responseData;
            try {
              responseData = json.decode(response.body);
              isJson = true;
            } catch (_) {
              isJson = false;
            }

            // Kiểm tra xem có key 'redirect' ko
            if (isJson && responseData is Map && responseData.containsKey('redirect')) {
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

  // -------------------------------------
  // Computed: canPublish
  // -------------------------------------
  @computed
  bool get canPublish => platforms.any((platform) => platform.isSelected && platform.isVerified);
}
