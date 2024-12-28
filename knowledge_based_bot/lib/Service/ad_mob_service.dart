import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  
  static String? get appId {
    if (kIsWeb) {
      return null;
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'ca-app-pub-1897735039534622~4204289763';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'ca-app-pub-1897735039534622~7257568758';
    }
    return null;
  }

  static String? get bannerAdUnitId {
    if (kIsWeb) {
      return null;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    }

    // if (defaultTargetPlatform == TargetPlatform.android) {
    //   return 'ca-app-pub-1897735039534622/4800423234';
    // } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    //   return 'ca-app-pub-1897735039534622/7569394093';
    // }

    return null;
  }

  static String? get interstitialAdUnitId {
    if (kIsWeb) {
      return null;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'ca-app-pub-3940256099942544/1033173712';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    }

    // if (defaultTargetPlatform == TargetPlatform.android) {
    //   return 'ca-app-pub-1897735039534622/5932878795';
    // } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    //   return 'ca-app-pub-1897735039534622/5047835240';
    // }

    return null;
  }

  static void initializeAds() {
    if (!kIsWeb) {
      MobileAds.instance.initialize();
      
      RequestConfiguration requestConfiguration = RequestConfiguration(
        testDeviceIds: ['b484bd4c-1805-41fa-9c0b-e64f6c9574f2'],
      );
      MobileAds.instance.updateRequestConfiguration(requestConfiguration);
    }
  }
}