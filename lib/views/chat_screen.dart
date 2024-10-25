import 'package:flutter/material.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/upload_section.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ChatPDF - Let AI read PDF for you',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Turn PDF into chatbot!',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            UploadSection(),
          ],
        ),
      ),
    );
  }
}