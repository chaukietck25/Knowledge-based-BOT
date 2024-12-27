import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:knowledge_based_bot/provider_state.dart';
import 'package:knowledge_based_bot/views/ads/interstitial_ad.dart';

class EmailScreen extends StatefulWidget {
  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  String? _selectedFormat;
  String? _selectedTone;
  String? _selectedLength;
  String? _selectedLanguage;

  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController mainIdeaController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  String resultCompose = '';
  String resultReply = '';

  void initState() {
    super.initState();

    if (!kIsWeb) {
      InterstitialAds.loadInterstitialAd();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Write'),

          centerTitle: false,
          elevation: 0,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Compose'),
              Tab(text: 'Reply'),
            ],
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.blue,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
          ),
        ),
        backgroundColor: Colors.white,
        body: TabBarView(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Input field for the topic
                  Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('From:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          TextField(
                            controller: fromController,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              hintText: 'The sender of the email',
                              hintStyle: TextStyle(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('To:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          TextField(
                            controller: toController,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              hintText: 'The receiver of the email',
                              hintStyle: TextStyle(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Subject:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          TextField(
                            controller: subjectController,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              hintText: 'The subject of the email',
                              hintStyle: TextStyle(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          TextField(
                            controller: emailController,
                            maxLines: 5,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              hintText: 'The topic you want to compose',
                              hintStyle: TextStyle(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                                    borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  Text(
                    'Language',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    children: [
                      _buildOptionChip('English', _selectedLanguage, (value) {
                        setState(() {
                          _selectedLanguage = value.toLowerCase();
                        });
                      }),
                      _buildOptionChip('Tiếng Việt', _selectedLanguage,
                          (value) {
                        setState(() {
                          _selectedLanguage = value.toLowerCase();
                        });
                      }),
                    ],
                  ),
                  SizedBox(height: 30),
                  // Generate button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        suggestIdeaEmail(
                          subjectController.text,
                          fromController.text,
                          toController.text,
                          _selectedLanguage ?? 'vietnamese',
                          emailController.text,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[500],
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text('Generate draft',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    'Result:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 16),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: EdgeInsets.all(10),
                    constraints: BoxConstraints(
                      minWidth: double.infinity,
                      minHeight: 300,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SelectableText(
                      resultCompose,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('From:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          TextField(
                            controller: fromController,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              hintText: 'The sender of the email',
                              hintStyle: TextStyle(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('To:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          TextField(
                            controller: toController,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              hintText: 'The receiver of the email',
                              hintStyle: TextStyle(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Main idea:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          TextField(
                            controller: mainIdeaController,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              hintText: 'The main idea of the email',
                              hintStyle: TextStyle(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Subject:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          TextField(
                            controller: subjectController,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              hintText: 'The subject of the email',
                              hintStyle: TextStyle(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          TextField(
                            controller: emailController,
                            maxLines: 5,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              hintText: 'The topic you want to reply',
                              hintStyle: TextStyle(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                                    borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  Text(
                    'Format',
                    style: TextStyle(fontWeight: FontWeight.bold , fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  // Format options
                  Wrap(
                    spacing: 8.0,
                    children: [
                      _buildOptionChip('Comment', _selectedFormat, (value) {
                        setState(() {
                          _selectedFormat = value.toLowerCase();
                        });
                      }),
                      _buildOptionChip('Email', _selectedFormat, (value) {
                        setState(() {
                          _selectedFormat = value.toLowerCase();
                        });
                      }),
                      _buildOptionChip('Message', _selectedFormat, (value) {
                        setState(() {
                          _selectedFormat = value.toLowerCase();
                        });
                      }),
                      _buildOptionChip('Twitter', _selectedFormat, (value) {
                        setState(() {
                          _selectedFormat = value.toLowerCase();
                        });
                      }),
                      _buildOptionChip('Neutral', _selectedFormat, (value) {
                        setState(() {
                          _selectedFormat = value.toLowerCase();
                        });
                      }),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Tone options
                  Text(
                    'Tone',
                    style: TextStyle(fontWeight: FontWeight.bold , fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    children: [
                      _buildOptionChip('Formal', _selectedTone, (value) {
                        setState(() {
                          _selectedTone = value.toLowerCase();
                        });
                      }),
                      _buildOptionChip('Casual', _selectedTone, (value) {
                        setState(() {
                          _selectedTone = value.toLowerCase();
                        });
                      }),
                      _buildOptionChip('Professional', _selectedTone, (value) {
                        setState(() {
                          _selectedTone = value.toLowerCase();
                        });
                      }),
                      _buildOptionChip('Enthusiastic', _selectedTone, (value) {
                        setState(() {
                          _selectedTone = value.toLowerCase();
                        });
                      }),
                      _buildOptionChip('Informational', _selectedTone, (value) {
                        setState(() {
                          _selectedTone = value.toLowerCase();
                        });
                      }),
                      _buildOptionChip('Funny', _selectedTone, (value) {
                        setState(() {
                          _selectedTone = value.toLowerCase();
                        });
                      }),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Length options
                  Text(
                    'Length',
                    style: TextStyle(fontWeight: FontWeight.bold , fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    children: [
                      _buildOptionChip('Short', _selectedLength, (value) {
                        setState(() {
                          _selectedLength = value.toLowerCase();
                        });
                      }),
                      _buildOptionChip('Medium', _selectedLength, (value) {
                        setState(() {
                          _selectedLength = value.toLowerCase();
                        });
                      }),
                      _buildOptionChip('Long', _selectedLength, (value) {
                        setState(() {
                          _selectedLength = value.toLowerCase();
                        });
                      }),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Language options
                  Text(
                    'Language',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    children: [
                      _buildOptionChip('English', _selectedLanguage, (value) {
                        setState(() {
                          _selectedLanguage = value.toLowerCase();
                        });
                      }),
                      _buildOptionChip('Tiếng Việt', _selectedLanguage,
                          (value) {
                        setState(() {
                          _selectedLanguage = value.toLowerCase();
                        });
                      }),
                    ],
                  ),
                  SizedBox(height: 30),
                  // Generate button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        replyEmail(
                          subjectController.text,
                          fromController.text,
                          toController.text,
                          _selectedLanguage ?? 'vietnamese',
                          _selectedFormat ?? 'neutral',
                          _selectedTone ?? 'friendly',
                          _selectedLength ?? 'long',
                          mainIdeaController.text,
                          emailController.text,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[500],
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text('Generate draft',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  SizedBox(height: 40),
                  // Result section
                  Text(
                    'Result:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: EdgeInsets.all(10),
                    constraints: BoxConstraints(
                      minWidth: double.infinity,
                      minHeight: 300,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SelectableText(
                      resultReply,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionChip(
      String label, String? selectedValue, ValueChanged<String> onSelected) {
    return ChoiceChip(
      label: Text(label),
      selected: selectedValue == label.toLowerCase(),
      onSelected: (isSelected) {
        onSelected(isSelected ? label : '');
      },
    );
  }

  Future<void> suggestIdeaEmail(
    String subject,
    String sender,
    String receiver,
    String language,
    String email,
  ) async {
    String? refeshToken = ProviderState.getRefreshToken();

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $refeshToken',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST',
        Uri.parse('https://api.dev.jarvis.cx/api/v1/ai-email/reply-ideas'));

    request.body = json.encode({
      "action": "Suggest 3 ideas for this email",
      "email": email,
      "metadata": {
        "context": [],
        "subject": subject,
        "sender": sender,
        "receiver": receiver,
        "language": language,
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = json.decode(await response.stream.bytesToString());
      print("data: $data");

      setState(() {
        resultCompose = data['ideas'].join('\n');
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> replyEmail(
    String subject,
    String sender,
    String receiver,
    String language,
    String format,
    String tone,
    String length,
    String mainIdea,
    String email,
  ) async {
    String? refeshToken = ProviderState.getRefreshToken();

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $refeshToken',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('https://api.dev.jarvis.cx/api/v1/ai-email'));
    request.body = json.encode({
      "mainIdea": mainIdea,
      "action": "Reply to this email",
      "email": email,
      "metadata": {
        "context": [],
        "subject": subject,
        "sender": sender,
        "receiver": receiver,
        "style": {"length": length, "formality": format, "tone": tone},
        "language": language
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = json.decode(await response.stream.bytesToString());
      print("data: $data");

      setState(() {
        resultReply = data['email'];
      });
    } else {
      print(response.reasonPhrase);
    }
  }
}
