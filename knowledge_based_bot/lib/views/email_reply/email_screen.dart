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

  String result = '';

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
          centerTitle: true,
          elevation: 0,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Compose'),
              Tab(text: 'Reply'),
            ],
          ),
        ),
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
                      TextField(
                        controller: fromController,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          labelText: 'From: ',
                          // hintText: 'Sender',
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                      TextField(
                        controller: toController,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          labelText: 'To: ',
                          // hintText: 'Reciver',
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                      // TextField(
                      //   controller: mainIdeaController,
                      //   onChanged: (value) {},
                      //   decoration: InputDecoration(
                      //     labelText: 'Main idea: ',
                      //     // hintText: 'Subject',
                      //     border: UnderlineInputBorder(
                      //       borderSide: BorderSide(color: Colors.grey),
                      //     ),
                      //   ),
                      // ),
                      TextField(
                        controller: subjectController,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          labelText: 'Subject: ',
                          // hintText: 'Subject',
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: emailController,
                        maxLines: 5,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          hintText: 'The topic you want to compose',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Text(
                  //   'Format',
                  //   style: TextStyle(fontWeight: FontWeight.bold),
                  // ),
                  // SizedBox(height: 8),
                  // // Format options
                  // Wrap(
                  //   spacing: 8.0,
                  //   children: [
                  //     _buildOptionChip('Essay', _selectedFormat, (value) {
                  //       setState(() {
                  //         _selectedFormat = value;
                  //       });
                  //     }),
                  //     _buildOptionChip('Paragraph', _selectedFormat, (value) {
                  //       setState(() {
                  //         _selectedFormat = value;
                  //       });
                  //     }),
                  //     _buildOptionChip('Email', _selectedFormat, (value) {
                  //       setState(() {
                  //         _selectedFormat = value;
                  //       });
                  //     }),
                  //     _buildOptionChip('Idea', _selectedFormat, (value) {
                  //       setState(() {
                  //         _selectedFormat = value;
                  //       });
                  //     }),
                  //     _buildOptionChip('Blog Post', _selectedFormat, (value) {
                  //       setState(() {
                  //         _selectedFormat = value;
                  //       });
                  //     }),
                  //     _buildOptionChip('Outline', _selectedFormat, (value) {
                  //       setState(() {
                  //         _selectedFormat = value;
                  //       });
                  //     }),
                  //     _buildOptionChip('Marketing Ads', _selectedFormat,
                  //         (value) {
                  //       setState(() {
                  //         _selectedFormat = value;
                  //       });
                  //     }),
                  //     _buildOptionChip('Comment', _selectedFormat, (value) {
                  //       setState(() {
                  //         _selectedFormat = value;
                  //       });
                  //     }),
                  //     _buildOptionChip('Message', _selectedFormat, (value) {
                  //       setState(() {
                  //         _selectedFormat = value;
                  //       });
                  //     }),
                  //     _buildOptionChip('Twitter', _selectedFormat, (value) {
                  //       setState(() {
                  //         _selectedFormat = value;
                  //       });
                  //     }),
                  //   ],
                  // ),
                  // SizedBox(height: 16),
                  // // Tone options
                  // Text(
                  //   'Tone',
                  //   style: TextStyle(fontWeight: FontWeight.bold),
                  // ),
                  // Wrap(
                  //   spacing: 8.0,
                  //   children: [
                  //     _buildOptionChip('Formal', _selectedTone, (value) {
                  //       setState(() {
                  //         _selectedTone = value;
                  //       });
                  //     }),
                  //     _buildOptionChip('Casual', _selectedTone, (value) {
                  //       setState(() {
                  //         _selectedTone = value;
                  //       });
                  //     }),
                  //     _buildOptionChip('Professional', _selectedTone, (value) {
                  //       setState(() {
                  //         _selectedTone = value;
                  //       });
                  //     }),
                  //     _buildOptionChip('Enthusiastic', _selectedTone, (value) {
                  //       setState(() {
                  //         _selectedTone = value;
                  //       });
                  //     }),
                  //     _buildOptionChip('Informational', _selectedTone, (value) {
                  //       setState(() {
                  //         _selectedTone = value;
                  //       });
                  //     }),
                  //     _buildOptionChip('Funny', _selectedTone, (value) {
                  //       setState(() {
                  //         _selectedTone = value;
                  //       });
                  //     }),
                  //   ],
                  // ),
                  // SizedBox(height: 16),
                  // // Length options
                  // Text(
                  //   'Length',
                  //   style: TextStyle(fontWeight: FontWeight.bold),
                  // ),
                  // Wrap(
                  //   spacing: 8.0,
                  //   children: [
                  //     _buildOptionChip('Short', _selectedLength, (value) {
                  //       setState(() {
                  //         _selectedLength = value;
                  //       });
                  //     }),
                  //     _buildOptionChip('Medium', _selectedLength, (value) {
                  //       setState(() {
                  //         _selectedLength = value;
                  //       });
                  //     }),
                  //     _buildOptionChip('Long', _selectedLength, (value) {
                  //       setState(() {
                  //         _selectedLength = value;
                  //       });
                  //     }),
                  //   ],
                  // ),
                  SizedBox(height: 16),
                  // Language options
                  Text(
                    'Language',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
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
                        backgroundColor: Colors.purple[800],
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text('Generate draft',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  SizedBox(height: 36),
                  // Result section
                  Text(
                    'Result:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: result == '' ? Colors.white : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      result,
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
                  // Input field for the topic
                  Column(
                    children: [
                      TextField(
                        controller: fromController,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          labelText: 'From: ',
                          // hintText: 'Sender',
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                      TextField(
                        controller: toController,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          labelText: 'To: ',
                          // hintText: 'Reciver',
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                      TextField(
                        controller: mainIdeaController,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          labelText: 'Main idea: ',
                          // hintText: 'Subject',
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                      TextField(
                        controller: subjectController,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          labelText: 'Subject: ',
                          // hintText: 'Subject',
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: emailController,
                        maxLines: 5,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          hintText: 'The topic you want to reply',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Format',
                    style: TextStyle(fontWeight: FontWeight.bold),
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
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
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
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
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
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
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
                  SizedBox(height: 20),
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
                        backgroundColor: Colors.purple[800],
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text('Generate draft',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  SizedBox(height: 30),
                  // Result section
                  Text(
                    'Result:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: result == '' ? Colors.white : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      result,
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
    var request = http.Request('POST', Uri.parse('https://api.dev.jarvis.cx/api/v1/ai-email/reply-ideas'));

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
      // print(await response.stream.bytesToString());
      
      final data = json.decode(await response.stream.bytesToString());
      print("data: $data");

      setState(() {
        result = data['ideas'].join('\n');
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
    var request = http.Request('POST', Uri.parse('https://api.dev.jarvis.cx/api/v1/ai-email'));
    request.body = json.encode({
      "mainIdea": mainIdea,
      "action": "Reply to this email",
      "email": email,
      "metadata": {
        "context": [],
        "subject": subject,
        "sender": sender,
        "receiver": receiver,
        "style": {
          "length": length,
          "formality": format,
          "tone": tone
        },
        "language": language
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());

      final data = json.decode(await response.stream.bytesToString());
      print("data: $data");

      setState(() {
        result = data['email'];
      });

    } else {
      print(response.reasonPhrase);
    }
  }
}
