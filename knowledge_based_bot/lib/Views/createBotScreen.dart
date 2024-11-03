import 'package:flutter/material.dart';

class CreateBotScreen extends StatefulWidget {
  const CreateBotScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateBotScreenState createState() => _CreateBotScreenState();
}

class _CreateBotScreenState extends State<CreateBotScreen> {
  String _selectedPermission = 'Public';

  void _showModelSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: const Color(0xFF1D1D1D), // Màu nền của modal bottom sheet
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.model_training, color: Colors.white),
                title: const Text('GPT-4o mini', style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Hành động khi chọn GPT-4o mini
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.model_training, color: Colors.white),
                title: const Text('Claude 3.5 Sonnet', style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Hành động khi chọn Claude 3.5 Sonnet
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.model_training, color: Colors.white),
                title: const Text('GPT-4o', style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Hành động khi chọn GPT-4o
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPermissionSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: const Color(0xFF1D1D1D), // Màu nền của modal bottom sheet
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.lock, color: Colors.white),
                title: const Text('Chỉ mình tôi', style: TextStyle(color: Colors.white)),
                onTap: () {
                  setState(() {
                    _selectedPermission = 'Chỉ mình tôi';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.link, color: Colors.white),
                title: const Text('Bất kỳ ai có liên kết', style: TextStyle(color: Colors.white)),
                onTap: () {
                  setState(() {
                    _selectedPermission = 'Bất kỳ ai có liên kết';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.public, color: Colors.white),
                title: const Text('Công khai • Mọi người đều có thể thấy', style: TextStyle(color: Colors.white)),
                onTap: () {
                  setState(() {
                    _selectedPermission = 'Công khai • Mọi người đều có thể thấy';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo bot'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                hintText: 'Tên bot',
                labelText: 'Tên',
                filled: true,
                fillColor: Color.fromARGB(255, 250, 248, 248),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Mô tả Cài Đặt',
                labelText: 'Mô tả Cài Đặt',
                filled: true,
                fillColor: Color.fromARGB(255, 250, 248, 248),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showModelSelection(context);
              },
              child: const Text('Mô Hình'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showPermissionSelection(context);
              },
              child: Text(_selectedPermission),
            ),
          ],
        ),
      ),
    );
  }
}