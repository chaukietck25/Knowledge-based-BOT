import 'package:flutter/material.dart';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TranslationScreenState createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  final TextEditingController _textController = TextEditingController();
  String _sourceLanguage = 'English';
  String _targetLanguage = 'Vietnamese';
  String _translatedText = '';

  void _translateText() {
    // Implement the logic to translate the text
    final String text = _textController.text;
    if (text.isNotEmpty) {
      // Perform the translation logic here
      setState(() {
        _translatedText = 'Translated text: $text'; // Placeholder translation
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter text to translate')),
      );
    }
  }

  void _selectSourceLanguage() {
    // Implement the logic to select the source language
    setState(() {
      _sourceLanguage = 'Selected Source Language'; // Placeholder selection
    });
  }

  void _selectTargetLanguage() {
    // Implement the logic to select the target language
    setState(() {
      _targetLanguage = 'Selected Target Language'; // Placeholder selection
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phiên dịch'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Text:',
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Enter text to translate',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _selectSourceLanguage,
                  child: Text('Source: $_sourceLanguage'),
                ),
                ElevatedButton(
                  onPressed: _selectTargetLanguage,
                  child: Text('Target: $_targetLanguage'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _translateText,
              child: const Text('Translate'),
            ),
            const SizedBox(height: 20),
            Text(
              _translatedText,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}