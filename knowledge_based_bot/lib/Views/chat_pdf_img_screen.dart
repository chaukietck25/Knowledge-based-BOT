import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/upload_section.dart';
import '../widgets/chatInput.dart';
import '../widgets/chatMessage.dart';
import 'dart:typed_data';

class ChatPdfImageScreen extends StatefulWidget {
  const ChatPdfImageScreen({super.key});

  @override
  _ChatPdfImageScreenState createState() => _ChatPdfImageScreenState();
}

class _ChatPdfImageScreenState extends State<ChatPdfImageScreen> {
  final List<ChatMessage> _messages = [];

  void _sendMessage(String text) {
    if (text.isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage(text: text, image: '',));
      });
    }
  }

  Future<void> _sendImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final Uint8List imageBytes = await pickedImage.readAsBytes();
      setState(() {
        _messages.add(ChatMessage(imageBytes: imageBytes, fileName: pickedImage.name, image: '',));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                SizedBox(height: 30),
                Text(
                  'ChatImage - Let AI explain images for you',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Turn images into chatbot!',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messages[index];
              },
            ),
          ),
          ChatInput(onSendMessage: _sendMessage, onSendImage: _sendImage),
        ],
      ),
    );
  }
}