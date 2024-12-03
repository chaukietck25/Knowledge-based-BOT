// lib/Views/add_bot_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../provider_state.dart';

class AddBotScreen extends StatefulWidget {
  const AddBotScreen({Key? key}) : super(key: key);

  @override
  _AddBotScreenState createState() => _AddBotScreenState();
}

class _AddBotScreenState extends State<AddBotScreen> {
  final TextEditingController _botNameController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _botNameController.dispose();
    _instructionsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _addBot() async {
    String botName = _botNameController.text.trim();
    String instructions = _instructionsController.text.trim();
    String description = _descriptionController.text.trim();

    if (botName.isEmpty || instructions.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('https://knowledge-api.jarvis.cx/kb-core/v1/ai-assistant');
    final token = ProviderState.getExternalAccessToken(); // Replace with your actual token

    final body = json.encode({
      "assistantName": botName,
      "instructions": instructions,
      "description": description
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bot "${responseData['assistantName']}" added successfully!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add bot: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Bot'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _botNameController,
              decoration: const InputDecoration(
                labelText: 'Bot Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _instructionsController,
              decoration: const InputDecoration(
                labelText: 'Instructions',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _addBot,
                    child: const Text('Create Bot'),
                  ),
          ],
        ),
      ),
    );
  }
}