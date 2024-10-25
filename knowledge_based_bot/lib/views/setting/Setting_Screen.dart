// ignore: file_names
import 'package:flutter/material.dart';
import 'package:knowledge_based_bot/views/profile_screen/profile_screen.dart';
import 'package:knowledge_based_bot/views/about/about_screen.dart';
import 'package:knowledge_based_bot/views/update_account/subcription_screen.dart';

class SettingScreen extends StatefulWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Cài đặt'),

        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color.fromRGBO(41, 40, 44, 1)),
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/avatar.png'),
                    ),
                    SizedBox(height: 16),
                    Text(
                      userName,
                      style: TextStyle(fontSize: 20, color: Color.fromRGBO(41, 40, 44, 1)),
                    ),
                    Text(
                      email,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
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
                              'Miễn phí',
                              style: TextStyle(fontSize: 16, color: Color.fromRGBO(41, 40, 44, 1)),
                            ),
                          ],
                        ),
                        Text(
                          'Truy vấn',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          query,
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(41, 40, 44, 1),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        // Handle upgrade button press
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SubscriptionScreen()));
                      },
                      child: Text('Nâng cấp'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.chat, color: Color.fromRGBO(41, 40, 44, 1)),
                title: Text('Cài đặt trò chuyện', style: TextStyle(color: Color.fromRGBO(41, 40, 44, 1))),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                onTap: () {
                  // Handle chat settings tap
                },
              ),
              ListTile(
                leading: Icon(Icons.color_lens, color: Color.fromRGBO(41, 40, 44, 1)),
                title: Text('Chế độ màu sắc', style: TextStyle(color: Color.fromRGBO(41, 40, 44, 1))),
                trailing: Text(selectedTheme, style: TextStyle(color: Colors.grey)),
                onTap: () {
                  // Handle color mode tap
                },
              ),
              ListTile(
                leading: Icon(Icons.language, color: Color.fromRGBO(41, 40, 44, 1)),
                title: Text('Ngôn ngữ', style: TextStyle(color: Color.fromRGBO(41, 40, 44, 1))),
                trailing: Text(selectedLanguage, style: TextStyle(color: Colors.grey)),
                onTap: () {
                  // Handle language tap
                },
              ),
              ListTile(
                leading: Icon(Icons.memory, color: Color.fromRGBO(41, 40, 44, 1)),
                title: Text('Bộ nhớ', style: TextStyle(color: Color.fromRGBO(41, 40, 44, 1))),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                onTap: () {
                  // Handle memory tap
                },
              ),
              
              ListTile(
                leading: Icon(Icons.share, color: Color.fromRGBO(41, 40, 44, 1)),
                title: Text('Giới thiệu', style: TextStyle(color: Color.fromRGBO(41, 40, 44, 1))),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                onTap: () {
                  // Handle share Monica tap
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AboutScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}