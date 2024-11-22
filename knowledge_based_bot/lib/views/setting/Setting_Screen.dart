// lib/Views/setting/Setting_Screen.dart
import 'package:flutter/material.dart';
import 'package:knowledge_based_bot/views/chat_settings.dart';
import 'package:knowledge_based_bot/views/profile_screen/profile_screen.dart';
import 'package:knowledge_based_bot/views/about/about_screen.dart';
import 'package:knowledge_based_bot/views/update_account/subcription_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../provider_state.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String userName = 'userName';
  String email = 'email@example.com';
  String selectedTheme = 'Theo hệ thống';
  String selectedLanguage = 'Tiếng Việt';
  String typeOfAccount = 'Miễn phí';
  String query = '0/40';


  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    String? accessToken = ProviderState.getAccessToken();
    print("store sign_in access token: $accessToken");

    final response = await http.get(
      Uri.parse('https://api.dev.jarvis.cx/api/v1/auth/me'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    print("response: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("data: $data");
      // print("userName0: $userName");
      // print("email0: $email");
      userName = data['username'];
      email = data['email'];
      setState(() {
        userName = data['username'];
        email = data['email'];
      });

    } else {
      // Handle error
      print('Failed to fetch user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Cài đặt'),
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/avatar.png'),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      userName,
                      style: const TextStyle(
                          fontSize: 20, color: Color.fromRGBO(41, 40, 44, 1)),
                    ),
                    Text(
                      email,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.star, color: Colors.grey),
                            SizedBox(width: 8),
                            Text(
                              'Miễn phí',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(41, 40, 44, 1)),
                            ),
                          ],
                        ),
                        const Text(
                          'Truy vấn',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          query,
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(41, 40, 44, 1),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        // Handle upgrade button press
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SubscriptionScreen()));
                      },
                      child: const Text('Nâng cấp'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.chat,
                    color: Color.fromRGBO(41, 40, 44, 1)),
                title: const Text('Cài đặt trò chuyện',
                    style: TextStyle(color: Color.fromRGBO(41, 40, 44, 1))),
                trailing:
                    const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                onTap: () {
                  // Handle chat settings tap
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChatSettingsScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.color_lens,
                    color: Color.fromRGBO(41, 40, 44, 1)),
                title: const Text('Chế độ màu sắc',
                    style: TextStyle(color: Color.fromRGBO(41, 40, 44, 1))),
                trailing: Text(selectedTheme,
                    style: const TextStyle(color: Colors.grey)),
                onTap: () {
                  // Handle color mode tap
                },
              ),
              ListTile(
                leading: const Icon(Icons.language,
                    color: Color.fromRGBO(41, 40, 44, 1)),
                title: const Text('Ngôn ngữ',
                    style: TextStyle(color: Color.fromRGBO(41, 40, 44, 1))),
                trailing: Text(selectedLanguage,
                    style: const TextStyle(color: Colors.grey)),
                onTap: () {
                  // Handle language tap
                },
              ),
              ListTile(
                leading: const Icon(Icons.memory,
                    color: Color.fromRGBO(41, 40, 44, 1)),
                title: const Text('Bộ nhớ',
                    style: TextStyle(color: Color.fromRGBO(41, 40, 44, 1))),
                trailing:
                    const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                onTap: () {
                  // Handle memory tap
                },
              ),
              ListTile(
                leading: const Icon(Icons.share,
                    color: Color.fromRGBO(41, 40, 44, 1)),
                title: const Text('Giới thiệu',
                    style: TextStyle(color: Color.fromRGBO(41, 40, 44, 1))),
                trailing:
                    const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                onTap: () {
                  // Handle share Monica tap
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AboutScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
