// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ChatStore on _ChatStore, Store {
  Computed<String>? _$availableTokensTextComputed;

  @override
  String get availableTokensText => (_$availableTokensTextComputed ??=
          Computed<String>(() => super.availableTokensText,
              name: '_ChatStore.availableTokensText'))
      .value;
  Computed<String>? _$totalTokensTextComputed;

  @override
  String get totalTokensText => (_$totalTokensTextComputed ??= Computed<String>(
          () => super.totalTokensText,
          name: '_ChatStore.totalTokensText'))
      .value;

  late final _$isLoadingDetailAtom =
      Atom(name: '_ChatStore.isLoadingDetail', context: context);

  @override
  bool get isLoadingDetail {
    _$isLoadingDetailAtom.reportRead();
    return super.isLoadingDetail;
  }

  @override
  set isLoadingDetail(bool value) {
    _$isLoadingDetailAtom.reportWrite(value, super.isLoadingDetail, () {
      super.isLoadingDetail = value;
    });
  }

  late final _$remainingUsageAtom =
      Atom(name: '_ChatStore.remainingUsage', context: context);

  @override
  int get remainingUsage {
    _$remainingUsageAtom.reportRead();
    return super.remainingUsage;
  }

  @override
  set remainingUsage(int value) {
    _$remainingUsageAtom.reportWrite(value, super.remainingUsage, () {
      super.remainingUsage = value;
    });
  }

  late final _$availableTokensAtom =
      Atom(name: '_ChatStore.availableTokens', context: context);

  @override
  int get availableTokens {
    _$availableTokensAtom.reportRead();
    return super.availableTokens;
  }

  @override
  set availableTokens(int value) {
    _$availableTokensAtom.reportWrite(value, super.availableTokens, () {
      super.availableTokens = value;
    });
  }

  late final _$totalTokensAtom =
      Atom(name: '_ChatStore.totalTokens', context: context);

  @override
  String get totalTokens {
    _$totalTokensAtom.reportRead();
    return super.totalTokens;
  }

  @override
  set totalTokens(String value) {
    _$totalTokensAtom.reportWrite(value, super.totalTokens, () {
      super.totalTokens = value;
    });
  }

  late final _$unlimitedAtom =
      Atom(name: '_ChatStore.unlimited', context: context);

  @override
  bool get unlimited {
    _$unlimitedAtom.reportRead();
    return super.unlimited;
  }

  @override
  set unlimited(bool value) {
    _$unlimitedAtom.reportWrite(value, super.unlimited, () {
      super.unlimited = value;
    });
  }

  late final _$conversationDetailAtom =
      Atom(name: '_ChatStore.conversationDetail', context: context);

  @override
  ConversationDetailModel? get conversationDetail {
    _$conversationDetailAtom.reportRead();
    return super.conversationDetail;
  }

  @override
  set conversationDetail(ConversationDetailModel? value) {
    _$conversationDetailAtom.reportWrite(value, super.conversationDetail, () {
      super.conversationDetail = value;
    });
  }

  late final _$fetchedAssistantsAtom =
      Atom(name: '_ChatStore.fetchedAssistants', context: context);

  @override
  ObservableList<Assistant> get fetchedAssistants {
    _$fetchedAssistantsAtom.reportRead();
    return super.fetchedAssistants;
  }

  @override
  set fetchedAssistants(ObservableList<Assistant> value) {
    _$fetchedAssistantsAtom.reportWrite(value, super.fetchedAssistants, () {
      super.fetchedAssistants = value;
    });
  }

  late final _$messagesAtom =
      Atom(name: '_ChatStore.messages', context: context);

  @override
  ObservableList<MessageModel> get messages {
    _$messagesAtom.reportRead();
    return super.messages;
  }

  @override
  set messages(ObservableList<MessageModel> value) {
    _$messagesAtom.reportWrite(value, super.messages, () {
      super.messages = value;
    });
  }

  late final _$conversationItemsAtom =
      Atom(name: '_ChatStore.conversationItems', context: context);

  @override
  ObservableList<ConversationItem> get conversationItems {
    _$conversationItemsAtom.reportRead();
    return super.conversationItems;
  }

  @override
  set conversationItems(ObservableList<ConversationItem> value) {
    _$conversationItemsAtom.reportWrite(value, super.conversationItems, () {
      super.conversationItems = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_ChatStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$isSendingAtom =
      Atom(name: '_ChatStore.isSending', context: context);

  @override
  bool get isSending {
    _$isSendingAtom.reportRead();
    return super.isSending;
  }

  @override
  set isSending(bool value) {
    _$isSendingAtom.reportWrite(value, super.isSending, () {
      super.isSending = value;
    });
  }

  late final _$typeAIAtom = Atom(name: '_ChatStore.typeAI', context: context);

  @override
  String get typeAI {
    _$typeAIAtom.reportRead();
    return super.typeAI;
  }

  @override
  set typeAI(String value) {
    _$typeAIAtom.reportWrite(value, super.typeAI, () {
      super.typeAI = value;
    });
  }

  late final _$conversationIdAtom =
      Atom(name: '_ChatStore.conversationId', context: context);

  @override
  String? get conversationId {
    _$conversationIdAtom.reportRead();
    return super.conversationId;
  }

  @override
  set conversationId(String? value) {
    _$conversationIdAtom.reportWrite(value, super.conversationId, () {
      super.conversationId = value;
    });
  }

  late final _$fetchTokenAsyncAction =
      AsyncAction('_ChatStore.fetchToken', context: context);

  @override
  Future<void> fetchToken() {
    return _$fetchTokenAsyncAction.run(() => super.fetchToken());
  }

  late final _$fetchAssistantsAsyncAction =
      AsyncAction('_ChatStore.fetchAssistants', context: context);

  @override
  Future<void> fetchAssistants() {
    return _$fetchAssistantsAsyncAction.run(() => super.fetchAssistants());
  }

  late final _$fetchConversationDetailsAsyncAction =
      AsyncAction('_ChatStore.fetchConversationDetails', context: context);

  @override
  Future<void> fetchConversationDetails(String conversationId) {
    return _$fetchConversationDetailsAsyncAction
        .run(() => super.fetchConversationDetails(conversationId));
  }

  late final _$fetchConversationsAsyncAction =
      AsyncAction('_ChatStore.fetchConversations', context: context);

  @override
  Future<void> fetchConversations(String? refreshToken) {
    return _$fetchConversationsAsyncAction
        .run(() => super.fetchConversations(refreshToken));
  }

  late final _$sendMessageAsyncAction =
      AsyncAction('_ChatStore.sendMessage', context: context);

  @override
  Future<void> sendMessage(String text, String? refreshToken) {
    return _$sendMessageAsyncAction
        .run(() => super.sendMessage(text, refreshToken));
  }

  late final _$_ChatStoreActionController =
      ActionController(name: '_ChatStore', context: context);

  @override
  void setTypeAI(String newTypeAI) {
    final _$actionInfo =
        _$_ChatStoreActionController.startAction(name: '_ChatStore.setTypeAI');
    try {
      return super.setTypeAI(newTypeAI);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetConversation() {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore.resetConversation');
    try {
      return super.resetConversation();
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String getConversationId() {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore.getConversationId');
    try {
      return super.getConversationId();
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearErrorMessage() {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore.clearErrorMessage');
    try {
      return super.clearErrorMessage();
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoadingDetail: ${isLoadingDetail},
remainingUsage: ${remainingUsage},
availableTokens: ${availableTokens},
totalTokens: ${totalTokens},
unlimited: ${unlimited},
conversationDetail: ${conversationDetail},
fetchedAssistants: ${fetchedAssistants},
messages: ${messages},
conversationItems: ${conversationItems},
isLoading: ${isLoading},
isSending: ${isSending},
typeAI: ${typeAI},
conversationId: ${conversationId},
availableTokensText: ${availableTokensText},
totalTokensText: ${totalTokensText}
    ''';
  }
}
