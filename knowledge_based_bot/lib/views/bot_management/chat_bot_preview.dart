// lib/Views/chat/chat_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../provider_state.dart';
import 'publish_page.dart';
import '../knowledge_management/kb_dashboard_screen.dart'; // Adjust the path based on your project structure

class ChatBotScreen extends StatefulWidget {
  final String assistantId;
  final String openAiThreadId;
  final String assistantName;

  const ChatBotScreen({
    Key? key,
    required this.assistantId,
    required this.openAiThreadId,
    required this.assistantName,
  }) : super(key: key);

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, String>> _messages = [];
  bool _isSending = false;

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    setState(() {
      _isSending = true;
      _messages.add({"sender": "user", "text": message.trim()});
    });

    // Scroll to bottom after sending message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    String? token = ProviderState.getExternalAccessToken();
    if (token == null) {
      setState(() {
        _isSending = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Access token is null')),
      );
      return;
    }

    final url =
        'https://knowledge-api.dev.jarvis.cx/kb-core/v1/ai-assistant/${widget.assistantId}/ask';
    final body = {
      "message": message.trim(),
      "openAiThreadId": widget.openAiThreadId,
      "additionalInstruction": ""
    };

    print('Sending body: $body');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      String reply = '';

      if (response.statusCode == 200) {
        final contentType = response.headers['content-type'];
        if (contentType != null && contentType.contains('application/json')) {
          try {
            final responseData = json.decode(response.body);
            print('Decoded Response: $responseData');

            if (responseData is Map<String, dynamic>) {
              // Adjust the key based on actual response structure
              if (responseData.containsKey('reply')) {
                reply = responseData['reply'];
              } else if (responseData.containsKey('data') &&
                  responseData['data'] is Map<String, dynamic> &&
                  responseData['data'].containsKey('reply')) {
                reply = responseData['data']['reply'];
              } else {
                // If 'reply' key is not found, treat the entire response as the reply
                reply = response.body;
              }
            } else if (responseData is String) {
              // If the response is a plain string
              reply = responseData;
            } else {
              // Fallback for unexpected response formats
              reply = 'No valid response received.';
            }
          } catch (e) {
            // Handle JSON parsing errors
            print('JSON Parsing Error: $e');
            // Attempt to handle misencoded text
            reply = _fixEncoding(response.body);
            if (reply.contains('Error')) {
              reply = 'Error parsing response.';
            }
          }
        } else {
          // If Content-Type is not JSON, treat as plain text
          reply = _fixEncoding(response.body);
        }
      } else {
        reply = "Error: ${response.reasonPhrase}";
      }

      setState(() {
        _messages.add({"sender": "bot", "text": reply});
      });
    } catch (e) {
      setState(() {
        _messages.add({"sender": "bot", "text": "Error: $e"});
      });
    } finally {
      setState(() {
        _isSending = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  /// Attempts to fix common encoding issues by re-encoding the response.
  /// This function assumes that the response was originally UTF-8 but was
  /// incorrectly decoded using a different encoding.
  String _fixEncoding(String text) {
    try {
      // Re-encode the string as Latin1 and then decode it back as UTF-8
      // This is a common fix for misdecoded UTF-8 strings
      List<int> bytes = latin1.encode(text);
      String fixedText = utf8.decode(bytes);
      // Simple check: if fixedText still contains garbled text
      if (fixedText.contains('�') || fixedText.contains('\ufffd')) {
        // Unable to fix encoding
        return text;
      }
      return fixedText;
    } catch (e) {
      print('Encoding Fix Error: $e');
      return text; // Return original text if fixing fails
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 60,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildMessage(Map<String, String> message) {
    bool isUser = message['sender'] == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message['text']!,
          style: TextStyle(
            color: isUser ? Colors.black : Colors.black87,
          ),
        ),
      ),
    );
  }

  void _navigateToPublishPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PublishPage(assistantId: widget.assistantId),
      ),
    );
  }

  void _navigateToKbDashboard() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KbDashboardScreen(
          assistantId: widget.assistantId,
          openAiThreadId: widget.openAiThreadId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.assistantName} Preview'),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          // New button to navigate to KbDashboardScreen
          IconButton(
            icon: Icon(Icons.book, color: Colors.black),
            tooltip: 'Knowledge Base',
            onPressed: _navigateToKbDashboard,
          ),
          // Existing Publish button
          TextButton.icon(
            icon: const Icon(Icons.publish, color: Colors.black),
            label: const Text(
              'Publish',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: _navigateToPublishPage,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(_messages[index]);
              },
            ),
          ),
          const Divider(height: 1),
          Container(
            color: theme.scaffoldBackgroundColor,
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: Row(
              children: [
                // ======= CUSTOM TEXTFIELD WITH BORDER RADIUS & BACKGROUND =======
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200], // background color of the text field
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        hintText: 'Type a message',
                        border: InputBorder.none, // remove default border
                      ),
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          _sendMessage(value);
                          _messageController.clear();
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // ======= SEND BUTTON WITH CIRCLE SHAPE & COLOR =======
                _isSending
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Material(
                        color: theme.primaryColor,
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            String msg = _messageController.text.trim();
                            if (msg.isNotEmpty) {
                              _sendMessage(msg);
                              _messageController.clear();
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(Icons.send, color: Colors.white),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
