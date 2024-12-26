// lib/Views/setting/Setting_Screen.dart
import 'package:flutter/material.dart';
import 'package:knowledge_based_bot/views/about/about_screen.dart';
import 'package:knowledge_based_bot/views/update_account/subcription_screen.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart';
import 'package:knowledge_based_bot/views/auth/onboarding_screen.dart';

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
  String userName = 'Loading...';
  String email = 'Loading...';
  String userId = 'Loading...'; // Added userId
  String selectedTheme = 'Theo hệ thống';
  String selectedLanguage = 'Tiếng Việt';
  String typeOfAccount = 'Miễn phí';
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
    String? refreshToken = ProviderState.getRefreshToken();

    print("Store sign_in refresh token: $refreshToken");

    final response = await http.get(
      Uri.parse('https://api.dev.jarvis.cx/api/v1/auth/me'),
      headers: {
        'Authorization': 'Bearer $refreshToken',
      },
    );
    print("Response: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Data: $data");

      setState(() {
        userName = data['username'] ?? 'N/A';
        email = data['email'] ?? 'N/A';
        userId = data['id'] ?? 'N/A'; // Set userId
      });
    } else {
      // Handle error
      print('Failed to fetch user data');
      setState(() {
        userName = 'Error';
        email = 'Error';
        userId = 'Error';
      });
    }
  }

  void fetchAccountSubscription() async {
    String? refreshToken = ProviderState.getRefreshToken();

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $refreshToken',
    };
    var request = http.Request('GET', Uri.parse('https://api.dev.jarvis.cx/api/v1/subscriptions/me'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print("Subscription response: ${response.statusCode}");

    if (response.statusCode == 200) {
      final data = json.decode(await response.stream.bytesToString());
      print("Subscription data: $data");

      setState(() {
        typeOfAccount = data['name'];
      });
    } else {
      print(response.reasonPhrase);
      print('Failed to fetch account subscription');
    }
  }

  void fetchToken() async {
    String? refreshToken = ProviderState.getRefreshToken();

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $refreshToken',
    };
    var request = http.Request('GET', Uri.parse('https://api.dev.jarvis.cx/api/v1/tokens/usage'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print("Token response: ${response.statusCode}");

    if (response.statusCode == 200) {
      final data = json.decode(await response.stream.bytesToString());
      print("Token data: $data");

      setState(() {
        availableTokens = data['unlimited']
            ? 'Unlimited'
            : 'Available Tokens: ${data['availableTokens']}';
        totalTokens = data['unlimited']
            ? 'Unlimited'
            : 'Total Tokens: ${data['totalTokens']}';
        unlimited = data['unlimited'];
      });
    } else {
      print(response.reasonPhrase);
      print('Failed to fetch account token');
    }
  }

  // Reusable Info Tile Widget
  Widget _buildInfoTile(String title, String value, IconData trailingIcon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(width: 8),
              Icon(trailingIcon, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  // Logout Button Widget
  Widget _buildLogoutButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.red,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () {
        ProviderState().setRefreshToken(null);
        print("Access Token test: ${ProviderState.getRefreshToken()}");
        // Handle logout button press
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const OnboardingScreen(),
          ),
        );
      },
      child: const Text(
        'Logout',
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.black)),
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
      body: SafeArea( // Ensure content is within safe area
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        // onTap: () {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(builder: (context) => ProfileScreen()),
                        //   );
                        // },
                        child: Column(
                          children: [
                            const CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  AssetImage('assets/images/avatar.PNG'),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              userName,
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Color.fromRGBO(41, 40, 44, 1)),
                            ),
                            Text(
                              email,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.grey),
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
                                    typeOfAccount.capitalize() == 'Basic'
                                        ? const Icon(Icons.star_border,
                                            color: Colors.grey)
                                        : const Icon(Icons.star, color: Colors.yellow),
                                    const SizedBox(width: 8),
                                    Text(
                                      typeOfAccount.capitalize(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Color.fromRGBO(41, 40, 44, 1),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  availableTokens,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                                Text(
                                  totalTokens,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Unlimited: ",
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                    ),
                                    const SizedBox(width: 8),
                                    unlimited == 'true'
                                        ? const Icon(Icons.check,
                                            color: Colors.green)
                                        : const Icon(Icons.close,
                                            color: Colors.red),
                                  ],
                                ),
                              ],
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(41, 40, 44, 1),
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () async {
                                // Handle upgrade button press
                                const url =
                                    'https://admin.dev.jarvis.cx/pricing/overview';
                                if (await canLaunchUrlString(url)) {
                                  await launchUrlString(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              child: const Text('Upgrade'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // User Information Tiles
                      _buildInfoTile('Username', userName, Icons.arrow_forward_ios),
                      _buildInfoTile('Email', email, Icons.copy),
                      _buildInfoTile('User ID', userId, Icons.copy),

                      const SizedBox(height: 16),

                      // Other Settings Options
                      ListTile(
                        leading: const Icon(Icons.info,
                            color: Color.fromRGBO(41, 40, 44, 1)),
                        title: const Text('Introduction',
                            style: TextStyle(
                                color: Color.fromRGBO(41, 40, 44, 1))),
                        trailing: const Icon(Icons.arrow_forward_ios,
                            color: Colors.grey),
                        onTap: () {
                          // Navigate to About Screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AboutScreen()),
                          );
                        },
                      ),
                      // Add more ListTiles here if needed
                    ],
                  ),
                ),
              ),
            ),
            // Logout Button at the bottom
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildLogoutButton(),
            ),
          ],
        ),
      ),
    );
  }
}
