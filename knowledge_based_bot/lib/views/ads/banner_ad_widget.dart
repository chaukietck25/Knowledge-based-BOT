import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:knowledge_based_bot/Service/ad_mob_service.dart';

class BannerAdWidget extends StatefulWidget {
  @override
  _BannerAdWidgetState createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;


  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: AdMobService.bannerAdUnitId!,
      // size: AdSize.banner,
      size: AdSize.fullBanner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isAdLoaded = true;
          });
          debugPrint("BannerAd loaded: ${ad.adUnitId}");
        },
        onAdFailedToLoad: (ad, error) {
          _isAdLoaded = false;
          ad.dispose();
          debugPrint('BannerAd failed to load: $error');
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    return _bannerAd != null
        ? Container(
            alignment: Alignment.center,
            width: _bannerAd!.size.width.toDouble(),
            // height: _bannerAd!.size.height.toDouble(),
            height: 52,
            child: AdWidget(ad: _bannerAd!),
          )
        : SizedBox();
  }
}