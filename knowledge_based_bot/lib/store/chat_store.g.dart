// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ChatStore on _ChatStore, Store {
  late final _$messagesAtom =
      Atom(name: '_ChatStore.messages', context: context);

  @override
  ObservableList<Message> get messages {
    _$messagesAtom.reportRead();
    return super.messages;
  }

  @override
  set messages(ObservableList<Message> value) {
    _$messagesAtom.reportWrite(value, super.messages, () {
      super.messages = value;
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

  late final _$conversationTitlesAtom =
      Atom(name: '_ChatStore.conversationTitles', context: context);

  @override
  List<String> get conversationTitles {
    _$conversationTitlesAtom.reportRead();
    return super.conversationTitles;
  }

  @override
  set conversationTitles(List<String> value) {
    _$conversationTitlesAtom.reportWrite(value, super.conversationTitles, () {
      super.conversationTitles = value;
    });
  }

  late final _$typeAIAtom = Atom(name: '_ChatStore.typeAI', context: context);

  @override
  String? get typeAI {
    _$typeAIAtom.reportRead();
    return super.typeAI;
  }

  @override
  set typeAI(String? value) {
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

  late final _$sendMessageAsyncAction =
      AsyncAction('_ChatStore.sendMessage', context: context);

  @override
  Future<void> sendMessage(String text, String? refreshToken) {
    return _$sendMessageAsyncAction
        .run(() => super.sendMessage(text, refreshToken));
  }

  late final _$fetchConversationsAsyncAction =
      AsyncAction('_ChatStore.fetchConversations', context: context);

  @override
  Future<void> fetchConversations(String? refeshToken) {
    return _$fetchConversationsAsyncAction
        .run(() => super.fetchConversations(refeshToken));
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
  String? getConversationId() {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore.getConversationId');
    try {
      return super.getConversationId();
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
messages: ${messages},
isLoading: ${isLoading},
conversationTitles: ${conversationTitles},
typeAI: ${typeAI},
conversationId: ${conversationId}
    ''';
  }
}
