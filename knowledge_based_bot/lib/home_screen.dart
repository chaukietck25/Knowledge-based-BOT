import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.account_circle, color: Colors.grey),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                'How can I help you today?',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 14),
            SingleChildScrollView(
              // scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCard(context, 'Back to School Event',
                      'Vote to get free GPT-4o', Icons.event),
                  const SizedBox(width: 10),
                  _buildCard(context, 'Monica Desktop',
                      'Your AI assistant on desktop', Icons.desktop_windows),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildOptionButton(context, 'Explain AI to a 5-year-old kid'),
            _buildOptionButton(
                context, 'Design a database schema for a pet hospital'),
            _buildOptionButton(
                context, 'Write a text inviting my neighbors to a barbecue'),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    icon: const Icon(Icons.camera_alt), onPressed: () {}),
                IconButton(icon: const Icon(Icons.image), onPressed: () {}),
                IconButton(
                    icon: const Icon(Icons.insert_drive_file),
                    onPressed: () {}),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Message',
                        suffixIcon: const Icon(Icons.mic),
                        // hintStyle: TextStyle(color: Colors.white54),
                        // filled: true,
                        // fillColor: Colors.grey[800],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          // borderSide: BorderSide.strokeAlignCenter,
                        ),
                      ),
                      // style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                IconButton(
                    icon: const Icon(Icons.more_horiz), onPressed: () {}),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        bottom: false,
        child: BottomAppBar(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.circle, color: Colors.black, size: 30),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.memory, color: Colors.black, size: 30),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.add_box_outlined,
                        color: Colors.black, size: 30),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.loop, color: Colors.black, size: 30),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.bookmark, color: Colors.black, size: 30),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
      BuildContext context, String title, String subtitle, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 3,
        child: Container(
          width: 150,
          height: 130,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 129, 189, 238),
                Color.fromARGB(255, 223, 230, 238)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(subtitle,
                  style:
                      const TextStyle(color: Color.fromARGB(255, 94, 93, 93))),
              Spacer(),
              Row(
                children: [
                  Spacer(),
                  Icon(Icons.chat, size: 30),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          backgroundColor: Colors.grey[200],
          foregroundColor: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 10),
            const Icon(Icons.arrow_forward_ios,
                size: 15, color: Color.fromARGB(255, 162, 160, 160)),
          ],
        ),
      ),
    );
  }
}
