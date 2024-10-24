import 'package:flutter/material.dart';

import 'package:knowledge_based_bot/views/auth/onboarding_screen.dart';
import 'package:knowledge_based_bot/views/setting/Setting_Screen.dart';
import 'package:knowledge_based_bot/views/contact/contact_screen.dart';
import 'package:knowledge_based_bot/views/email_reply/emailReply_screen.dart';

import 'package:knowledge_based_bot/Views/bot_screen.dart';
import 'package:knowledge_based_bot/Views/chat_settings.dart';
import 'package:knowledge_based_bot/Views/home_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class CustomLoginPage extends StatelessWidget {
  const CustomLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: const [
                  Text(
                    'ChatBot AI',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Siêu cấp vũ trụ'),
                  Text(''),
                  Text('Hãy tham gia cùng chúng tôi'),
                ],
              ),
              const SizedBox(height: 20.0),
              const Text('HCMUS '),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.ac_unit),
                  SizedBox(width: 10.0),
                  Icon(Icons.access_alarm),
                  // Add more icons as needed
                ],
              ),
              const SizedBox(height: 20.0),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle Google login logic here
                    },
                    child: const Text('Tiếp tục với Google'),
                  ),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      // Handle Email login logic here
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AuthScreen()),
                      );
                    },
                    child: const Text('Tiếp tục với Email'),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              const Text('Điều khoản dịch vụ'),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  int _selectedIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
          },
        ),
        title: Text('Đăng nhập - Monica'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage:
                  AssetImage('assets/logo.png'), // Replace with your logo asset
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.login),
              label: Text('Đăng nhập bằng Google'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                side: BorderSide(color: Colors.grey),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.apple),
              label: Text('Đăng nhập bằng Apple'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                side: BorderSide(color: Colors.grey),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => _onTabTapped(0),
                  child: Text(
                    'Đăng nhập',
                    style: TextStyle(
                      color: _selectedIndex == 0 ? Colors.purple : Colors.black,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _onTabTapped(1),
                  child: Text(
                    'Đăng ký',
                    style: TextStyle(
                      color: _selectedIndex == 1 ? Colors.purple : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: [
                  LoginForm(),
                  RegisterForm(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        Divider(),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Đăng nhập bằng Email',
            hintText: 'Địa chỉ email',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Mật khẩu',
            hintText: 'Mật khẩu',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {},
          child: Text('Tiếp theo'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 50),
          ),
        ),
      ],
    );
  }
}

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        Divider(),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'Phamdang7702@gmail.com',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          obscureText: _isObscure,
          decoration: InputDecoration(
            labelText: 'Mật khẩu',
            hintText: 'Phamdang707!',
            border: OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(
                _isObscure ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
            ),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Bí danh',
            hintText: 'Pvhd',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {},
          child: Text('Đăng ký'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 50),
          ),
        ),
      ],
    );
  }
}

class CreateBotScreen extends StatefulWidget {
  @override
  _CreateBotScreenState createState() => _CreateBotScreenState();
}

class _CreateBotScreenState extends State<CreateBotScreen> {
  String selectedModel = 'GPT-3'; // Initialize with a default value
  String selectedPermission = 'Công khai'; //permission
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
          },
        ),
        title: Text('Tạo bot'),
        actions: [
          TextButton(
            onPressed: () {
              // Handle automatic creation
            },
            child: Text(
              'Tạo tự động',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.black,
                //child: Icon(Icons.cube, size: 40, color: Colors.white),
              ),
              SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.copy),
                label: Text('Sao chép từ mạng xã hội'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: BorderSide(color: Colors.grey),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Tên',
                  hintText: 'Tên bot',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Mô tả Cài Đặt',
                  hintText:
                      'Ví dụ: Bạn là một nhà văn khoa học viễn tưởng giàu kinh nghiệm. Bạn xuất sắc trong việc tạo ra những thế giới tương lai độc đáo và cốt truyện hấp dẫn.',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text('Mô hình'),
                // trailing text should be replaced with selected model

                trailing: Text(selectedModel), // Replace with selected model
                onTap: () {
                  // open model selection dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Chọn mô hình'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              GestureDetector(
                                child: Text('GPT-3'),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    // Replace trailing text with selected model
                                    selectedModel = 'GPT-3';
                                  });
                                },
                              ),
                              Padding(padding: EdgeInsets.all(8.0)),
                              GestureDetector(
                                child: Text('GPT-4'),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    // Replace trailing text with selected model
                                    selectedModel = 'GPT-4';
                                  });
                                },
                              ),
                              Padding(padding: EdgeInsets.all(8.0)),
                              GestureDetector(
                                child: Text('GPT-4o mini'),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    // Replace trailing text with selected model
                                    selectedModel = 'GPT-4o mini';
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Đóng'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              Divider(),
              ListTile(
                title: Text('Quyền hạn'),
                trailing: Text(selectedPermission),
                onTap: () {
                  // Handle permission selection
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Thay đổi quyền'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              GestureDetector(
                                child: Text('Chỉ mình tôi'),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    // Replace trailing text with selected model
                                    selectedPermission = 'Chỉ mình tôi';
                                  });
                                },
                              ),
                              Padding(padding: EdgeInsets.all(8.0)),
                              GestureDetector(
                                child: Text('Bất kì ai có đường liên kết'),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    // Replace trailing text with selected model
                                    selectedPermission =
                                        'Bất kì ai có đường liên kết';
                                  });
                                },
                              ),
                              Padding(padding: EdgeInsets.all(8.0)),
                              GestureDetector(
                                child: Text(
                                    'Công khai - Mọi người đều có thể truy cập'),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    // Replace trailing text with selected model
                                    selectedPermission =
                                        'Công khai - Mọi người đều có thể truy cập';
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Đóng'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              Divider(),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Mô tả',
                  hintText:
                      'Ví dụ: Tôi là một nhà văn khoa học viễn tưởng có kinh nghiệm.',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle bot creation
                },
                child: Text('Tạo bot'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class SettingScreen extends StatefulWidget {
//   @override
//   _SettingScreenState createState() => _SettingScreenState();
// }

// class _SettingScreenState extends State<SettingScreen> {
//   String userName = 'userName';
//   String email = 'email@example.com';
//   String selectedTheme = 'Theo hệ thống';
//   String selectedLanguage = 'Tiếng Việt';
//   String typeOfAccount = 'Miễn phí';
//   String query = '0/40';
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             // Handle back button press
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(height: 20),
//             InkWell(
//               child: Column(
//                 children: [
//                   CircleAvatar(
//                     radius: 40,
//                     backgroundColor: Colors.grey,
//                     child: Icon(Icons.person, size: 40, color: Colors.white),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     userName,
//                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     email,
//                     style: TextStyle(color: Colors.grey),
//                   )
//                 ],
//               ),
//               onTap: () {
//                 // Handle profile settings
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ProfileScreen()),
//                 );
//               },
//             ),
//             SizedBox(height: 16),
//             Card(
//               margin: EdgeInsets.symmetric(horizontal: 16),
//               child: ListTile(
//                 leading: Icon(Icons.star),
//                 title: Text(typeOfAccount),
//                 subtitle: Text(query),
//                 trailing: ElevatedButton(
//                   onPressed: () {
//                     // Handle upgrade button press
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => SubscriptionScreen()),
//                     );
//                   },
//                   child: Text('Nâng cấp'),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//             ListTile(
//               leading: Icon(Icons.chat),
//               title: Text('Cài đặt trò chuyện'),
//               onTap: () {
//                 // Handle chat settings
//               },
//             ),
//             Divider(),
//             ListTile(
//               leading: Icon(Icons.color_lens),
//               title: Text('Chế độ màu sắc'),
//               trailing: Text(selectedTheme),
//               onTap: () {
//                 // Handle color mode settings
//               },
//             ),
//             Divider(),
//             ListTile(
//               leading: Icon(Icons.language),
//               title: Text('Ngôn ngữ'),
//               trailing: Text(selectedLanguage),
//               onTap: () {
//                 // Handle language settings
//               },
//             ),
//             Divider(),
//             ListTile(
//               leading: Icon(Icons.memory),
//               title: Text('Bộ nhớ'),
//               trailing: Icon(Icons.circle, color: Colors.red, size: 10),
//               onTap: () {
//                 // Handle memory settings
//               },
//             ),
//             Divider(),
//             ListTile(
//               leading: Icon(Icons.info),
//               title: Text('Giới thiệu'),
//               onTap: () {
//                 // Handle about
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => AboutScreen()),
//                 );
//               },
//             ),
//             Divider(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ProfileScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Thông tin'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             // Handle back button press
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Column(
//         children: [
//           SizedBox(height: 20),
//           GestureDetector(
//             onTap: () {
//               // Handle avatar change
//               showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return AlertDialog(
//                     title: Text('Thay đổi hình đại diện'),
//                     content: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         ListTile(
//                           leading: Icon(Icons.camera_alt),
//                           title: Text('Chụp ảnh mới'),
//                           onTap: () {
//                             // Handle taking a new photo
//                             Navigator.of(context).pop();
//                           },
//                         ),
//                         ListTile(
//                           leading: Icon(Icons.photo_library),
//                           title: Text('Chọn từ thư viện'),
//                           onTap: () {
//                             // Handle picking from gallery
//                             Navigator.of(context).pop();
//                           },
//                         ),
//                       ],
//                     ),
//                     actions: <Widget>[
//                       TextButton(
//                         child: Text('Hủy'),
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                       ),
//                     ],
//                   );
//                 },
//               );
//             },
//             child: CircleAvatar(
//               radius: 40,
//               backgroundColor: Colors.grey,
//               child: Icon(Icons.person, size: 40, color: Colors.white),
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             'Nhấp để thay đổi hình đại diện',
//             style: TextStyle(color: Colors.grey),
//           ),
//           SizedBox(height: 16),
//           ListTile(
//             title: Text('Tên'),
//             trailing: Text('Pvhd'),
//             onTap: () {
//               // Handle name change
//               //change name
//               showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   TextEditingController nameController =
//                       TextEditingController();
//                   return AlertDialog(
//                     title: Text('Thay đổi tên'),
//                     content: TextField(
//                       controller: nameController,
//                       decoration: InputDecoration(hintText: "Nhập tên mới"),
//                     ),
//                     actions: <Widget>[
//                       TextButton(
//                         child: Text('Hủy'),
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                       ),
//                       TextButton(
//                         child: Text('Lưu'),
//                         onPressed: () {
//                           // Handle name change logic here
//                           Navigator.of(context).pop();
//                         },
//                       ),
//                     ],
//                   );
//                 },
//               );
//             },
//           ),
//           Divider(),
//           ListTile(
//             title: Text('Email'),
//             subtitle: Text('Phamdang7702@gmail.com'),
//             trailing: Icon(Icons.copy),
//             onTap: () {
//               // Handle email change
//             },
//           ),
//           Divider(),
//           ListTile(
//             title: Text('ID người dùng'),
//             subtitle: Text('126ee27cad4c4bd6b9291caeb7bfcc23'),
//             trailing: Icon(Icons.copy),
//             onTap: () {
//               // Handle user ID copy
//             },
//           ),
//           Divider(),
//           Spacer(),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red, // Corrected from 'primary'
//                 foregroundColor: Colors.white, // Corrected from 'onPrimary'
//                 minimumSize: Size(double.infinity, 50),
//               ),
//               onPressed: () {
//                 // Handle logout
//               },
//               child: Text('Đăng xuất'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AboutScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Giới thiệu'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             // Handle back button press
//             // back to setting screen
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Column(
//         children: [
//           SizedBox(height: 40),
//           CircleAvatar(
//             radius: 40,
//             backgroundColor: Colors.grey,
//             child: Icon(Icons.person, size: 40, color: Colors.white),
//           ),
//           SizedBox(height: 8),
//           Text(
//             'ChatBOT',
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           Text(
//             'version 0.0.0',
//             style: TextStyle(color: Colors.grey),
//           ),
//           SizedBox(height: 16),
//           Container(
//             color: Colors.white,
//             child: Column(
//               children: [
//                 ListTile(
//                   title: Text('Điều khoản sử dụng'),
//                   trailing: Icon(Icons.arrow_forward_ios),
//                   onTap: () {
//                     // Handle terms of use
//                   },
//                 ),
//                 Divider(height: 1),
//                 ListTile(
//                   title: Text('Chính sách bảo mật'),
//                   trailing: Icon(Icons.arrow_forward_ios),
//                   onTap: () {
//                     // Handle privacy policy
//                   },
//                 ),
//                 Divider(height: 1),
//                 ListTile(
//                   title: Text('Liên hệ'),
//                   trailing: Icon(Icons.arrow_forward_ios),
//                   onTap: () {
//                     // Handle contact
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => ContactUsScreen()),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ContactUsScreen extends StatelessWidget {
//   final List<String> issueTypes = ["Báo cáo lỗi", "Yêu cầu tính năng", "Khác"];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Thư | Liên hệ chúng tôi'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             // Handle back button press
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Column(
//                   children: [
//                     CircleAvatar(
//                       radius: 40,
//                       backgroundColor: Colors.grey,
//                       child: Icon(Icons.person, size: 40, color: Colors.white),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       'ChatBOT',
//                       style:
//                           TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 16),
//               Text(
//                 'Liên hệ chúng tôi',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 'Do sự chênh lệch về múi giờ và giờ làm việc, phản hồi của bạn sẽ được xử lý trong vòng 48 giờ làm việc. Vui lòng kiểm tra email để nhận phản hồi của chúng tôi.',
//               ),
//               SizedBox(height: 16),
//               DropdownButtonFormField<String>(
//                 decoration: InputDecoration(
//                   labelText: 'Loại vấn đề',
//                   border: OutlineInputBorder(),
//                 ),
//                 items: issueTypes.map((String issue) {
//                   return DropdownMenuItem<String>(
//                     value: issue,
//                     child: Text(issue),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   // Handle change
//                 },
//               ),
//               SizedBox(height: 16),
//               TextFormField(
//                 decoration: InputDecoration(
//                   labelText: 'Tóm tắt lỗi',
//                   hintText:
//                       'Hãy cho chúng tôi biết điều gì đã sai trong vài từ.',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 16),
//               TextFormField(
//                 decoration: InputDecoration(
//                   labelText: 'Chi tiết lỗi',
//                   hintText:
//                       'Vui lòng mô tả chi tiết điều gì đã sai, bất kỳ hành động nào bạn đã thực hiện và thông báo lỗi mà bạn đã nhận được.',
//                   border: OutlineInputBorder(),
//                 ),
//                 maxLines: 5,
//               ),
//               SizedBox(height: 16),
//               TextFormField(
//                 decoration: InputDecoration(
//                   labelText: 'Địa chỉ email của bạn',
//                   hintText:
//                       'Nhập địa chỉ email để nhận thông tin cập nhật về vấn đề.',
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//               ),
//               SizedBox(height: 16),
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red, // Corrected from 'primary'
//                     foregroundColor: Colors.white, // Corrected from 'onPrimary'
//                     minimumSize: Size(double.infinity, 50),
//                   ),
//                   onPressed: () {
//                     // Handle logout
//                   },
//                   child: Text('Gửi'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// class SubscriptionScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Đăng ký'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             // Handle back button press
//           },
//         ),
//       ),
//       body: PageView(
//         children: [
//           SubscriptionPlan(
//             title: 'Pro+',
//             features: [
//               'feature 1',
//               'feature 2',
//               'feature 3',
//             ],
//             proFeatures: [
//               'feature 1',
//               'feature 2',
//               'feature 3',
//             ],
//             otherBenefits: [
//               'benefit 1',
//               'benefit 2',
//               'benefit 3',
//             ],
//             price: 'Bắt đầu từ 999.000 đ',
//           ),
//           SubscriptionPlan(
//             title: 'Pro Max',
//             features: [
//               'feature 1',
//               'feature 2',
//               'feature 3',
//             ],
//             proFeatures: [
//               'feature 1',
//               'feature 2',
//               'feature 3',
//             ],
//             otherBenefits: [
//               'benefit 1',
//               'benefit 2',
//               'benefit 3',
//             ],
//             price: 'Bắt đầu từ 1.999.000 đ',
//           ),
//         ],
//       ),
//     );
//   }
// }

// class SubscriptionPlan extends StatelessWidget {
//   final String title;
//   final List<String> features;
//   final List<String> proFeatures;
//   final List<String> otherBenefits;
//   final String price;

//   SubscriptionPlan({
//     required this.title,
//     required this.features,
//     required this.proFeatures,
//     required this.otherBenefits,
//     required this.price,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.purple[100],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Row(
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       color: Colors.purple[900],
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                     ),
//                   ),
//                   Spacer(),
//                   Icon(Icons.star, color: Colors.purple[900]),
//                 ],
//               ),
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Nhiều Truy vấn',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             ...features.map((feature) => ListTile(
//                   leading: Icon(Icons.check, color: Colors.green),
//                   title: Text(feature),
//                 )),
//             SizedBox(height: 16),
//             Text(
//               'Truy cập tất cả các tính năng Pro',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             ...proFeatures.map((feature) => ListTile(
//                   leading: Icon(Icons.check, color: Colors.green),
//                   title: Text(feature),
//                 )),
//             SizedBox(height: 16),
//             Text(
//               'Các Lợi ích Khác',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             ...otherBenefits.map((benefit) => ListTile(
//                   leading: Icon(Icons.check, color: Colors.green),
//                   title: Text(benefit),
//                 )),
//             SizedBox(height: 16),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Handle subscribe button press
//                 },
//                 child: Text(price),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.purple, // Thay thế `primary` bằng `backgroundColor`
//                   foregroundColor: Colors.white,  // Thay thế `onPrimary` bằng `foregroundColor`
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class EmailReplyScreen extends StatelessWidget {

//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController replyController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Email reply'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.menu),
//             onPressed: () {
//               // Handle menu button press
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Received email widget
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Received email',
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 8),
//                     Container(
//                       padding: EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[200],
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: TextField(
                        
//                         style: TextStyle(fontSize: 14),
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     Text(
//                       'ChatBOT reply',
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
//                     ),
//                     SizedBox(height: 8),
//                     Container(
//                       padding: EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[200],
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         'ChatBOT reply\n',
                        
//                         style: TextStyle(fontSize: 14),
                        
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             // Reply options
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     // Handle "Thanks" button press
//                   },
//                   child: Text('Thanks'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Handle "Sorry" button press
//                   },
//                   child: Text('Sorry'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Handle "Yes" button press
//                   },
//                   child: Text('Yes'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Handle "No" button press
//                   },
//                   child: Text('No'),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     // Handle "Follow up" button press
//                   },
//                   child: Text('Follow up'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Handle "Request for more information" button press
//                   },
//                   child: Text('Request for more information'),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
//             // Text field to type reply
//             TextField(
//               controller: replyController,
//               decoration: InputDecoration(
//                 hintText: 'how you want to reply...',
//                 border: OutlineInputBorder(),
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: () {
//                     // Handle send button press
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }