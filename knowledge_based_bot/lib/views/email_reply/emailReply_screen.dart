import 'package:flutter/material.dart';

class EmailReplyScreen extends StatelessWidget {
  
  final TextEditingController emailController = TextEditingController();
  final TextEditingController replyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Email reply'),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
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
                    Text(
                      'Received email',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'ChatBOT reply',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
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
                  child: Text('Thanks'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle "Sorry" button press
                  },
                  child: Text('Sorry'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle "Yes" button press
                  },
                  child: Text('Yes'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle "No" button press
                  },
                  child: Text('No'),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle "Follow up" button press
                  },
                  child: Text('Follow up'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle "Request for more information" button press
                  },
                  child: Text('Request for more information'),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Text field to type reply
            TextField(
              controller: replyController,
              decoration: InputDecoration(
                hintText: 'how you want to reply...',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
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