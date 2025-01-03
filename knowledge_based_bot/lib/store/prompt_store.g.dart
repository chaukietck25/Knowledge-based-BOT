// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prompt_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PromptStore on _PromptStore, Store {
  late final _$promptsAtom =
      Atom(name: '_PromptStore.prompts', context: context);

  @override
  ObservableList<Prompt> get prompts {
    _$promptsAtom.reportRead();
    return super.prompts;
  }

  @override
  set prompts(ObservableList<Prompt> value) {
    _$promptsAtom.reportWrite(value, super.prompts, () {
      super.prompts = value;
    });
  }

  late final _$favoritePromptsAtom =
      Atom(name: '_PromptStore.favoritePrompts', context: context);

  @override
  ObservableList<Prompt> get favoritePrompts {
    _$favoritePromptsAtom.reportRead();
    return super.favoritePrompts;
  }

  @override
  set favoritePrompts(ObservableList<Prompt> value) {
    _$favoritePromptsAtom.reportWrite(value, super.favoritePrompts, () {
      super.favoritePrompts = value;
    });
  }

  late final _$filteredPromptsAtom =
      Atom(name: '_PromptStore.filteredPrompts', context: context);

  @override
  ObservableList<Prompt> get filteredPrompts {
    _$filteredPromptsAtom.reportRead();
    return super.filteredPrompts;
  }

  @override
  set filteredPrompts(ObservableList<Prompt> value) {
    _$filteredPromptsAtom.reportWrite(value, super.filteredPrompts, () {
      super.filteredPrompts = value;
    });
  }

  late final _$msgAtom = Atom(name: '_PromptStore.msg', context: context);

  @override
  String get msg {
    _$msgAtom.reportRead();
    return super.msg;
  }

  @override
  set msg(String value) {
    _$msgAtom.reportWrite(value, super.msg, () {
      super.msg = value;
    });
  }

  late final _$curUserAtom =
      Atom(name: '_PromptStore.curUser', context: context);

  @override
  String? get curUser {
    _$curUserAtom.reportRead();
    return super.curUser;
  }

  @override
  set curUser(String? value) {
    _$curUserAtom.reportWrite(value, super.curUser, () {
      super.curUser = value;
    });
  }

  late final _$fetchPromptsAsyncAction =
      AsyncAction('_PromptStore.fetchPrompts', context: context);

  @override
  Future<void> fetchPrompts() {
    return _$fetchPromptsAsyncAction.run(() => super.fetchPrompts());
  }

  late final _$searchPromptsAsyncAction =
      AsyncAction('_PromptStore.searchPrompts', context: context);

  @override
  Future<void> searchPrompts(String query) {
    return _$searchPromptsAsyncAction.run(() => super.searchPrompts(query));
  }

  late final _$filterByFavoriteAsyncAction =
      AsyncAction('_PromptStore.filterByFavorite', context: context);

  @override
  Future<void> filterByFavorite() {
    return _$filterByFavoriteAsyncAction.run(() => super.filterByFavorite());
  }

  late final _$addToFavoriteListAsyncAction =
      AsyncAction('_PromptStore.addToFavoriteList', context: context);

  @override
  Future<void> addToFavoriteList(String id) {
    return _$addToFavoriteListAsyncAction
        .run(() => super.addToFavoriteList(id));
  }

  late final _$removeFavoriteListAsyncAction =
      AsyncAction('_PromptStore.removeFavoriteList', context: context);

  @override
  Future<void> removeFavoriteList(String id) {
    return _$removeFavoriteListAsyncAction
        .run(() => super.removeFavoriteList(id));
  }

  late final _$createPromptAsyncAction =
      AsyncAction('_PromptStore.createPrompt', context: context);

  @override
  Future<void> createPrompt(String title, String content, String description,
      String category, String language, bool isPublic) {
    return _$createPromptAsyncAction.run(() => super.createPrompt(
        title, content, description, category, language, isPublic));
  }

  late final _$privatePromptsAsyncAction =
      AsyncAction('_PromptStore.privatePrompts', context: context);

  @override
  Future<void> privatePrompts() {
    return _$privatePromptsAsyncAction.run(() => super.privatePrompts());
  }

  late final _$updatePromptAsyncAction =
      AsyncAction('_PromptStore.updatePrompt', context: context);

  @override
  Future<void> updatePrompt(String id, String title, String content,
      String description, String category, String language, bool isPublic) {
    return _$updatePromptAsyncAction.run(() => super.updatePrompt(
        id, title, content, description, category, language, isPublic));
  }

  late final _$removePromptAsyncAction =
      AsyncAction('_PromptStore.removePrompt', context: context);

  @override
  Future<void> removePrompt(String id) {
    return _$removePromptAsyncAction.run(() => super.removePrompt(id));
  }

  late final _$addPromptToChatInputAsyncAction =
      AsyncAction('_PromptStore.addPromptToChatInput', context: context);

  @override
  Future<void> addPromptToChatInput(
      String promptContent, String text, String language) {
    return _$addPromptToChatInputAsyncAction
        .run(() => super.addPromptToChatInput(promptContent, text, language));
  }

  late final _$getCurUserAsyncAction =
      AsyncAction('_PromptStore.getCurUser', context: context);

  @override
  Future<void> getCurUser() {
    return _$getCurUserAsyncAction.run(() => super.getCurUser());
  }

  late final _$_PromptStoreActionController =
      ActionController(name: '_PromptStore', context: context);

  @override
  void addPrompt(
      String id,
      String createdAt,
      String updatedAt,
      String category,
      String content,
      String description,
      bool isPublic,
      String language,
      String title,
      String userId,
      String userName,
      bool isFavorite) {
    final _$actionInfo = _$_PromptStoreActionController.startAction(
        name: '_PromptStore.addPrompt');
    try {
      return super.addPrompt(id, createdAt, updatedAt, category, content,
          description, isPublic, language, title, userId, userName, isFavorite);
    } finally {
      _$_PromptStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addToFilterList(
      String id,
      String createdAt,
      String updatedAt,
      String category,
      String content,
      String description,
      bool isPublic,
      String language,
      String title,
      String userId,
      String userName,
      bool isFavorite) {
    final _$actionInfo = _$_PromptStoreActionController.startAction(
        name: '_PromptStore.addToFilterList');
    try {
      return super.addToFilterList(id, createdAt, updatedAt, category, content,
          description, isPublic, language, title, userId, userName, isFavorite);
    } finally {
      _$_PromptStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
prompts: ${prompts},
favoritePrompts: ${favoritePrompts},
filteredPrompts: ${filteredPrompts},
msg: ${msg},
curUser: ${curUser}
    ''';
  }
}
