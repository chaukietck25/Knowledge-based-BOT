// lib/store/sign_in_store.dart
import 'package:mobx/mobx.dart';

part 'sign_in_store.g.dart';

class SignInStore = SignInStoreBase with _$SignInStore;

abstract class SignInStoreBase with Store {
  @observable
  bool isShowLoading = false;

  @observable 
  bool isShowConfetti = false;

  @observable
  String? email;

  @observable
  String? password;

  @observable
  String? accessToken;

  @observable
  String? refreshToken;

  @action
  void setShowLoading(bool value) {
    isShowLoading = value; 
  }

  @action
  void setShowConfetti(bool value) {
    isShowConfetti = value;
  }

  @action
  void setEmail(String value) {
    email = value;
  }

  @action
  void setPassword(String value) {
    password = value;
  }

  @action
  void setAccessToken(String value) {
    accessToken = value;
  }

  @action
  void setRefreshToken(String value) {
    refreshToken = value;
  }
}