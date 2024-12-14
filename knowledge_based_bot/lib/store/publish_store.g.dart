// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publish_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$IntegrationPlatform on _IntegrationPlatform, Store {
  late final _$isVerifiedAtom =
      Atom(name: '_IntegrationPlatform.isVerified', context: context);

  @override
  bool get isVerified {
    _$isVerifiedAtom.reportRead();
    return super.isVerified;
  }

  @override
  set isVerified(bool value) {
    _$isVerifiedAtom.reportWrite(value, super.isVerified, () {
      super.isVerified = value;
    });
  }

  late final _$isSelectedAtom =
      Atom(name: '_IntegrationPlatform.isSelected', context: context);

  @override
  bool get isSelected {
    _$isSelectedAtom.reportRead();
    return super.isSelected;
  }

  @override
  set isSelected(bool value) {
    _$isSelectedAtom.reportWrite(value, super.isSelected, () {
      super.isSelected = value;
    });
  }

  late final _$botTokenAtom =
      Atom(name: '_IntegrationPlatform.botToken', context: context);

  @override
  String? get botToken {
    _$botTokenAtom.reportRead();
    return super.botToken;
  }

  @override
  set botToken(String? value) {
    _$botTokenAtom.reportWrite(value, super.botToken, () {
      super.botToken = value;
    });
  }

  late final _$clientIdAtom =
      Atom(name: '_IntegrationPlatform.clientId', context: context);

  @override
  String? get clientId {
    _$clientIdAtom.reportRead();
    return super.clientId;
  }

  @override
  set clientId(String? value) {
    _$clientIdAtom.reportWrite(value, super.clientId, () {
      super.clientId = value;
    });
  }

  late final _$clientSecretAtom =
      Atom(name: '_IntegrationPlatform.clientSecret', context: context);

  @override
  String? get clientSecret {
    _$clientSecretAtom.reportRead();
    return super.clientSecret;
  }

  @override
  set clientSecret(String? value) {
    _$clientSecretAtom.reportWrite(value, super.clientSecret, () {
      super.clientSecret = value;
    });
  }

  late final _$signingSecretAtom =
      Atom(name: '_IntegrationPlatform.signingSecret', context: context);

  @override
  String? get signingSecret {
    _$signingSecretAtom.reportRead();
    return super.signingSecret;
  }

  @override
  set signingSecret(String? value) {
    _$signingSecretAtom.reportWrite(value, super.signingSecret, () {
      super.signingSecret = value;
    });
  }

  late final _$pageAccessTokenAtom =
      Atom(name: '_IntegrationPlatform.pageAccessToken', context: context);

  @override
  String? get pageAccessToken {
    _$pageAccessTokenAtom.reportRead();
    return super.pageAccessToken;
  }

  @override
  set pageAccessToken(String? value) {
    _$pageAccessTokenAtom.reportWrite(value, super.pageAccessToken, () {
      super.pageAccessToken = value;
    });
  }

  late final _$verifyTokenAtom =
      Atom(name: '_IntegrationPlatform.verifyToken', context: context);

  @override
  String? get verifyToken {
    _$verifyTokenAtom.reportRead();
    return super.verifyToken;
  }

  @override
  set verifyToken(String? value) {
    _$verifyTokenAtom.reportWrite(value, super.verifyToken, () {
      super.verifyToken = value;
    });
  }

  late final _$_IntegrationPlatformActionController =
      ActionController(name: '_IntegrationPlatform', context: context);

  @override
  void toggleSelection(bool? value) {
    final _$actionInfo = _$_IntegrationPlatformActionController.startAction(
        name: '_IntegrationPlatform.toggleSelection');
    try {
      return super.toggleSelection(value);
    } finally {
      _$_IntegrationPlatformActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBotToken(String token) {
    final _$actionInfo = _$_IntegrationPlatformActionController.startAction(
        name: '_IntegrationPlatform.setBotToken');
    try {
      return super.setBotToken(token);
    } finally {
      _$_IntegrationPlatformActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSlackCredentials(
      {required String clientId,
      required String clientSecret,
      required String signingSecret}) {
    final _$actionInfo = _$_IntegrationPlatformActionController.startAction(
        name: '_IntegrationPlatform.setSlackCredentials');
    try {
      return super.setSlackCredentials(
          clientId: clientId,
          clientSecret: clientSecret,
          signingSecret: signingSecret);
    } finally {
      _$_IntegrationPlatformActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMessengerCredentials(
      {required String pageAccessToken, required String verifyToken}) {
    final _$actionInfo = _$_IntegrationPlatformActionController.startAction(
        name: '_IntegrationPlatform.setMessengerCredentials');
    try {
      return super.setMessengerCredentials(
          pageAccessToken: pageAccessToken, verifyToken: verifyToken);
    } finally {
      _$_IntegrationPlatformActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isVerified: ${isVerified},
isSelected: ${isSelected},
botToken: ${botToken},
clientId: ${clientId},
clientSecret: ${clientSecret},
signingSecret: ${signingSecret},
pageAccessToken: ${pageAccessToken},
verifyToken: ${verifyToken}
    ''';
  }
}

mixin _$PublishStore on _PublishStore, Store {
  Computed<bool>? _$canPublishComputed;

  @override
  bool get canPublish =>
      (_$canPublishComputed ??= Computed<bool>(() => super.canPublish,
              name: '_PublishStore.canPublish'))
          .value;

  late final _$platformsAtom =
      Atom(name: '_PublishStore.platforms', context: context);

  @override
  ObservableList<IntegrationPlatform> get platforms {
    _$platformsAtom.reportRead();
    return super.platforms;
  }

  @override
  set platforms(ObservableList<IntegrationPlatform> value) {
    _$platformsAtom.reportWrite(value, super.platforms, () {
      super.platforms = value;
    });
  }

  late final _$isPublishingAtom =
      Atom(name: '_PublishStore.isPublishing', context: context);

  @override
  bool get isPublishing {
    _$isPublishingAtom.reportRead();
    return super.isPublishing;
  }

  @override
  set isPublishing(bool value) {
    _$isPublishingAtom.reportWrite(value, super.isPublishing, () {
      super.isPublishing = value;
    });
  }

  late final _$verifyPlatformAsyncAction =
      AsyncAction('_PublishStore.verifyPlatform', context: context);

  @override
  Future<VerificationResult> verifyPlatform(
      String platformName, Map<String, String> data) {
    return _$verifyPlatformAsyncAction
        .run(() => super.verifyPlatform(platformName, data));
  }

  late final _$publishSelectedAsyncAction =
      AsyncAction('_PublishStore.publishSelected', context: context);

  @override
  Future<Map<String, dynamic>> publishSelected() {
    return _$publishSelectedAsyncAction.run(() => super.publishSelected());
  }

  @override
  String toString() {
    return '''
platforms: ${platforms},
isPublishing: ${isPublishing},
canPublish: ${canPublish}
    ''';
  }
}
