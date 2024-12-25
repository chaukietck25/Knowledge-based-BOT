// lib/views/about/term_security_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class TermSecurityScreen extends StatelessWidget {
  const TermSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const String markdownData = '''
# Privacy Policy

**Effective Date: 25/12/2024**

## 1. Information Collection

We collect personal information that you provide when registering, using the application, or interacting with features within the app.

## 2. Information Use

Your personal information is used to:

- Improve service quality.
- Provide a personalized user experience.
- Send notifications and updates about the application.

## 3. Information Protection

We implement technical and administrative security measures to protect your personal information from unauthorized access, loss, or alteration.

## 4. Information Sharing

We do not share your personal information with third parties unless you consent or when required by law.

## 5. Your Rights

You have the right to:

- Request access to and edit your personal information.
- Request the deletion of your personal information from the system.

## 6. Contact

If you have any questions about this privacy policy, please contact us via the **Contact** section in the application.

**Thank you for trusting and using our application!**
    ''';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
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
