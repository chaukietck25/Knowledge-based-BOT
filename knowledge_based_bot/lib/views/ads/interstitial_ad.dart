import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:knowledge_based_bot/Service/ad_mob_service.dart';

class InterstitialAds {
  static InterstitialAd? interstitialAd;

  static void loadInterstitialAd() {
    if (kIsWeb) {
      // Ads are not supported on web
      return;
    }

    String? adUnitId = AdMobService.interstitialAdUnitId;
    if (adUnitId == null) {
      debugPrint('Interstitial Ad Unit ID is null');
      return;
    }

    InterstitialAd.load(
      adUnitId: adUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          interstitialAd = ad;
          debugPrint('Interstitial Ad loaded.');
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              ad.dispose();
              loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
              ad.dispose();
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          interstitialAd = null;
          debugPrint('Interstitial Ad failed to load: $error');
        },
      ),
    );
  }
}

void showInterstitialAd(BuildContext context, Widget nextPage) {
  if (kIsWeb) {
    // Directly navigate on web as ads are not supported
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => nextPage),
    );
    return;
  }

  if (InterstitialAds.interstitialAd != null) {
    InterstitialAds.interstitialAd!.fullScreenContentCallback =
        FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        InterstitialAds.loadInterstitialAd();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        InterstitialAds.loadInterstitialAd();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      },
    );

    InterstitialAds.interstitialAd!.show();
    InterstitialAds.interstitialAd = null;
  } else {
    // If no ad is loaded, navigate directly
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => nextPage),
    );
  }
}