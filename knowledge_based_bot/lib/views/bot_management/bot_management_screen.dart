// lib\views\bot_management\bot_management_screen.dart
import 'package:flutter/material.dart';
import 'package:knowledge_based_bot/Views/chat_pdf_img_screen.dart';
import 'package:knowledge_based_bot/Views/translation_screen.dart';
import '../../widgets/memo_item.dart';
import 'components/search_bar.dart' as custom;
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../data/models/bot.dart';
import '../../provider_state.dart';

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
        Uri.parse('https://knowledge-api.jarvis.cx/kb-core/v1/ai-assistant'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm kiếm'),
      ),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                custom.SearchBar(
                  onChanged: _filterBots,
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
                                builder: (context) =>
                                    const TranslateScreen()),
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
                                builder: (context) =>
                                    const ChatPdfImageScreen()),
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
                                builder: (context) =>
                                    const ChatPdfImageScreen()),
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
                                    );
                                  },
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