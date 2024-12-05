import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:knowledge_based_bot/Service/ad_mob_service.dart';

void loadInterstitialAd(BuildContext context, Widget nextPage) {
  InterstitialAd.load(
    adUnitId: AdMobService.interstitialAdUnitId!,
    request: AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (InterstitialAd ad) {
        ad.show();
        ad.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (InterstitialAd ad) {
            ad.dispose();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => nextPage),
            );
          },
          onAdFailedToShowFullScreenContent:
              (InterstitialAd ad, AdError error) {
            ad.dispose();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => nextPage),
            );
          },
        );
      },
      onAdFailedToLoad: (LoadAdError error) {
        print('Interstitial Ad failed to load: $error');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      },
    ),
  );
}


// loadInterstitialAd(); // Call this function to load the interstitial ad