//lib/provider_state.dart

class ProviderState {
  static String? accessToken;
  static String? refreshToken;

  // msg for prompt
  static String? msg;
  static String? getMsg() {
    return msg;
  }

  void setMsg(String? value) {
    msg = value;
  }
  

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