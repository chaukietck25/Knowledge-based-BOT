import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../provider_state.dart';

class ChatBotScreen extends StatefulWidget {
  final String assistantId;
  final String openAiThreadId;

  const ChatBotScreen({
    Key? key,
    required this.assistantId,
    required this.openAiThreadId,
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
        'https://knowledge-api.jarvis.cx/kb-core/v1/ai-assistant/${widget.assistantId}/ask';
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
      // Simple check: if fixedText contains replacement characters or still contains garbled text
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chat Bot'),
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
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          _sendMessage(value);
                          _messageController.clear();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  _isSending
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : IconButton(
                          icon: const Icon(Icons.send),
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            String msg = _messageController.text.trim();
                            if (msg.isNotEmpty) {
                              _sendMessage(msg);
                              _messageController.clear();
                            }
                          },
                        ),
                ],
              ),
            ),
          ],
        ));
  }
}