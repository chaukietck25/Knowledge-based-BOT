// lib/store/publish_store.dart
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../provider_state.dart'; // Đảm bảo đường dẫn này chính xác

part 'publish_store.g.dart';

class IntegrationPlatform = _IntegrationPlatform with _$IntegrationPlatform;

abstract class _IntegrationPlatform with Store {
  final String name;

  _IntegrationPlatform(this.name);

  @observable
  bool isVerified = false;

  @observable
  bool isSelected = false;

  // Trường chung
  @observable
  String? botToken;

  // Các trường riêng cho Slack
  @observable
  String? clientId;

  @observable
  String? clientSecret;

  @observable
  String? signingSecret;

  @observable
  String? redirectUrl; // Lưu trữ URL redirect của Slack

  // Các trường riêng cho Messenger (nếu cần)
  @observable
  String? pageAccessToken;

  @observable
  String? verifyToken;

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
    required String pageAccessToken,
    required String verifyToken,
  }) {
    this.pageAccessToken = pageAccessToken;
    this.verifyToken = verifyToken;
  }

  @action
  void setRedirectUrl(String url) {
    redirectUrl = url;
  }
}

// Lớp để bao gói kết quả xác thực
class VerificationResult {
  final bool success;
  final String? redirectUrl;

  VerificationResult({required this.success, this.redirectUrl});
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

  // Định nghĩa các endpoint xác thực cho mỗi nền tảng (không bao gồm assistantId)
  final Map<String, String> _verificationEndpoints = {
    'Slack': 'https://knowledge-api.dev.jarvis.cx/kb-core/v1/bot-integration/slack/validation',
    'Telegram': 'https://knowledge-api.dev.jarvis.cx/kb-core/v1/bot-integration/telegram/validation',
    'Messenger': 'https://knowledge-api.dev.jarvis.cx/kb-core/v1/bot-integration/messenger/validation',
  };

  // Định nghĩa các endpoint publish cho mỗi nền tảng (có bao gồm assistantId)
  final Map<String, String> _publishEndpoints = {
    'Slack': 'https://knowledge-api.dev.jarvis.cx/kb-core/v1/bot-integration/slack/publish/',
    'Telegram': 'https://knowledge-api.dev.jarvis.cx/kb-core/v1/bot-integration/telegram/publish/',
    'Messenger': 'https://knowledge-api.dev.jarvis.cx/kb-core/v1/bot-integration/messenger/publish/',
  };

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
        // Kiểm tra xem phản hồi có phải là JSON hay không
        bool isJson = false;
        dynamic responseData;
        try {
          responseData = json.decode(response.body);
          isJson = true;
        } catch (e) {
          isJson = false;
        }

        if (platformName == 'Slack') {
          if (isJson && responseData is Map && responseData.containsKey('redirect')) {
            final platform = platforms.firstWhere((p) => p.name == platformName);
            platform.isVerified = true;
            platform.isSelected = true; // Tự động chọn sau khi xác thực
            platform.setRedirectUrl(responseData['redirect']);
            print('$platformName isVerified: ${platform.isVerified}, isSelected: ${platform.isSelected}');
            return VerificationResult(success: true, redirectUrl: responseData['redirect']);
          } else {
            // Nếu phản hồi không phải JSON hoặc không chứa 'redirect', giả định thành công
            final platform = platforms.firstWhere((p) => p.name == platformName);
            platform.isVerified = true;
            platform.isSelected = true;
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
          // Đối với Telegram, chỉ kiểm tra 'ok' == true
          if (isJson && responseData['ok'] == true) {
            final platform = platforms.firstWhere((p) => p.name == platformName);
            platform.isVerified = true;
            platform.isSelected = true; // Tự động chọn sau khi xác thực
            platform.setBotToken(data['botToken']!);
            print('$platformName isVerified: ${platform.isVerified}, isSelected: ${platform.isSelected}');
            return VerificationResult(success: true);
          } else {
            return VerificationResult(success: false);
          }
        } else if (platformName == 'Messenger') {
          // Đối với Messenger, mong đợi 'ok' trong response
          if (isJson && responseData['ok'] == true) {
            final platform = platforms.firstWhere((p) => p.name == platformName);
            platform.isVerified = true;
            platform.pageAccessToken = data['pageAccessToken'];
            platform.verifyToken = data['verifyToken'];
            platform.isSelected = true; // Tự động chọn sau khi xác thực
            print('$platformName isVerified: ${platform.isVerified}, isSelected: ${platform.isSelected}');
            return VerificationResult(success: true);
          } else {
            return VerificationResult(success: false);
          }
        } else {
          // Xử lý các nền tảng khác nếu có
          return VerificationResult(success: false);
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

        // Tạo URL publish với assistantId
        final url = '${endpoint}$assistantId';

        try {
          Map<String, dynamic> body = {};

          if (platform.name == 'Telegram') {
            // Đối với Telegram, gửi botToken
            if (platform.botToken == null || platform.botToken!.isEmpty) {
              results[platform.name] = 'Bot Token is missing for Telegram.';
              return;
            }
            body['botToken'] = platform.botToken!;
          } else if (platform.name == 'Messenger') {
            // Đối với Messenger, gửi pageAccessToken và verifyToken
            if (platform.pageAccessToken == null || platform.pageAccessToken!.isEmpty ||
                platform.verifyToken == null || platform.verifyToken!.isEmpty) {
              results[platform.name] = 'Page Access Token or Verify Token is missing for Messenger.';
              return;
            }
            body['pageAccessToken'] = platform.pageAccessToken!;
            body['verifyToken'] = platform.verifyToken!;
          } else if (platform.name == 'Slack') {
            // Đối với Slack, gửi botToken, clientId, clientSecret, signingSecret
            if (platform.botToken == null || platform.botToken!.isEmpty ||
                platform.clientId == null || platform.clientId!.isEmpty ||
                platform.clientSecret == null || platform.clientSecret!.isEmpty ||
                platform.signingSecret == null || platform.signingSecret!.isEmpty) {
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
            // Kiểm tra xem phản hồi có phải là JSON hay không
            bool isJson = false;
            dynamic responseData;
            try {
              responseData = json.decode(response.body);
              isJson = true;
            } catch (e) {
              isJson = false;
            }

            if (isJson && responseData is Map && responseData.containsKey('redirect')) {
              results[platform.name] = responseData['redirect'];
            } else {
              // Nếu phản hồi không phải JSON hoặc không chứa 'redirect', giả định không có redirect
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
