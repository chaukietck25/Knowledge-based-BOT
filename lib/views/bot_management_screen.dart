// view/bot_management_screen.dart
import 'package:flutter/material.dart';

class BotManagementScreen extends StatelessWidget {
  const BotManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lí bot, chat với bot được tạo'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const Text(
              'Email được tạo',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              'Chat với chatbot',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: const <Widget>[
                  ListTile(
                    title: Text('Danh sách chat bot'),
                  ),
                  // Thêm các ListTile khác tại đây nếu cần
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}