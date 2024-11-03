import 'package:flutter/material.dart';

class PromptCard extends StatelessWidget {
  final String title;
  final String description;

  const PromptCard({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Text(title),
        subtitle: Text(description),
        trailing: IconButton(
          icon: const Icon(Icons.star_border),
          onPressed: () {
            // Handle favorite action
          },
        ),
        onTap: () {
          // Handle card tap action
        },
      ),
    );
  }
}