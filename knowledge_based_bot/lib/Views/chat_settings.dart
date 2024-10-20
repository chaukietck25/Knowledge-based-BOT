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
          onPressed: () {},
        ),
        title: const Text('Chat settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: [
            SwitchListTile(
              title: const Text('Haptic feedback'),
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
              title: const Text('Send by Enter'),
              subtitle: const Text(
                'When enabled, the enter button on keyboard will be replaced by send',
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
              title: const Text('Respond language'),
              trailing: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Auto', style: TextStyle(color: Colors.black54, fontSize: 14),),
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
              title: const Text('Chat font size'),
              trailing: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Normal', style: TextStyle(color: Colors.black54, fontSize: 14),),
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
              title: const Text('Auto Scroll'),
              trailing: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Turn a new page', style: TextStyle(color: Colors.black54, fontSize: 14),),
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
              title: const Text('Voice'),
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
