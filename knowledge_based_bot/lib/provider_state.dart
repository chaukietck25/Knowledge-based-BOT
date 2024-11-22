//lib/provider_state.dart

class ProviderState {
  static String? accessToken;
  static String? refreshToken;

  static String? getRefreshToken() {
    return refreshToken;
  }
  void setRefreshToken(String? value) {
    refreshToken = value;
  }

  static String? getAccessToken() {
    return accessToken;
  }
  void setAccessToken(String? value) {
    accessToken = value;
  }
}