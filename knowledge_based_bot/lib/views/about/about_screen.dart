// lib/views/about/about_screen.dart
import 'package:flutter/material.dart';
import 'package:knowledge_based_bot/views/about/term_secutity_screen.dart';
import 'package:knowledge_based_bot/views/about/term_use_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: AppBar(
        title: const Text('Introduction', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromRGBO(41, 40, 44, 1)),
          onPressed: () {
            // Handle back button press
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  // Bạn có thể thêm hành động khi người dùng nhấn vào avatar hoặc tên ứng dụng
                },
                child: const Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/AI.png'),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Chat Bot Based Knowledge',
                      style: TextStyle(
                          fontSize: 20, color: Color.fromRGBO(41, 40, 44, 1)),
                    ),
                    Text(
                      'Version 1.0.0',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Bạn có thể thêm hình ảnh hoặc nội dung giới thiệu ở đây
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.description,
                    color: Color.fromRGBO(41, 40, 44, 1)),
                title: const Text(
                  'Terms of Use',
                  style: TextStyle(color: Color.fromRGBO(41, 40, 44, 1)),
                ),
                trailing:
                    const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TermUseScreen()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.security,
                    color: Color.fromRGBO(41, 40, 44, 1)),
                title: const Text(
                  'Term of Security',
                  style: TextStyle(color: Color.fromRGBO(41, 40, 44, 1)),
                ),
                trailing:
                    const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TermSecurityScreen()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.share,
                    color: Color.fromRGBO(41, 40, 44, 1)),
                title: const Text(
                  'Contact',
                  style: TextStyle(color: Color.fromRGBO(41, 40, 44, 1)),
                ),
                trailing:
                    const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                onTap: () {
                  _launchURL('https://www.facebook.com/Judy.Cooper.93/');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
