// lib/store/sign_up_store.dart
import 'package:mobx/mobx.dart';

part 'sign_up_store.g.dart';

class SignUpStore = SignUpStoreBase with _$SignUpStore;

abstract class SignUpStoreBase with Store {
  @observable
  bool isShowLoading = false;

  @observable
  bool isShowConfetti = false;

  @observable
  String? email;

  @observable
  String? password;

  @observable
  String? username; // Thêm trường username

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
  void setUsername(String value) { // Thêm action cho username
    username = value;
  }
}