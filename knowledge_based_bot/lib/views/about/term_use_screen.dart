// lib/views/about/term_use_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class TermUseScreen extends StatelessWidget {
  const TermUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const String markdownData = '''
# Terms of Use

**Effective Date: 25/12/2024**

## 1. Introduction

Welcome to the **Knowledge-Based Bot** application. By using this application, you agree to comply with the terms and conditions outlined below.

## 2. Application Use

- **Usage Rights**: You are granted a limited, non-exclusive, non-transferable license to use this application for personal purposes.

- **Content**: You may not use the application to create, distribute, or store illegal, harmful, or intellectual property-violating content.

## 3. Security

- You are responsible for protecting your login information and accounts from unauthorized access.

## 4. Terms Modification

We reserve the right to modify these terms of use at any time. You should periodically review them to stay updated with the latest changes.

## 5. Contact

If you have any questions about these terms, please contact us via the **Contact** section in the application.

**Thank you for using our application!**
    ''';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Terms of Use',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Markdown(
        data: markdownData,
        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
          h1: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          h2: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          p: const TextStyle(fontSize: 16, color: Colors.black),
          strong: const TextStyle(fontWeight: FontWeight.bold),
          listBullet:
              const TextStyle(fontSize: 16, color: Colors.black),
          blockSpacing: 12.0,
        ),
      ),
    );
  }
}
