import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:knowledge_based_bot/views/ads/banner_ad_widget.dart';
import 'package:knowledge_based_bot/widgets/chat_input_field.dart';
import 'package:knowledge_based_bot/widgets/chat_bubble.dart';

class EmailScreen extends StatefulWidget {
  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  String? _selectedFormat;
  String? _selectedTone;
  String? _selectedLength;
  String? _selectedLanguage;

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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Input field for the topic
                  TextField(
                    controller: TextEditingController(),
                    maxLines: 5,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      hintText: 'The topic you want to compose',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                    ),
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
                      _buildOptionChip('Essay', _selectedFormat, (value) {
                        setState(() {
                          _selectedFormat = value;
                        });
                      }),
                      _buildOptionChip('Paragraph', _selectedFormat, (value) {
                        setState(() {
                          _selectedFormat = value;
                        });
                      }),
                      _buildOptionChip('Email', _selectedFormat, (value) {
                        setState(() {
                          _selectedFormat = value;
                        });
                      }),
                      _buildOptionChip('Idea', _selectedFormat, (value) {
                        setState(() {
                          _selectedFormat = value;
                        });
                      }),
                      _buildOptionChip('Blog Post', _selectedFormat, (value) {
                        setState(() {
                          _selectedFormat = value;
                        });
                      }),
                      _buildOptionChip('Outline', _selectedFormat, (value) {
                        setState(() {
                          _selectedFormat = value;
                        });
                      }),
                      _buildOptionChip('Marketing Ads', _selectedFormat,
                          (value) {
                        setState(() {
                          _selectedFormat = value;
                        });
                      }),
                      _buildOptionChip('Comment', _selectedFormat, (value) {
                        setState(() {
                          _selectedFormat = value;
                        });
                      }),
                      _buildOptionChip('Message', _selectedFormat, (value) {
                        setState(() {
                          _selectedFormat = value;
                        });
                      }),
                      _buildOptionChip('Twitter', _selectedFormat, (value) {
                        setState(() {
                          _selectedFormat = value;
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
                          _selectedTone = value;
                        });
                      }),
                      _buildOptionChip('Casual', _selectedTone, (value) {
                        setState(() {
                          _selectedTone = value;
                        });
                      }),
                      _buildOptionChip('Professional', _selectedTone, (value) {
                        setState(() {
                          _selectedTone = value;
                        });
                      }),
                      _buildOptionChip('Enthusiastic', _selectedTone, (value) {
                        setState(() {
                          _selectedTone = value;
                        });
                      }),
                      _buildOptionChip('Informational', _selectedTone, (value) {
                        setState(() {
                          _selectedTone = value;
                        });
                      }),
                      _buildOptionChip('Funny', _selectedTone, (value) {
                        setState(() {
                          _selectedTone = value;
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
                          _selectedLength = value;
                        });
                      }),
                      _buildOptionChip('Medium', _selectedLength, (value) {
                        setState(() {
                          _selectedLength = value;
                        });
                      }),
                      _buildOptionChip('Long', _selectedLength, (value) {
                        setState(() {
                          _selectedLength = value;
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
                          _selectedLanguage = value;
                        });
                      }),
                      _buildOptionChip('Tiếng Việt', _selectedLanguage,
                          (value) {
                        setState(() {
                          _selectedLanguage = value;
                        });
                      }), 
                    ],
                  ),
                  SizedBox(height: 20),
                  // Generate button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[200],
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text('Generate draft'),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Result section
                  Text(
                    'Result:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Input field for the topic
                  TextField(
                    controller: TextEditingController(),
                    maxLines: 5,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      hintText: 'The topic you want to compose',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                    ),
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
                          _selectedFormat = value;
                        });
                      }),
                      _buildOptionChip('Email', _selectedFormat, (value) {
                        setState(() {
                          _selectedFormat = value;
                        });
                      }),
                      _buildOptionChip('Message', _selectedFormat, (value) {
                        setState(() {
                          _selectedFormat = value;
                        });
                      }),
                      _buildOptionChip('Twitter', _selectedFormat, (value) {
                        setState(() {
                          _selectedFormat = value;
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
                          _selectedTone = value;
                        });
                      }),
                      _buildOptionChip('Casual', _selectedTone, (value) {
                        setState(() {
                          _selectedTone = value;
                        });
                      }),
                      _buildOptionChip('Professional', _selectedTone, (value) {
                        setState(() {
                          _selectedTone = value;
                        });
                      }),
                      _buildOptionChip('Enthusiastic', _selectedTone, (value) {
                        setState(() {
                          _selectedTone = value;
                        });
                      }),
                      _buildOptionChip('Informational', _selectedTone, (value) {
                        setState(() {
                          _selectedTone = value;
                        });
                      }),
                      _buildOptionChip('Funny', _selectedTone, (value) {
                        setState(() {
                          _selectedTone = value;
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
                          _selectedLength = value;
                        });
                      }),
                      _buildOptionChip('Medium', _selectedLength, (value) {
                        setState(() {
                          _selectedLength = value;
                        });
                      }),
                      _buildOptionChip('Long', _selectedLength, (value) {
                        setState(() {
                          _selectedLength = value;
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
                          _selectedLanguage = value;
                        });
                      }),
                      _buildOptionChip('Tiếng Việt', _selectedLanguage,
                          (value) {
                        setState(() {
                          _selectedLanguage = value;
                        });
                      }),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Generate button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[200],
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text('Generate draft'),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Result section
                  Text(
                    'Result:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
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
      selected: selectedValue == label,
      onSelected: (isSelected) {
        onSelected(isSelected ? label : '');
      },
    );
  }
}
