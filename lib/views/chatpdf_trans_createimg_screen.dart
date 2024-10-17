// view/chatpdf_trans_createimg_screen.dart
import 'package:flutter/material.dart';

class ChatPdfTransCreateImgScreen extends StatelessWidget {
  const ChatPdfTransCreateImgScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Tạo ảnh, Phiên dịch, Chat PDF',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20), // Khoảng cách giữa tiêu đề và các nút
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      // Hành động khi nhấn nút Tạo ảnh
                    },
                    child: const Text('Tạo ảnh'),
                  ),
                  const SizedBox(width: 10), // Khoảng cách giữa các nút
                  ElevatedButton(
                    onPressed: () {
                      // Hành động khi nhấn nút Phiên dịch
                    },
                    child: const Text('Phiên dịch'),
                  ),
                  const SizedBox(width: 10), // Khoảng cách giữa các nút
                  ElevatedButton(
                    onPressed: () {
                      // Hành động khi nhấn nút Chat PDF
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