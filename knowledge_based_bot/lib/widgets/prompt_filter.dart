import 'package:flutter/material.dart';

class PromptFilter extends StatelessWidget {
  final List categories = ['All', 'Marketing', 'AI Painting', 'Chatbot', 'SEO', 'Writing'];

  PromptFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: FilterChip(
              label: Text(category),
              onSelected: (bool selected) {
                // Handle filter selection
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}