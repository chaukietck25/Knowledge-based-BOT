import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Tools',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Chat'),
            onTap: () {
              // Handle chat action
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Write'),
            onTap: () {
              // Handle write action
            },
          ),
          ListTile(
            leading: const Icon(Icons.translate),
            title: const Text('Translate'),
            onTap: () {
              // Handle translate action
            },
          ),
          ListTile(
            leading: const Icon(Icons.question_answer),
            title: const Text('Ask'),
            onTap: () {
              // Handle ask action
            },
          ),
          ListTile(
            leading: const Icon(Icons.spellcheck),
            title: const Text('Grammar'),
            onTap: () {
              // Handle grammar action
            },
          ),
        ],
      ),
    );
  }
}