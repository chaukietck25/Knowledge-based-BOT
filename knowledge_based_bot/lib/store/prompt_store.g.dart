
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

  late final _$fetchPromptsAsyncAction =
      AsyncAction('_PromptStore.fetchPrompts', context: context);

  @override
  Future<void> fetchPrompts() {
    return _$fetchPromptsAsyncAction.run(() => super.fetchPrompts());
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
  void searchPrompts(String query) {
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
filteredPrompts: ${filteredPrompts}
    ''';
  }
}
