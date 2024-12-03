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

  Future<List<Bot>> fetchBots() async {
    if (externalAccessToken == null) {
      throw Exception('Access token is null');
    }

    print("external token: $externalAccessToken");

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
        return data.map((json) => Bot.fromJson(json)).toList();
      } else {
        throw Exception('Data field is missing in the response');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid or expired token');
    } else {
      throw Exception('Failed to load bots: ${response.reasonPhrase}');
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
                const custom.SearchBar(),
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
                  child: FutureBuilder<List<Bot>>(
                    future: fetchBots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No bots available.'));
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final bot = snapshot.data![index];
                            return MemoItem(
                              title: bot.assistantName,
                              description: bot.description,
                              time: 'Created • ${DateTime.now().difference(bot.createdAt).inDays} days ago',
                            );
                          },
                        );
                      }
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