import 'package:flutter/material.dart';
import 'package:knowledge_based_bot/views/chat/chat_pdf_img_screen.dart';
import 'package:knowledge_based_bot/views/chat/translation_screen.dart';
import '../../widgets/memo_item.dart';
import 'components/search_bar.dart' as custom;
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../data/models/bot.dart';
import '../../provider_state.dart';
import 'add_bot_screen.dart';
import 'chat_bot_preview.dart'; // Import ChatBotScreen

class MonicaSearch extends StatefulWidget {
  const MonicaSearch({super.key});

  @override
  State<MonicaSearch> createState() => _MonicaSearchState();
}

class _MonicaSearchState extends State<MonicaSearch> {
  String? externalAccessToken = ProviderState.getExternalAccessToken();
  List<Bot> _allBots = [];
  List<Bot> _filteredBots = [];
  bool _isLoading = true;
  String _error = '';
  Bot? _selectedBot; // Add selected bot state

  @override
  void initState() {
    super.initState();
    fetchBots();
  }

  Future<void> fetchBots() async {
    if (externalAccessToken == null) {
      setState(() {
        _isLoading = false;
        _error = 'Access token is null';
      });
      return;
    }

    print("external token: $externalAccessToken");

    try {
      final response = await http.get(
        Uri.parse('https://knowledge-api.dev.jarvis.cx/kb-core/v1/ai-assistant'),
        headers: {
          'Authorization': 'Bearer $externalAccessToken',
          'Content-Type': 'application/json',
        },
      );

      print("response status: ${response.statusCode}");
      print("response: ${response.body}");

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        if (jsonResponse.containsKey('data')) {
          List<dynamic> data = jsonResponse['data'];
          _allBots = data.map((json) => Bot.fromJson(json)).toList();
          _filteredBots = _allBots;
        } else {
          _error = 'Data field is missing in the response';
        }
      } else if (response.statusCode == 401) {
        _error = 'Unauthorized: Invalid or expired token';
      } else {
        _error = 'Failed to load bots: ${response.reasonPhrase}';
      }
    } catch (e) {
      _error = 'Error: $e';
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterBots(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredBots = _allBots;
      });
    } else {
      setState(() {
        _filteredBots = _allBots
            .where((bot) => bot.assistantName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  Future<void> deleteBot(String botId) async {
    if (externalAccessToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Access token is null')),
      );
      return;
    }

    final url = 'https://knowledge-api.dev.jarvis.cx/kb-core/v1/ai-assistant/$botId';
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $externalAccessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {
          _allBots.removeWhere((bot) => bot.id == botId);
          _filteredBots.removeWhere((bot) => bot.id == botId);
          if (_selectedBot?.id == botId) {
            _selectedBot = null;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bot deleted successfully')),
        );
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unauthorized: Invalid or expired token')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete bot: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> updateBot(Bot bot) async {
    if (externalAccessToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Access token is null')),
      );
      return;
    }

    final url = 'https://knowledge-api.dev.jarvis.cx/kb-core/v1/ai-assistant/${bot.id}';
    final TextEditingController nameController = TextEditingController(text: bot.assistantName);
    final TextEditingController instructionsController = TextEditingController(text: bot.instructions);
    final TextEditingController descriptionController = TextEditingController(text: bot.description);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Bot'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Assistant Name'),
                ),
                TextField(
                  controller: instructionsController,
                  decoration: const InputDecoration(labelText: 'Instructions'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedBot = {
                  "assistantName": nameController.text,
                  "instructions": instructionsController.text,
                  "description": descriptionController.text,
                };

                try {
                  final response = await http.patch(
                    Uri.parse(url),
                    headers: {
                      'Authorization': 'Bearer $externalAccessToken',
                      'Content-Type': 'application/json',
                    },
                    body: json.encode(updatedBot),
                  );

                  if (response.statusCode == 200) {
                    final updatedJson = json.decode(response.body);
                    final updatedBotInstance = Bot.fromJson(updatedJson);

                    setState(() {
                      int index = _allBots.indexWhere((b) => b.id == bot.id);
                      if (index != -1) {
                        _allBots[index] = updatedBotInstance;
                      }

                      int filteredIndex = _filteredBots.indexWhere((b) => b.id == bot.id);
                      if (filteredIndex != -1) {
                        _filteredBots[filteredIndex] = updatedBotInstance;
                      }

                      if (_selectedBot?.id == bot.id) {
                        _selectedBot = updatedBotInstance;
                      }
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Bot updated successfully')),
                    );

                    Navigator.of(context).pop();
                  } else if (response.statusCode == 401) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Unauthorized: Invalid or expired token')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to update bot: ${response.reasonPhrase}')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleAddBot() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddBotScreen()),
    );

    if (result == true) {
      setState(() {
        _isLoading = true;
        _error = '';
      });
      await fetchBots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm kiếm'),
      ),
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    custom.SearchBar(
                      onChanged: _filterBots,
                      onAdd: _handleAddBot,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(41, 40, 44, 1),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {},
                            child: const Text('Công cụ'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(41, 40, 44, 1),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const TranslateScreen()),
                              );
                            },
                            child: const Text('Phiên dịch'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(41, 40, 44, 1),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ChatPdfImageScreen()),
                              );
                            },
                            child: const Text('ChatPDF'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(41, 40, 44, 1),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ChatPdfImageScreen()),
                              );
                            },
                            child: const Text('More'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _error.isNotEmpty
                              ? Center(child: Text(_error))
                              : _filteredBots.isEmpty
                                  ? const Center(child: Text('No bots available.'))
                                  : ListView.builder(
                                      itemCount: _filteredBots.length,
                                      itemBuilder: (context, index) {
                                        final bot = _filteredBots[index];
                                        return MemoItem(
                                          title: bot.assistantName,
                                          description: bot.description,
                                          time: 'Created • ${DateTime.now().difference(bot.createdAt).inDays} days ago',
                                          onDelete: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text('Delete Bot'),
                                                  content: const Text('Are you sure you want to delete this bot?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.of(context).pop(),
                                                      child: const Text('Cancel'),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                        deleteBot(bot.id);
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.red,
                                                      ),
                                                      child: const Text('Delete'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          onUpdate: () {
                                            updateBot(bot);
                                          },
                                          onTap: () { // Select bot on tap
                                            setState(() {
                                              _selectedBot = bot;
                                            });
                                          },
                                          isSelected: _selectedBot?.id == bot.id, // Highlight selected
                                        );
                                      },
                                    ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Floating Chat Bubble
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                if (_selectedBot != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatBotScreen(
                        assistantId: _selectedBot!.id,
                        assistantName: _selectedBot!.assistantName,
                        openAiThreadId: _selectedBot!.openAiThreadIdPlay,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select a bot to chat.')),
                  );
                }
              },
              child: const Icon(Icons.chat),
            ),
          ),
        ],
      ),
    );
  }
}