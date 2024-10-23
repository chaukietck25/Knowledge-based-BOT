// views/chatpdf_trans_createimg_screen.dart
import 'package:flutter/material.dart';
import 'create_image_screen.dart';
import 'translation_screen.dart';
import 'chat_pdf_screen.dart';

class ChatPdfTransCreateImgScreen extends StatelessWidget {
  const ChatPdfTransCreateImgScreen({super.key});
  
  get gt => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Tạo ảnh, Phiên dịch, Chat PDF',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20), // Khoảng cách giữa tiêu đề và các nút
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CreateImageScreen()),
                      );
                    },
                    child: const Text('Tạo ảnh'),
                  ),
                  const SizedBox(width: 10), // Khoảng cách giữa các nút
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TranslationScreen()),
                      );
                    },
                    child: const Text('Phiên dịch'),
                  ),
                  const SizedBox(width: 10), // Khoảng cách giữa các nút
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ChatPdfScreen()),
                      );
                    },
                    child: const Text('Chat PDF'),
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