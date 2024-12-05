import 'dart:io';

class AdMobService {
  static String? get appId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1897735039534622~4204289763';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1897735039534622~7257568758';
    }
    return null;
  }

  static String? get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1897735039534622/4800423234';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1897735039534622/7569394093';
    }
    return null;
  }

  static String? get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1897735039534622/5932878795';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1897735039534622/5047835240';
    }
    return null;
  }

}