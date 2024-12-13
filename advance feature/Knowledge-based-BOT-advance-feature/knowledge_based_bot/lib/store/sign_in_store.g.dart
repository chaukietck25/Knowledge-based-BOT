// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SignInStore on SignInStoreBase, Store {
  late final _$isShowLoadingAtom =
      Atom(name: 'SignInStoreBase.isShowLoading', context: context);

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

  late final _$isShowConfettiAtom =
      Atom(name: 'SignInStoreBase.isShowConfetti', context: context);

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
      Atom(name: 'SignInStoreBase.email', context: context);

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
      Atom(name: 'SignInStoreBase.password', context: context);

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

  late final _$accessTokenAtom =
      Atom(name: 'SignInStoreBase.accessToken', context: context);

  @override
  String? get accessToken {
    _$accessTokenAtom.reportRead();
    return super.accessToken;
  }

  @override
  set accessToken(String? value) {
    _$accessTokenAtom.reportWrite(value, super.accessToken, () {
      super.accessToken = value;
    });
  }

  late final _$refreshTokenAtom =
      Atom(name: 'SignInStoreBase.refreshToken', context: context);

  @override
  String? get refreshToken {
    _$refreshTokenAtom.reportRead();
    return super.refreshToken;
  }

  @override
  set refreshToken(String? value) {
    _$refreshTokenAtom.reportWrite(value, super.refreshToken, () {
      super.refreshToken = value;
    });
  }

  late final _$SignInStoreBaseActionController =
      ActionController(name: 'SignInStoreBase', context: context);

  @override
  void setShowLoading(bool value) {
    final _$actionInfo = _$SignInStoreBaseActionController.startAction(
        name: 'SignInStoreBase.setShowLoading');
    try {
      return super.setShowLoading(value);
    } finally {
      _$SignInStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setShowConfetti(bool value) {
    final _$actionInfo = _$SignInStoreBaseActionController.startAction(
        name: 'SignInStoreBase.setShowConfetti');
    try {
      return super.setShowConfetti(value);
    } finally {
      _$SignInStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEmail(String value) {
    final _$actionInfo = _$SignInStoreBaseActionController.startAction(
        name: 'SignInStoreBase.setEmail');
    try {
      return super.setEmail(value);
    } finally {
      _$SignInStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPassword(String value) {
    final _$actionInfo = _$SignInStoreBaseActionController.startAction(
        name: 'SignInStoreBase.setPassword');
    try {
      return super.setPassword(value);
    } finally {
      _$SignInStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAccessToken(String value) {
    final _$actionInfo = _$SignInStoreBaseActionController.startAction(
        name: 'SignInStoreBase.setAccessToken');
    try {
      return super.setAccessToken(value);
    } finally {
      _$SignInStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRefreshToken(String value) {
    final _$actionInfo = _$SignInStoreBaseActionController.startAction(
        name: 'SignInStoreBase.setRefreshToken');
    try {
      return super.setRefreshToken(value);
    } finally {
      _$SignInStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isShowLoading: ${isShowLoading},
isShowConfetti: ${isShowConfetti},
email: ${email},
password: ${password},
accessToken: ${accessToken},
refreshToken: ${refreshToken}
    ''';
  }
}
