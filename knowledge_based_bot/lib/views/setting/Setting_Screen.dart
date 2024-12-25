// lib/Views/setting/Setting_Screen.dart
import 'package:flutter/material.dart';
import 'package:knowledge_based_bot/views/chat/chat_settings.dart';
import 'package:knowledge_based_bot/views/profile_screen/profile_screen.dart';
import 'package:knowledge_based_bot/views/about/about_screen.dart';
import 'package:knowledge_based_bot/views/update_account/subcription_screen.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:convert';
import '../../provider_state.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

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
  // String query = '0/40';
  String availableTokens = 'Available Tokens: 30';
  String totalTokens = 'Total Tokens: 30';
  String unlimited = 'false';


  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchAccountSubscription();
    fetchToken();
  }

  void fetchUserData() async {
    String? refeshToken = ProviderState.getRefreshToken();


    print("store sign_in refresh token: $refeshToken");

    final response = await http.get(
      Uri.parse('https://api.dev.jarvis.cx/api/v1/auth/me'),
      headers: {
        'Authorization': 'Bearer $refeshToken',
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

  void fetchAccountSubscription() async {
    String? refeshToken = ProviderState.getRefreshToken();

    var headers = {
    'x-jarvis-guid': '',
    'Authorization': 'Bearer $refeshToken',
    };
    var request = http.Request('GET', Uri.parse('https://api.dev.jarvis.cx/api/v1/subscriptions/me'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print("response: ${response.statusCode}");


    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());

      final data = json.decode(await response.stream.bytesToString());
      print("data: $data");

      typeOfAccount = data['name'];

      setState(() {
        typeOfAccount = data['name'];
      });
    }
    else {
      print(response.reasonPhrase);
      print('Failed to fetch account subscription');

    }
  }

  void fetchToken() async {
    String? refeshToken = ProviderState.getRefreshToken();

    var headers = {
    'x-jarvis-guid': '',
    'Authorization': 'Bearer $refeshToken',
    };
    var request = http.Request('GET', Uri.parse('https://api.dev.jarvis.cx/api/v1/tokens/usage'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print("response: ${response.statusCode}");


    if (response.statusCode == 200) {

      final data = json.decode(await response.stream.bytesToString());
      print("data: $data");

      setState(() {
        availableTokens = data['unlimited'] ? 'Unlimited' : 'Available Tokens: ${data['availableTokens']}';
        totalTokens = data['unlimited'] ? 'Unlimited' : 'Total Tokens: ${data['totalTokens']}';
        unlimited = 'Unlimited: ${data['unlimited']}';
      });
    }
    else {
      print(response.reasonPhrase);
      print('Failed to fetch account token');

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
                      backgroundImage: AssetImage('assets/images/avatar.PNG'),
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
                      Row(
                        children: [
                        Icon(Icons.star, color: Colors.grey),
                        SizedBox(width: 8),
                        Text(
                          typeOfAccount.capitalize(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(41, 40, 44, 1)),
                        ),
                        ],
                      ),
                      Text(
                        availableTokens,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        totalTokens,
                        style:
                          const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        unlimited,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(41, 40, 44, 1),
                      foregroundColor: Colors.white,
                      ),
                      onPressed: ()async {
                      // Handle upgrade button press
                      const url = 'https://admin.dev.jarvis.cx/pricing/overview';
                      // if (await canLaunch(url)) {
                      //   await launch(url);
                      // } else {
                      //   throw 'Could not launch $url';
                      // }
                      if (await canLaunchUrlString(url)) {
                        await launchUrlString(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                      },
                      child: const Text('Nâng cấp'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
          
           
             
            
              ListTile(
                leading: const Icon(Icons.info,
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
