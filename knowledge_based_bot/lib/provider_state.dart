//lib/provider_state.dart

class ProviderState {
  static String? accessToken;

  static String? getAccessToken() {
    return accessToken;
  }
  void setAccessToken(String? value) {
    accessToken = value;
  }
}