// lib/provider_state.dart

class ProviderState {
  static String? accessToken;
  static String? refreshToken;

  // External tokens
  static String? externalAccessToken;
  static String? externalRefreshToken;

  // Message for prompt
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

  // External Token Getters and Setters
  static String? getExternalAccessToken() {
    return externalAccessToken;
  }

  void setExternalAccessToken(String? value) {
    externalAccessToken = value;
  }

  static String? getExternalRefreshToken() {
    return externalRefreshToken;
  }

  void setExternalRefreshToken(String? value) {
    externalRefreshToken = value;
  }
}