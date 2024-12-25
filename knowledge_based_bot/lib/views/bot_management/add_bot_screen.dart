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
    // Chúng ta có thể lấy màu chủ đạo của theme (nếu có) 
    // để đảm bảo tính nhất quán trong toàn bộ ứng dụng.
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Bot'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Assistant Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Assistant Name',
                  hintText: 'Enter your bot\'s name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.android),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter assistant name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Instructions Field
              TextFormField(
                controller: _instructionsController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Instructions',
                  hintText: 'Enter instructions for your bot',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.library_books),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter instructions';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter a description for your bot',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.description),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Error display
              if (_error.isNotEmpty)
                Text(
                  _error,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),

              // Create Bot Button
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: theme.primaryColor,
                        textStyle: const TextStyle(fontSize: 16),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
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
