import 'package:flutter/material.dart';

class EmailReplyScreen extends StatelessWidget {
  
  final TextEditingController emailController = TextEditingController();
  final TextEditingController replyController = TextEditingController();

  EmailReplyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email reply'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Handle menu button press
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Received email widget
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Received email',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const TextField(
                        
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'ChatBOT reply',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'ChatBOT reply\n',
                        
                        style: TextStyle(fontSize: 14),
                        
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Reply options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle "Thanks" button press
                  },
                  child: const Text('Thanks'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle "Sorry" button press
                  },
                  child: const Text('Sorry'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle "Yes" button press
                  },
                  child: const Text('Yes'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle "No" button press
                  },
                  child: const Text('No'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle "Follow up" button press
                  },
                  child: const Text('Follow up'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle "Request for more information" button press
                  },
                  child: const Text('Request for more information'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Text field to type reply
            TextField(
              controller: replyController,
              decoration: InputDecoration(
                hintText: 'how you want to reply...',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    // Handle send button press
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}