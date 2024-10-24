import 'package:flutter/material.dart';


class ChatSettingsScreen extends StatefulWidget {
  const ChatSettingsScreen({super.key});

  @override
  _ChatSettingsScreenState createState() => _ChatSettingsScreenState();
}

class _ChatSettingsScreenState extends State<ChatSettingsScreen> {
  bool hapticFeedback = true;
  bool sendByEnter = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        // backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Chat settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: [
            SwitchListTile(
              // title: const Text('Haptic feedback'),
              title: const Text('Phản hồi xúc giác'),
              value: hapticFeedback,
              onChanged: (bool value) {
                setState(() {
                  hapticFeedback = value;
                });
              },
              activeColor: const Color.fromARGB(204, 114, 5, 168),
            ),
            
            // Send by Enter Toggle
            SwitchListTile(
              // title: const Text('Send by Enter'),
              title: const Text('Gửi bằng phím Enter'),
              subtitle: const Text(
                // 'When enabled, the enter button on keyboard will be replaced by send',
                'Khi được kích hoạt, nút Enter trên bàn phím sẽ được thay thế bằng nút gửi',
                style: TextStyle(color: Colors.black54),
              ),
              value: sendByEnter,
              onChanged: (bool value) {
                setState(() {
                  sendByEnter = value;
                });
              },
              activeColor: const Color.fromARGB(204, 114, 5, 168),
            ),
            
            // Respond Language Option
            ListTile(
              // title: const Text('Respond language'),
              title: const Text('Ngôn ngữ phản hồi'),
              trailing: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Text('Auto', style: TextStyle(color: Colors.black54, fontSize: 14),),
                  Text('Tự động', style: TextStyle(color: Colors.black54, fontSize: 14),),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward_ios, color: Colors.black54),
                ],
              ),
              onTap: () {
                // Handle option tap
              },
            ),
            
            // Chat Font Size Option
            ListTile(
              // title: const Text('Chat font size'),
              title: const Text('Cỡ chữ trò chuyện'),
              trailing: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Text('Normal', style: TextStyle(color: Colors.black54, fontSize: 14),),
                  Text('Bình thường', style: TextStyle(color: Colors.black54, fontSize: 14),),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward_ios, color: Colors.black54),
                ],
              ),
              onTap: () {
                // Handle option tap
              },
            ),
            
            // Auto Scroll Option
            ListTile(
              // title: const Text('Auto Scroll'),
              title: const Text('Tự động cuộn'),
              trailing: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Text('Turn a new page', style: TextStyle(color: Colors.black54, fontSize: 14),),
                  Text('Lật sang trang mới', style: TextStyle(color: Colors.black54, fontSize: 14),),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward_ios, color: Colors.black54),
                ],
              ),
              onTap: () {
                // Handle option tap
              },
            ),
            
            // Voice Option
            ListTile(
              // title: const Text('Voice'),
              title: const Text('Giọng nói'),
              trailing: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('nova', style: TextStyle(color: Colors.black54, fontSize: 14),),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward_ios, color: Colors.black54),
                ],
              ),
              onTap: () {
                // Handle option tap
              },
            ),
          ],
        ),
      ),
    );
  }
}
