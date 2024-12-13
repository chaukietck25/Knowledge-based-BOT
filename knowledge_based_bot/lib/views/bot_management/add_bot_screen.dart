// lib/views/bot_management/add_bot_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../provider_state.dart';

class AddBotScreen extends StatefulWidget {
  const AddBotScreen({super.key});

  @override
  _AddBotScreenState createState() => _AddBotScreenState();
}

class _AddBotScreenState extends State<AddBotScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;
  String _error = '';

  Future<void> _createBot() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = '';
    });

    String? externalAccessToken = ProviderState.getExternalAccessToken();
    if (externalAccessToken == null) {
      setState(() {
        _isLoading = false;
        _error = 'Access token is null';
      });
      return;
    }

    final url = 'https://knowledge-api.dev.jarvis.cx/kb-core/v1/ai-assistant';
    final newBot = {
      "assistantName": _nameController.text,
      "instructions": _instructionsController.text,
      "description": _descriptionController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $externalAccessToken',
          'Content-Type': 'application/json',
        },
        body: json.encode(newBot),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bot created successfully')),
        );
        Navigator.of(context).pop(true); // Indicate success
      } else if (response.statusCode == 401) {
        setState(() {
          _error = 'Unauthorized: Invalid or expired token';
        });
      } else {
        setState(() {
          _error = 'Failed to create bot: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _instructionsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Bot'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Assistant Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter assistant name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _instructionsController,
                decoration: const InputDecoration(labelText: 'Instructions'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter instructions';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              if (_error.isNotEmpty)
                Text(
                  _error,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _createBot,
                      child: const Text('Create Bot'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}