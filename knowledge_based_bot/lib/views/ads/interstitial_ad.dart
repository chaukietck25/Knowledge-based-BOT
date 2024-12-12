import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:knowledge_based_bot/Service/ad_mob_service.dart';

class InterstitialAds {
  static InterstitialAd? interstitialAd;

  static void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdMobService.interstitialAdUnitId!,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          interstitialAd = ad;
          debugPrint('Interstitial Ad loaded.');
          ad.show();
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              ad.dispose();
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => nextPage),
          //     );
            },
            onAdFailedToShowFullScreenContent:
                (InterstitialAd ad, AdError error) {
              ad.dispose();
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => nextPage),
          //     );
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          interstitialAd = null;
          debugPrint('Interstitial Ad failed to load: $error');

          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => nextPage),
          // );
        },
      ),
    );
  }
}

void showInterstitialAd(BuildContext context, Widget nextPage) {
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
  }
}
