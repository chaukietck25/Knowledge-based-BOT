// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:knowledge_based_bot/Service/ad_mob_service.dart';
import 'package:knowledge_based_bot/Service/analytics_service.dart';
import 'package:knowledge_based_bot/firebase_options.dart';
import 'package:knowledge_based_bot/views/auth/onboarding_screen.dart';
import 'package:knowledge_based_bot/views/email_reply/email_screen.dart';

import 'package:knowledge_based_bot/views/knowledge_management/kb_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AdMobService.initializeAds();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
    return true;
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      navigatorObservers: <NavigatorObserver>[
        AnalyticsService().getAnalyticsObserver()
      ],
      home: const OnboardingScreen(),
      // home: EmailScreen(),

      // home: KbDashboardScreen(
      //   assistantId: 'your_assistant_id',
      //   openAiThreadId: 'your_openai_thread_id',
      // ),
    );
  }
}
