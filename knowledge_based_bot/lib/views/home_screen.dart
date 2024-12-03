// lib/Views/home_screen.dart
import 'package:flutter/material.dart';
import 'package:knowledge_based_bot/views/bot_management/bot_management_screen.dart';
import 'package:knowledge_based_bot/Views/bot_screen.dart';
import 'package:knowledge_based_bot/Views/chat_screen.dart';
import 'package:knowledge_based_bot/Views/conversation_detail.dart';
import 'package:knowledge_based_bot/Views/prompts%20library/prompts_library_screens.dart';
import 'package:knowledge_based_bot/Views/setting/Setting_Screen.dart';
import 'package:knowledge_based_bot/Views/createBotScreen.dart';
import 'package:knowledge_based_bot/Views/prompt_library_screen.dart';
import 'package:knowledge_based_bot/views/conversation_history.dart';
import '../store/chat_store.dart';
import 'package:intl/intl.dart'; // Import intl for date formatting
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:knowledge_based_bot/provider_state.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatStore chatStore = ChatStore();
  String? refeshToken = ProviderState.getRefreshToken();

  @override
  void initState() {
    super.initState();
    chatStore.fetchConversations(refeshToken); // Replace with your actual token
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color.fromARGB(255, 81, 80, 80)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.history, color: Color.fromARGB(255, 81, 80, 80)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConversationHistory(),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.account_circle, color: Colors.grey),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingScreen()));
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Observer(
          builder: (_) {
            if (chatStore.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Column(
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
                  Expanded(
                    child: SingleChildScrollView(
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
                  ),
                  const SizedBox(height: 20),
                  const Text('Recent Conversations',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: chatStore.conversationItems.length,
                      itemBuilder: (context, index) {
                        final item = chatStore.conversationItems[index];
                        return _buildOptionButton(context, item.title, item.createdAt, item.id);
                      },
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ChatScreen()));
                        },
                        child: Column(
                          children: [
                            Icon(Icons.add),
                            const Text('Tap to chat'),
                          ],
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => PromptLibraryModal(),
                            isScrollControlled: true,
                          );
                        },
                        child: Column(
                          children: [
                            Icon(Icons.more_horiz),
                            const Text('Prompt Library'),
                          ],
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        bottom: false,
        child: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.circle, color: Colors.black, size: 30),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.memory, color: Colors.black, size: 30),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BotScreen()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.add_box_outlined,
                    color: Colors.black, size: 30),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateBotScreen()));
                },
              ),
              IconButton(
                icon:
                    const Icon(Icons.search, color: Colors.black, size: 30),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MonicaSearch()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.bookmark,
                    color: Colors.black, size: 30),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PromptLibraryScreen()));
                },
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
                  style: const TextStyle(color: Color.fromARGB(255, 94, 93, 93))),
              const Spacer(),
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

  Widget _buildOptionButton(BuildContext context, String title, int createdAt, String id) {
    // Convert epoch seconds to DateTime
    DateTime date = DateTime.fromMillisecondsSinceEpoch(createdAt * 1000);
    // Format DateTime to 'dd-MM-yyyy HH:mm'
    String formattedDate = DateFormat('dd-MM-yyyy HH:mm').format(date);

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
        onPressed: () {
          // Navigate to ConversationDetail with the specific conversationId
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConversationDetail(conversationId: id),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              formattedDate,
              style: const TextStyle(color: Color.fromARGB(255, 162, 160, 160)),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_forward_ios,
                size: 15, color: Color.fromARGB(255, 162, 160, 160)),
          ],
        ),
      ),
    );
  }
}

// <<<<<<< phuong
// void showPromptOverlay(BuildContext context) {
//   final PromptStore promptStore = PromptStore();
//   final prompts = promptStore.prompts;
//   OverlayState overlayState = Overlay.of(context);
//   late OverlayEntry overlayEntry;
//   overlayEntry = OverlayEntry(
//     builder: (context) => Positioned(
//       bottom: 150,
//       left: MediaQuery.of(context).size.width * 0.1,
//       right: MediaQuery.of(context).size.width * 0.6,
//       child: Material(
//         elevation: 4.0,
//         borderRadius: BorderRadius.circular(10),
//         child: Container(
//             padding: const EdgeInsets.all(8.0),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Container(
//                 height: 60,
//                 width: 10,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const Text('Open Prompt Library'),
//                     const SizedBox(height: 4),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         ElevatedButton(
//                             onPressed: () {
//                               showModalBottomSheet(
//                                 context: context,
//                                 builder: (context) => const PromptLibraryModal(),
//                                 isScrollControlled: true,
//                               );

//                               overlayEntry.remove();
//                             },
//                             child: const Text('Open')),
//                         ElevatedButton(
//                           onPressed: () {
//                             overlayEntry.remove();
//                           },
//                           child: const Text('Close'),
//                         ),
//                       ],
//                     )
//                   ],
//                 ))),
//       ),
//     ),
//   );

//   overlayState.insert(overlayEntry);
// }
// =======

// >>>>>>> basic-feature
