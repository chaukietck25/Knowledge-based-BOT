// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SignUpStore on SignUpStoreBase, Store {
  late final _$isShowLoadingAtom =
      Atom(name: 'SignUpStoreBase.isShowLoading', context: context);

  @override
  bool get isShowLoading {
    _$isShowLoadingAtom.reportRead();
    return super.isShowLoading;
  }

  @override
  set isShowLoading(bool value) {
    _$isShowLoadingAtom.reportWrite(value, super.isShowLoading, () {
      super.isShowLoading = value;
    });
  }

  late final _$isShowSuccessAtom =
      Atom(name: 'SignUpStoreBase.isShowSuccess', context: context);

  @override
  bool get isShowSuccess {
    _$isShowSuccessAtom.reportRead();
    return super.isShowSuccess;
  }

  @override
  set isShowSuccess(bool value) {
    _$isShowSuccessAtom.reportWrite(value, super.isShowSuccess, () {
      super.isShowSuccess = value;
    });
  }

  late final _$isShowErrorAtom =
      Atom(name: 'SignUpStoreBase.isShowError', context: context);

  @override
  bool get isShowError {
    _$isShowErrorAtom.reportRead();
    return super.isShowError;
  }

  @override
  set isShowError(bool value) {
    _$isShowErrorAtom.reportWrite(value, super.isShowError, () {
      super.isShowError = value;
    });
  }

  late final _$isShowConfettiAtom =
      Atom(name: 'SignUpStoreBase.isShowConfetti', context: context);

  @override
  bool get isShowConfetti {
    _$isShowConfettiAtom.reportRead();
    return super.isShowConfetti;
  }

  @override
  set isShowConfetti(bool value) {
    _$isShowConfettiAtom.reportWrite(value, super.isShowConfetti, () {
      super.isShowConfetti = value;
    });
  }

  late final _$emailAtom =
      Atom(name: 'SignUpStoreBase.email', context: context);

  @override
  String? get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String? value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  late final _$passwordAtom =
      Atom(name: 'SignUpStoreBase.password', context: context);

  @override
  String? get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(String? value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  late final _$confirmPasswordAtom =
      Atom(name: 'SignUpStoreBase.confirmPassword', context: context);

  @override
  String? get confirmPassword {
    _$confirmPasswordAtom.reportRead();
    return super.confirmPassword;
  }

  @override
  set confirmPassword(String? value) {
    _$confirmPasswordAtom.reportWrite(value, super.confirmPassword, () {
      super.confirmPassword = value;
    });
  }

  late final _$usernameAtom =
      Atom(name: 'SignUpStoreBase.username', context: context);

  @override
  String? get username {
    _$usernameAtom.reportRead();
    return super.username;
  }

  @override
  set username(String? value) {
    _$usernameAtom.reportWrite(value, super.username, () {
      super.username = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: 'SignUpStoreBase.errorMessage', context: context);

  @override
  String get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$signUpAsyncAction =
      AsyncAction('SignUpStoreBase.signUp', context: context);

  @override
  Future<void> signUp(BuildContext context) {
    return _$signUpAsyncAction.run(() => super.signUp(context));
  }

  late final _$SignUpStoreBaseActionController =
      ActionController(name: 'SignUpStoreBase', context: context);

  @override
  void setShowLoading(bool value) {
    final _$actionInfo = _$SignUpStoreBaseActionController.startAction(
        name: 'SignUpStoreBase.setShowLoading');
    try {
      return super.setShowLoading(value);
    } finally {
      _$SignUpStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setShowSuccess(bool value) {
    final _$actionInfo = _$SignUpStoreBaseActionController.startAction(
        name: 'SignUpStoreBase.setShowSuccess');
    try {
      return super.setShowSuccess(value);
    } finally {
      _$SignUpStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setShowError(bool value) {
    final _$actionInfo = _$SignUpStoreBaseActionController.startAction(
        name: 'SignUpStoreBase.setShowError');
    try {
      return super.setShowError(value);
    } finally {
      _$SignUpStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setShowConfetti(bool value) {
    final _$actionInfo = _$SignUpStoreBaseActionController.startAction(
        name: 'SignUpStoreBase.setShowConfetti');
    try {
      return super.setShowConfetti(value);
    } finally {
      _$SignUpStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEmail(String value) {
    final _$actionInfo = _$SignUpStoreBaseActionController.startAction(
        name: 'SignUpStoreBase.setEmail');
    try {
      return super.setEmail(value);
    } finally {
      _$SignUpStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPassword(String value) {
    final _$actionInfo = _$SignUpStoreBaseActionController.startAction(
        name: 'SignUpStoreBase.setPassword');
    try {
      return super.setPassword(value);
    } finally {
      _$SignUpStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setConfirmPassword(String value) {
    final _$actionInfo = _$SignUpStoreBaseActionController.startAction(
        name: 'SignUpStoreBase.setConfirmPassword');
    try {
      return super.setConfirmPassword(value);
    } finally {
      _$SignUpStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUsername(String value) {
    final _$actionInfo = _$SignUpStoreBaseActionController.startAction(
        name: 'SignUpStoreBase.setUsername');
    try {
      return super.setUsername(value);
    } finally {
      _$SignUpStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setErrorMessage(String message) {
    final _$actionInfo = _$SignUpStoreBaseActionController.startAction(
        name: 'SignUpStoreBase.setErrorMessage');
    try {
      return super.setErrorMessage(message);
    } finally {
      _$SignUpStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isShowLoading: ${isShowLoading},
isShowSuccess: ${isShowSuccess},
isShowError: ${isShowError},
isShowConfetti: ${isShowConfetti},
email: ${email},
password: ${password},
confirmPassword: ${confirmPassword},
username: ${username},
errorMessage: ${errorMessage}
    ''';
  }
}
