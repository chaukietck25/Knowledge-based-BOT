
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

  late final _$fetchPromptsAsyncAction =
      AsyncAction('_PromptStore.fetchPrompts', context: context);

  @override
  Future<void> fetchPrompts() {
    return _$fetchPromptsAsyncAction.run(() => super.fetchPrompts());
  }

  late final _$filterByFavoriteAsyncAction =
      AsyncAction('_PromptStore.filterByFavorite', context: context);

  @override
  Future<void> filterByFavorite() {
    return _$filterByFavoriteAsyncAction.run(() => super.filterByFavorite());
  }

  late final _$toggleFavoriteAsyncAction =
      AsyncAction('_PromptStore.toggleFavorite', context: context);

  @override
  Future<void> toggleFavorite(String id) {
    return _$toggleFavoriteAsyncAction.run(() => super.toggleFavorite(id));
  }

  late final _$toggleNotFavoriteAsyncAction =
      AsyncAction('_PromptStore.toggleNotFavorite', context: context);

  @override
  Future<void> toggleNotFavorite(String id) {
    return _$toggleNotFavoriteAsyncAction
        .run(() => super.toggleNotFavorite(id));
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
  Future<void> searchPrompts(String query) {
    final _$actionInfo = _$_PromptStoreActionController.startAction(
        name: '_PromptStore.searchPrompts');
    try {
      return super.searchPrompts(query);
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
msg: ${msg}
    ''';
  }
}
