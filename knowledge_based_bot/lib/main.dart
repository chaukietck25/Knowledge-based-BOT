import 'package:flutter/material.dart';
import 'package:knowledge_based_bot/Views/update_account/subcription_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:knowledge_based_bot/views/auth/onboarding_screen.dart';
import 'package:knowledge_based_bot/views/email_reply/email_screen.dart';
import 'package:knowledge_based_bot/views/setting/Setting_Screen.dart';
import 'package:knowledge_based_bot/views/contact/contact_screen.dart';
import 'package:knowledge_based_bot/views/email_reply/emailReply_screen.dart';

import 'package:knowledge_based_bot/Views/bot_screen.dart';
import 'package:knowledge_based_bot/Views/chat_settings.dart';
import 'package:knowledge_based_bot/Views/home_screen.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  
  RequestConfiguration requestConfiguration = RequestConfiguration(
    testDeviceIds: ['b484bd4c-1805-41fa-9c0b-e64f6c9574f2'],
  );
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const OnboardingScreen(),
      home: EmailScreen(),

    );
  }
}

