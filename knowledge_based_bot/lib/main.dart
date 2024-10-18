import 'package:flutter/material.dart';
import 'package:knowledge_based_bot/chat_settings.dart';
import 'package:knowledge_based_bot/home_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ChatSettingsScreen(),
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            InkWell(

              
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    userName,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    email,
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
              onTap: () {
                
              },
            ),
            SizedBox(height: 16),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                leading: Icon(Icons.star),
                title: Text(typeOfAccount),
                subtitle: Text(query),
                trailing: ElevatedButton(
                  onPressed: () {
                    // Handle upgrade button press
                  },
                  child: Text('Nâng cấp'),
                ),
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text('Cài đặt trò chuyện'),
              onTap: () {
                // Handle chat settings
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.color_lens),
              title: Text('Chế độ màu sắc'),
              trailing: Text(selectedTheme),
              onTap: () {
                // Handle color mode settings
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.language),
              title: Text('Ngôn ngữ'),
              trailing: Text(selectedLanguage),
              onTap: () {
                // Handle language settings
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.memory),
              title: Text('Bộ nhớ'),
              trailing: Icon(Icons.circle, color: Colors.red, size: 10),
              onTap: () {
                // Handle memory settings
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Giới thiệu'),
              onTap: () {
                // Handle about
              },
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
