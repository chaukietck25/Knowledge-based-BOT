// lib/Views/home_screen.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:knowledge_based_bot/Service/ad_mob_service.dart';
import 'package:knowledge_based_bot/views/ads/banner_ad_widget.dart';
import 'package:knowledge_based_bot/views/ads/interstitial_ad.dart';
import 'package:knowledge_based_bot/views/bot_management/bot_management_screen.dart';
import 'package:knowledge_based_bot/Views/bot_screen.dart';
import 'package:knowledge_based_bot/Views/chat_screen.dart';
import 'package:knowledge_based_bot/Views/conversation_detail.dart';
import 'package:knowledge_based_bot/Views/prompts%20library/prompts_library_screens.dart';
import 'package:knowledge_based_bot/Views/setting/Setting_Screen.dart';
import 'package:knowledge_based_bot/Views/createBotScreen.dart';
import 'package:knowledge_based_bot/Views/prompt_library_screen.dart';
import 'package:knowledge_based_bot/views/conversation_history.dart';
import 'package:knowledge_based_bot/views/email_reply/emailReply_screen.dart';
import 'package:knowledge_based_bot/views/email_reply/email_screen.dart';
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

  InterstitialAd? interstitialAd;

  @override
  void initState() {
    super.initState();
    chatStore.fetchConversations(refeshToken); // Replace with your actual token

    InterstitialAds.loadInterstitialAd();
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
            icon: const Icon(Icons.history,
                color: Color.fromARGB(255, 81, 80, 80)),
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
                  const SizedBox(height: 20),

                  !kIsWeb ? BannerAdWidget() : const SizedBox(height: 10),

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
                        return _buildOptionButton(
                            context, item.title, item.createdAt, item.id);
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatScreen()));

                          // showInterstitialAd(context, ChatScreen());
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EmailScreen()));

                          // showInterstitialAd(context, EmailScreen());
                        },
                        child: Column(
                          children: [
                            Icon(Icons.email),
                            const Text('Email'),
                          ],
                        ),
                      ),

                      // ElevatedButton(
                      //   onPressed: TESTshowInterstitialAd,
                      //   child: const Text('ads'),
                      // ),

                      Spacer(),
                      // InkWell(
                      //   onTap: () {
                      //     showModalBottomSheet(
                      //       context: context,
                      //       builder: (context) => PromptLibraryModal(),
                      //       isScrollControlled: true,
                      //     );
                      //   },
                      //   child: Column(
                      //     children: [
                      //       Icon(Icons.more_horiz),
                      //       const Text('Prompt Library'),
                      //     ],
                      //   ),
                      // ),
                      // Spacer(),
                    ],
                  ),

                  // BannerAdWidget(),
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
                icon: const Icon(Icons.search, color: Colors.black, size: 30),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MonicaSearch()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.bookmark, color: Colors.black, size: 30),
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
                  style:
                      const TextStyle(color: Color.fromARGB(255, 94, 93, 93))),
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

  Widget _buildOptionButton(
      BuildContext context, String title, int createdAt, String id) {
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

  // void loadInterstitialAd() {
  //   InterstitialAd.load(
  //     adUnitId: 'ca-app-pub-3940256099942544/1033173712',
  //     // adUnitId: AdMobService.interstitialAdUnitId!,

  //     request: AdRequest(),
  //     adLoadCallback: InterstitialAdLoadCallback(
  //       onAdLoaded: (InterstitialAd ad) {
  //         interstitialAd = ad;
  //         debugPrint('Interstitial Ad loaded.');
  //         ad.show();
  //         ad.fullScreenContentCallback = FullScreenContentCallback(
  //           onAdDismissedFullScreenContent: (InterstitialAd ad) {
  //             ad.dispose();
  //             // Navigator.push(
  //             //   context,
  //             //   MaterialPageRoute(builder: (context) => nextPage),
  //             // );
  //           },
  //           onAdFailedToShowFullScreenContent:
  //               (InterstitialAd ad, AdError error) {
  //             ad.dispose();
  //             // Navigator.push(
  //             //   context,
  //             //   MaterialPageRoute(builder: (context) => nextPage),
  //             // );
  //           },
  //         );
  //       },
  //       onAdFailedToLoad: (LoadAdError error) {
  //         interstitialAd = null;
  //         debugPrint('Interstitial Ad failed to load: $error');

  //         // Navigator.push(
  //         //   context,
  //         //   MaterialPageRoute(builder: (context) => nextPage),
  //         // );
  //       },
  //     ),
  //   );
  // }

  // void TESTshowInterstitialAd() {
  //   if (interstitialAd != null) {
  //     interstitialAd!.fullScreenContentCallback =
  //         FullScreenContentCallback(
  //       onAdDismissedFullScreenContent: (InterstitialAd ad) {
  //         ad.dispose();
  //         loadInterstitialAd();
  //       },
  //       onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
  //         ad.dispose();
  //         loadInterstitialAd();
  //       },
  //     );

  //     interstitialAd!.show();
  //     interstitialAd = null;
  //   }
  // }

}