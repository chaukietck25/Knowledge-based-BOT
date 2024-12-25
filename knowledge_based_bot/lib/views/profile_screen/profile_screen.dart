// Step 1: Import necessary packages
import 'package:flutter/material.dart';
import 'package:knowledge_based_bot/views/auth/onboarding_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../provider_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = "Loading...";
  String email = "Loading...";
  String userId = "Loading...";

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    // sign_in_store = SignInStore();
    String? refeshToken = ProviderState.getRefreshToken();
    print("Refresh Token: $refeshToken");

    final response = await http.get(
      Uri.parse('https://api.dev.jarvis.cx/api/v1/auth/me'),
      headers: {
        'Authorization': 'Bearer $refeshToken',
      },
    );
    print("Response: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Data: $data");

      setState(() {
        username = data['username'] ?? 'N/A';
        email = data['email'] ?? 'N/A';
        userId = data['id'] ?? 'N/A';
      });
      print("Username: $username");
      print("Email: $email");
      print("User ID: $userId");
    } else {
      // Handle error
      print('Failed to fetch user data');
      setState(() {
        username = 'Error';
        email = 'Error';
        userId = 'Error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Thông tin',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
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
                  // Handle avatar tap
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Thay đổi hình đại diện'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.camera_alt),
                              title: const Text('Chụp ảnh mới'),
                              onTap: () {
                                // Handle taking a new photo
                                Navigator.of(context).pop();
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.photo_library),
                              title: const Text('Chọn từ thư viện'),
                              onTap: () {
                                // Handle picking from gallery
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Hủy'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Nhấp để thay đổi hình đại diện',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              _buildInfoTile('Name', username, Icons.arrow_forward_ios),
              _buildInfoTile('Email', email, Icons.copy),
              _buildInfoTile('User ID', userId, Icons.copy),
              const SizedBox(height: 16),
              ElevatedButton(
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
                  'Log out',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
}