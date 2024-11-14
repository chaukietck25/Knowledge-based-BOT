import 'package:flutter/material.dart';
import 'package:knowledge_based_bot/views/contact/contact_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: AppBar(
        title: const Text('Giới thiệu'),

        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromRGBO(41, 40, 44, 1)),
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
                  
                },
                child: const Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/avatar.png'),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'ChatBOT',
                      style: TextStyle(fontSize: 20, color: Color.fromRGBO(41, 40, 44, 1)),
                    ),
                    Text(
                      'version',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.chat, color: Color.fromRGBO(41, 40, 44, 1)),
                title: const Text('Điều khoản sử dụng', style: TextStyle(color: Color.fromRGBO(41, 40, 44, 1))),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                onTap: () {
                  // Handle chat settings tap
                },
              ),
              
              
              ListTile(
                leading: const Icon(Icons.memory, color: Color.fromRGBO(41, 40, 44, 1)),
                title: const Text('Chính sách bảo mật', style: TextStyle(color: Color.fromRGBO(41, 40, 44, 1))),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                onTap: () {
                  // Handle memory tap
                },
              ),
              
              ListTile(
                leading: const Icon(Icons.share, color: Color.fromRGBO(41, 40, 44, 1)),
                title: const Text('Liên hệ', style: TextStyle(color: Color.fromRGBO(41, 40, 44, 1))),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                onTap: () {
                  // Handle share Monica tap
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ContactUsScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
