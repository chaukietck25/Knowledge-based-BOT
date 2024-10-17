// view/prompt_library_screen.dart
import 'package:flutter/material.dart';

class PromptLibraryScreen extends StatelessWidget {
  const PromptLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prompt Library'),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email cần trả lời',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Email được tạo',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Nhập thêm mô tả cho email trả lời',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    'Chủ đề 1',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Chủ đề 2',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Chủ đề 3',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}