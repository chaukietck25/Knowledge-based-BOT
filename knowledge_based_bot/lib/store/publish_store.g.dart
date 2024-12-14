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

  late final _$tokenAtom =
      Atom(name: '_IntegrationPlatform.token', context: context);

  @override
  String? get token {
    _$tokenAtom.reportRead();
    return super.token;
  }

  @override
  set token(String? value) {
    _$tokenAtom.reportWrite(value, super.token, () {
      super.token = value;
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
  String toString() {
    return '''
isVerified: ${isVerified},
token: ${token},
isSelected: ${isSelected}
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
  Future<bool> verifyPlatform(String platformName, String botToken) {
    return _$verifyPlatformAsyncAction
        .run(() => super.verifyPlatform(platformName, botToken));
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
