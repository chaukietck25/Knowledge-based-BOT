import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:knowledge_based_bot/views/ads/banner_ad_widget.dart';
import 'package:knowledge_based_bot/views/ads/interstitial_ad.dart';
import 'package:knowledge_based_bot/views/bot_management/bot_management_screen.dart';
import 'package:knowledge_based_bot/views/chat/chat_screen.dart';
import 'package:knowledge_based_bot/views/conversation/conversation_detail.dart';
import 'package:knowledge_based_bot/views/setting/Setting_Screen.dart';
import 'package:knowledge_based_bot/views/bot_management/add_bot_screen.dart';
import 'package:knowledge_based_bot/views/prompts library/prompts_library_screens.dart';
import 'package:knowledge_based_bot/views/conversation/conversation_history.dart';
import 'package:knowledge_based_bot/views/email_reply/email_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../store/chat_store.dart';
import 'package:intl/intl.dart';
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

    // if (!kIsWeb) {
    //   InterstitialAds.loadInterstitialAd();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Xoá nút back bằng cách đặt automaticallyImplyLeading = false
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Home', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        //backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.add, color: Color.fromARGB(255, 81, 80, 80)),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => ChatScreen()),
          //     );
          //   },
          // ),
          // IconButton(
          //   icon: const Icon(Icons.history,
          //       color: Color.fromARGB(255, 81, 80, 80)),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => const ConversationHistory()),
          //     );
          //   },
          // ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
                  icon: const Icon(Icons.account_circle,
                      color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingScreen()),
                    );
                  },
                ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
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
                      padding: EdgeInsets.only(left: 0),
                      child: Text(
                        'How can I help you today?',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (!kIsWeb) BannerAdWidget() else const SizedBox(height: 10),
                    const SizedBox(height: 10),
                    const Text('Recent Conversations',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: chatStore.conversationItems.isEmpty
                            ? const Center(
                                child: Text(
                                  'No Conversations Found',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            : ListView.builder(
                                itemCount: chatStore.conversationItems.length,
                                itemBuilder: (context, index) {
                                  final item = chatStore.conversationItems[index];
                                  return SizedBox(
                                    height: 70,
                                    child: _buildOptionButton(context, item.title,
                                        item.createdAt, item.id),
                                  );
                                },
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatScreen()));
                          },
                          child: Column(
                            children: const [
                              Icon(Icons.add),
                              Text('Tap to new chat'),
                            ],
                          ),
                        ),
                        // InkWell(
                        //   onTap: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => EmailScreen()));
                        //   },
                        //   child: Column(
                        //     children: const [
                        //       Icon(Icons.email),
                        //       Text('Email'),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        bottom: false,
        child: BottomAppBar(
          color: Colors.blue[50],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // IconButton(
              //   icon: const Icon(Icons.circle, color: Colors.black, size: 30),
              //   onPressed: () {},
              // ),
              Column(
                children: [
                  IconButton(
                    // icon: const Icon(Icons.add_box_outlined,
                    //     color: Colors.black, size: 30),
                    icon: const FaIcon(
                      FontAwesomeIcons.robot, // Biểu tượng robot từ Font Awesome
                      color: Colors.black,
                      size: 25,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddBotScreen()),
                      );
                    },
                  ),
                  //Text('Create Bot', style: TextStyle(color: Colors.black, fontSize: 12)),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    // icon: const FaIcon(
                    //   FontAwesomeIcons.robot, // Biểu tượng robot từ Font Awesome
                    //   color: Colors.black,
                    //   size: 25,
                    // ),
                    icon: const Icon(Icons.bookmark, color: Colors.black, size: 30),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MonicaSearch()),
                      );
                    },
                  ),
                  //Text('Knowledge Based', style: TextStyle(color: Colors.black, fontSize: 12)),
                ],
              ),
              // swap email screen with bookmark screen
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.email, color: Colors.black, size: 30),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EmailScreen()),
                      );
                    },
                  ),
                  //Text('Email', style: TextStyle(color: Colors.black, fontSize: 12)),
                ],
              ),
              

              // IconButton(
              //   icon: const Icon(Icons.bookmark, color: Colors.black, size: 30),
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => Scaffold(

              //             appBar: AppBar(leading: IconButton(
              //               onPressed: (){
              //                 Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                       builder: (context) => const HomePage()),
              //                 );
              //               }, 
              //               icon: Icon(Icons.arrow_back)),),
              //             body: PromptLibraryModal(),
              //           )

              //           ),
              //     );
              //   },
              // ),
              
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
              const Spacer(),
              Row(
                children: const [
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

  Widget _buildOptionButton(
      BuildContext context, String title, int createdAt, String id) {
    // Convert epoch seconds to DateTime
    DateTime date = DateTime.fromMillisecondsSinceEpoch(createdAt * 1000);
    // Format DateTime to 'dd-MM-yyyy HH:mm'
    String formattedDate = DateFormat('dd-MM-yyyy HH:mm').format(date);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
          children: [
            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              formattedDate,
              style: const TextStyle(
                  color: Color.fromARGB(255, 162, 160, 160), fontSize: 12),
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
