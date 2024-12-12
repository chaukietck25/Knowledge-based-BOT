import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:knowledge_based_bot/Service/ad_mob_service.dart';

import 'package:knowledge_based_bot/views/auth/onboarding_screen.dart';
import 'package:knowledge_based_bot/views/email_reply/email_screen.dart';
import 'package:knowledge_based_bot/views/setting/setting_screen.dart';
import 'package:knowledge_based_bot/views/contact/contact_screen.dart';
import 'package:knowledge_based_bot/views/bot_screen.dart';
import 'package:knowledge_based_bot/views/chat_settings.dart';
import 'package:knowledge_based_bot/views/home_screen.dart';
import 'package:knowledge_based_bot/views/ads/interstitial_ad.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AdMobService.initializeAds();
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
        useMaterial3: true,
      ),
      home: const OnboardingScreen(),
      // home: EmailScreen(),
    );
  }
}