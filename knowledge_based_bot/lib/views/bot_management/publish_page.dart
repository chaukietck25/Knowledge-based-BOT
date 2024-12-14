// lib/Views/chat/publish_page.dart
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

  // Controllers for token input
  final Map<String, TextEditingController> _tokenControllers = {};

  @override
  void initState() {
    super.initState();
    // Initialize PublishStore with assistantId
    _publishStore = PublishStore(widget.assistantId);
    // Initialize controllers for each platform
    for (var platform in _publishStore.platforms) {
      _tokenControllers[platform.name] = TextEditingController();
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in _tokenControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // Function to show the verification dialog
  Future<void> _showVerificationDialog(IntegrationPlatform platform) async {
    String? token = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Verify ${platform.name}'),
          content: TextField(
            controller: _tokenControllers[platform.name],
            decoration: const InputDecoration(
              labelText: 'Enter Bot Token',
              hintText: 'enter your token here',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close without returning token
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String input = _tokenControllers[platform.name]?.text.trim() ?? '';
                if (input.isNotEmpty) {
                  Navigator.pop(context, input);
                }
              },
              child: const Text('Verify'),
            ),
          ],
        );
      },
    );

    if (token != null) {
      _verifyPlatform(platform, token);
    }
  }

  // Function to handle platform verification
  Future<void> _verifyPlatform(IntegrationPlatform platform, String token) async {
    try {
      bool success = await _publishStore.verifyPlatform(platform.name, token);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${platform.name} verified successfully!')),
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

      // Collect successful redirects
      Map<String, String> successfulPublishes = {};
      Map<String, String> failedPublishes = {};

      publishResults.forEach((platform, result) {
        if (result is String && result.startsWith('http')) {
          successfulPublishes[platform] = result;
        } else {
          failedPublishes[platform] = result.toString();
        }
      });

      // Show successful redirects
      if (successfulPublishes.isNotEmpty) {
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Publish Successful'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: successfulPublishes.length,
                  itemBuilder: (context, index) {
                    String platform = successfulPublishes.keys.elementAt(index);
                    String redirectUrl = successfulPublishes[platform]!;
                    return ListTile(
                      title: Text(platform),
                      subtitle: Text('Redirect: $redirectUrl'),
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

      // Show failed publishes
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Publish process completed.')),
      );
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
              // Enable the Publish button if at least one platform is selected and verified
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
                    // List of Integration Platforms
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
                                      // Verify Button
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
                    // Optional: You can keep a Publish button at the bottom if desired
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
