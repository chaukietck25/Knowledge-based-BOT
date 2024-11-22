import 'package:flutter/material.dart';
import 'package:knowledge_based_bot/Views/bot_management_screen.dart';
import 'package:knowledge_based_bot/Views/bot_screen.dart';
import 'package:knowledge_based_bot/Views/setting/Setting_Screen.dart';
import 'package:knowledge_based_bot/Views/createBotScreen.dart';
import 'package:knowledge_based_bot/Views/prompt_library_screen.dart'
;
import 'package:knowledge_based_bot/store/chat_store.dart';


class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String chatTitle = "Chat with GPT-4o";

  final List<Message> messages = [
    Message(
      text: "gptptptpt",
      sender: "",
      isCurrentUser: false,
      // timestamp: "",
    ),
    Message(
      text: "2@gmail.com",
      sender: "",
      isCurrentUser: false,
    ),
    Message(
      text: "Tefheuffefe",
      sender: "",
      isCurrentUser: false,
    ),
    Message(
      text: "Cwfewefwf",
      sender: "",
      isCurrentUser: false,
    ),
    Message(
      text: "mememememe",
      sender: "",
      isCurrentUser: true,
    ),
    Message(
      text: "",
      sender: "",
      isCurrentUser: false,
    ),
    Message(
      text: "me",
      sender: "",
      isCurrentUser: true,
    ),
    Message(
      text:
          " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam nec purus nec nunc",
      sender: "",
      isCurrentUser: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 10),
            Text(
              "$chatTitle",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_drop_down_circle,
                color: Color.fromARGB(255, 81, 80, 80)),
            onPressed: () {
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(100, 80, 0, 0),
                items: [
                  PopupMenuItem(
                    child: Text("Claude-3"),
                    value: 'Claude-3',
                  ),
                  PopupMenuItem(
                    child: Text("Claude-3.5"),
                    value: 'Claude-3.5',
                  ),
                  PopupMenuItem(
                    child: Text("Gemini-1.5-flash"),
                    value: 'Gemini-1.5-flash',
                  ),
                  PopupMenuItem(
                    child: Text("Gemini-1.5-pro"),
                    value: 'Gemini-1.5-pro',
                  ),
                  PopupMenuItem(
                    child: Text("GPT-4o"),
                    value: 'GPT-4',
                  ),
                  PopupMenuItem(
                    child: Text("GPT-4o-mini"),
                    value: 'GPT-4o',
                  ),
                ],
              ).then((value) {
                if (value == 'GPT-4o-mini') {
                  setState(() {
                    chatTitle = "Chat with GPT-4o-mini";
                  });
                } else if (value == 'GPT-4o') {
                  setState(() {
                    chatTitle = "Chat with GPT-4o";
                  });
                } else if (value == 'Gemini-1.5-pro') {
                  setState(() {
                    chatTitle = "Chat with Gemini-1.5-pro";
                  });
                } else if (value == 'Gemini-1.5-flash') {
                  setState(() {
                    chatTitle = "Chat with Gemini-1.5-flash";
                  });
                } else if (value == 'Claude-3.5') {
                  setState(() {
                    chatTitle = "Chat with Claude-3.5";
                  });
                } else if (value == 'Claude-3') {
                  setState(() {
                    chatTitle = "Chat with Claude-3";
                  });
                } 
              });
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              reverse: true, // To show newest messages at the bottom
              itemBuilder: (context, index) {
                final message = messages[index];
                return ChatBubble(message: message);
              },
            ),
          ),
          ChatInputField(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final String sender;
  final bool isCurrentUser;
  final String? timestamp;

  Message({
    required this.text,
    required this.sender,
    required this.isCurrentUser,
    this.timestamp,
  });
}

class ChatBubble extends StatelessWidget {
  final Message message;

  ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final alignment = message.isCurrentUser
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;

    final bgColor = message.isCurrentUser ? Colors.blue[200] : Colors.grey[200];
    final textColor = message.isCurrentUser ? Colors.black : Colors.black;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        if (message.sender.isNotEmpty)
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
            child: Text(
              message.sender,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            message.text,
            style: TextStyle(color: textColor),
          ),
        ),
        if (message.timestamp != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              message.timestamp!,
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
      ],
    );
  }
}

class ChatInputField extends StatelessWidget {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.camera_alt), onPressed: () {}),
          IconButton(icon: const Icon(Icons.photo), onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.insert_drive_file), onPressed: () {}),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Message",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey[200],
                filled: true,
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
              // icon: const Icon(Icons.more_horiz), onPressed: () {}),
              icon: const Icon(Icons.send),
              onPressed: () {
                // sendMessage(_controller);
              }),
        ],
      ),
    );
  }
}
