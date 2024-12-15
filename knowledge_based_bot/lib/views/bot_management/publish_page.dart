// lib/views/bot_management/publish_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../store/publish_store.dart';

class PublishPage extends StatefulWidget {
  final String assistantId;

  const PublishPage({super.key, required this.assistantId});

  @override
  _PublishPageState createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage> {
  late PublishStore _publishStore;

  // Controllers for Slack input
  final TextEditingController _slackBotTokenController = TextEditingController();
  final TextEditingController _slackClientIdController = TextEditingController();
  final TextEditingController _slackClientSecretController = TextEditingController();
  final TextEditingController _slackSigningSecretController = TextEditingController();

  // Controllers for Telegram input
  final TextEditingController _telegramBotTokenController = TextEditingController();

  // **Controllers for Messenger input (updated)**
  final TextEditingController _messengerBotTokenController = TextEditingController();
  final TextEditingController _messengerPageIdController = TextEditingController();
  final TextEditingController _messengerAppSecretController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize PublishStore with assistantId
    _publishStore = PublishStore(widget.assistantId);
  }

  @override
  void dispose() {
    // Dispose all controllers
    _slackBotTokenController.dispose();
    _slackClientIdController.dispose();
    _slackClientSecretController.dispose();
    _slackSigningSecretController.dispose();

    _telegramBotTokenController.dispose();

    // **Dispose Messenger controllers**
    _messengerBotTokenController.dispose();
    _messengerPageIdController.dispose();
    _messengerAppSecretController.dispose();

    super.dispose();
  }

  // Function to show verification dialog based on platform
  Future<void> _showVerificationDialog(IntegrationPlatform platform) async {
    if (platform.name == 'Slack') {
      // Slack requires multiple fields
      Map<String, String>? slackData = await showDialog<Map<String, String>>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Verify ${platform.name}'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _slackBotTokenController,
                    decoration: const InputDecoration(
                      labelText: 'Bot Token',
                      hintText: 'e.g., xoxb-...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _slackClientIdController,
                    decoration: const InputDecoration(
                      labelText: 'Client ID',
                      hintText: 'e.g., 8174104925683.8176711409684',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _slackClientSecretController,
                    decoration: const InputDecoration(
                      labelText: 'Client Secret',
                      hintText: 'e.g., 9306d5a10984235385b820df66838ada',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _slackSigningSecretController,
                    decoration: const InputDecoration(
                      labelText: 'Signing Secret',
                      hintText: 'e.g., dd2d30f94af0dcadc85958177d3e3a56',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close without returning data
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  String botToken = _slackBotTokenController.text.trim();
                  String clientId = _slackClientIdController.text.trim();
                  String clientSecret = _slackClientSecretController.text.trim();
                  String signingSecret = _slackSigningSecretController.text.trim();

                  if (botToken.isNotEmpty &&
                      clientId.isNotEmpty &&
                      clientSecret.isNotEmpty &&
                      signingSecret.isNotEmpty) {
                    Navigator.pop(context, {
                      'botToken': botToken,
                      'clientId': clientId,
                      'clientSecret': clientSecret,
                      'signingSecret': signingSecret,
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('All fields are required.')),
                    );
                  }
                },
                child: const Text('Verify'),
              ),
            ],
          );
        },
      );

      if (slackData != null) {
        _verifyPlatform(platform, slackData);
      }
    } else if (platform.name == 'Telegram') {
      // Telegram requires only botToken
      Map<String, String>? telegramData = await showDialog<Map<String, String>>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Verify ${platform.name}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _telegramBotTokenController,
                  decoration: const InputDecoration(
                    labelText: 'Bot Token',
                    hintText: 'e.g., 123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close without returning data
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  String botToken = _telegramBotTokenController.text.trim();

                  if (botToken.isNotEmpty) {
                    Navigator.pop(context, {
                      'botToken': botToken,
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Bot Token is required.')),
                    );
                  }
                },
                child: const Text('Verify'),
              ),
            ],
          );
        },
      );

      if (telegramData != null) {
        _verifyPlatform(platform, telegramData);
      }
    } else if (platform.name == 'Messenger') {
      // **Update Messenger verification to collect botToken, pageId, and appSecret**
      Map<String, String>? messengerData = await showDialog<Map<String, String>>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Verify ${platform.name}'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _messengerBotTokenController,
                    decoration: const InputDecoration(
                      labelText: 'Bot Token',
                      hintText: 'e.g., ABCDEFGHIJKLMNOPQRSTUVWXYZ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _messengerPageIdController,
                    decoration: const InputDecoration(
                      labelText: 'Page ID',
                      hintText: 'e.g., 123456789012345',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _messengerAppSecretController,
                    decoration: const InputDecoration(
                      labelText: 'App Secret',
                      hintText: 'e.g., 9306d5a10984235385b820df66838ada',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close without returning data
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  String botToken = _messengerBotTokenController.text.trim();
                  String pageId = _messengerPageIdController.text.trim();
                  String appSecret = _messengerAppSecretController.text.trim();

                  if (botToken.isNotEmpty && pageId.isNotEmpty && appSecret.isNotEmpty) {
                    Navigator.pop(context, {
                      'botToken': botToken,
                      'pageId': pageId,
                      'appSecret': appSecret,
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('All fields are required.')),
                    );
                  }
                },
                child: const Text('Verify'),
              ),
            ],
          );
        },
      );

      if (messengerData != null) {
        _verifyPlatform(platform, messengerData);
      }
    } else {
      // Handle other platforms if any
    }
  }

  // Function to handle platform verification
  Future<void> _verifyPlatform(IntegrationPlatform platform, Map<String, String> data) async {
    try {
      VerificationResult result = await _publishStore.verifyPlatform(platform.name, data);
      if (result.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${platform.name} verified successfully! You can now publish to proceed with authentication.',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed for ${platform.name}.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error verifying ${platform.name}: $e')),
      );
    }
  }

  // Function to handle publishing
  Future<void> _handlePublish() async {
    try {
      Map<String, dynamic> publishResults = await _publishStore.publishSelected();
      print('Publish Results: $publishResults');

      // Collect redirect URLs from publishResults
      Map<String, String> redirectUrls = {};
      publishResults.forEach((platform, result) {
        if (result is String && result.startsWith('http')) {
          redirectUrls[platform] = result;
        }
      });
      print('Redirect URLs from publishResults: $redirectUrls');

      // Collect redirect URLs from platforms (Slack)
      _publishStore.platforms.forEach((platform) {
        if (platform.name == 'Slack' && platform.redirectUrl != null && platform.redirectUrl!.isNotEmpty) {
          redirectUrls[platform.name] = platform.redirectUrl!;
        }
        // Telegram does not have a redirectUrl
      });
      print('Redirect URLs from platforms: $redirectUrls');

      // Remove empty values
      redirectUrls.removeWhere((key, value) => value.isEmpty);
      print('Final Redirect URLs: $redirectUrls');

      // Collect publish failures
      Map<String, String> failedPublishes = {};
      publishResults.forEach((platform, result) {
        if (!(result is String && result.startsWith('http'))) {
          failedPublishes[platform] = result.toString();
        }
      });
      print('Failed Publishes: $failedPublishes');

      // Show redirect URLs
      if (redirectUrls.isNotEmpty) {
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Redirect Required'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: redirectUrls.length,
                  itemBuilder: (context, index) {
                    String platform = redirectUrls.keys.elementAt(index);
                    String redirectUrl = redirectUrls[platform]!;
                    return ListTile(
                      title: Text(platform),
                      subtitle: SelectableText(
                        redirectUrl,
                        style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.open_in_browser),
                        onPressed: () async {
                          Uri uri = Uri.parse(redirectUrl);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Could not launch $redirectUrl')),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      }

      // Show publish failures
      if (failedPublishes.isNotEmpty) {
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Publish Failed'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: failedPublishes.length,
                  itemBuilder: (context, index) {
                    String platform = failedPublishes.keys.elementAt(index);
                    String error = failedPublishes[platform]!;
                    return ListTile(
                      title: Text(platform),
                      subtitle: Text(error),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      }

      // Final feedback
      if (redirectUrls.isNotEmpty || failedPublishes.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Publish process completed.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Publish failed: $e')),
      );
    }
  }

  // Helper function to get platform icons
  Widget _getPlatformIcon(String platformName) {
    switch (platformName) {
      case 'Slack':
        return const FaIcon(FontAwesomeIcons.slack, color: Colors.orange, size: 40);
      case 'Telegram':
        return const FaIcon(FontAwesomeIcons.telegram, color: Colors.blue, size: 40);
      case 'Messenger':
        return const FaIcon(FontAwesomeIcons.facebookMessenger, color: Colors.blueAccent, size: 40);
      default:
        return const Icon(Icons.device_unknown, size: 40);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publish'),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          Observer(
            builder: (_) {
              // Enable Publish button if at least one platform is selected and verified
              bool canPublish = _publishStore.canPublish;
              return TextButton.icon(
                icon: Icon(Icons.publish, color: canPublish ? Colors.black : Colors.grey),
                label: Text(
                  'Publish',
                  style: TextStyle(
                    color: canPublish ? Colors.black : Colors.grey,
                  ),
                ),
                onPressed: canPublish && !_publishStore.isPublishing ? _handlePublish : null,
              );
            },
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // List of integration platforms
                    Expanded(
                      child: ListView.builder(
                        itemCount: _publishStore.platforms.length,
                        itemBuilder: (context, index) {
                          final platform = _publishStore.platforms[index];
                          return Observer(
                            builder: (_) {
                              return Card(
                                elevation: 3,
                                margin: const EdgeInsets.symmetric(vertical: 8.0),
                                child: ListTile(
                                  leading: _getPlatformIcon(platform.name),
                                  title: Text(
                                    platform.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: platform.isVerified
                                      ? const Text(
                                          'Verified',
                                          style: TextStyle(color: Colors.green),
                                        )
                                      : const Text(
                                          'Not Verified',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Verify button
                                      ElevatedButton(
                                        onPressed: platform.isVerified
                                            ? null
                                            : () => _showVerificationDialog(platform),
                                        child: const Text('Verify'),
                                      ),
                                      const SizedBox(width: 10),
                                      // Checkbox
                                      Checkbox(
                                        value: platform.isSelected,
                                        onChanged: platform.isVerified
                                            ? (bool? value) {
                                                platform.toggleSelection(value);
                                              }
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Optional: Keep Publish button here if desired
                  ],
                ),
              ),
              // Overlay Loader
              if (_publishStore.isPublishing)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
