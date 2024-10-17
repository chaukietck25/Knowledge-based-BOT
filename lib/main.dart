// main.dart
import 'package:flutter/material.dart';
import 'views/prompt_library_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PromptLibraryScreen(),
    );
  }
}