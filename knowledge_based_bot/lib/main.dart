import 'package:flutter/material.dart';
import 'package:knowledge_based_bot/Service/ad_mob_service.dart';

import 'package:knowledge_based_bot/views/auth/onboarding_screen.dart';

import 'package:knowledge_based_bot/views/knowledge_management/kb_dashboard_screen.dart';


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
      //home: const OnboardingScreen(),
      // home: EmailScreen(),
       home:  KbDashboardScreen(),
    );
  }
}