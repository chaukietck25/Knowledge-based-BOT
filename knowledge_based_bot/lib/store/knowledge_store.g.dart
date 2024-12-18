// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knowledge_store.dart';


// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$KnowledgeStore on _KnowledgeStore, Store {
  late final _$knowledgeListAtom =
      Atom(name: '_KnowledgeStore.knowledgeList', context: context as ReactiveContext?);

  @override
  List<KnowledgeResDto> get knowledgeList {
    _$knowledgeListAtom.reportRead();
    return super.knowledgeList;
  }

  @override
  set knowledgeList(List<KnowledgeResDto> value) {
    _$knowledgeListAtom.reportWrite(value, super.knowledgeList, () {
      super.knowledgeList = value;
    });
  }

  late final _$searchListAtom =
      Atom(name: '_KnowledgeStore.searchList', context: context as ReactiveContext?);

  @override
  List<KnowledgeResDto> get searchList {
    _$searchListAtom.reportRead();
    return super.searchList;
  }

  @override
  set searchList(List<KnowledgeResDto> value) {
    _$searchListAtom.reportWrite(value, super.searchList, () {
      super.searchList = value;
    });
  }

  late final _$knowledgeUnitListAtom =
      Atom(name: '_KnowledgeStore.knowledgeUnitList', context: context as ReactiveContext?);

  @override
  List<KnowledgeUnitsResDto> get knowledgeUnitList {
    _$knowledgeUnitListAtom.reportRead();
    return super.knowledgeUnitList;
  }

  @override
  set knowledgeUnitList(List<KnowledgeUnitsResDto> value) {
    _$knowledgeUnitListAtom.reportWrite(value, super.knowledgeUnitList, () {
      super.knowledgeUnitList = value;
    });
  }

  late final _$fetchKnowledgeAsyncAction =
      AsyncAction('_KnowledgeStore.fetchKnowledge', context:  context as ReactiveContext?);

  @override
  Future<void> fetchKnowledge() {
    return _$fetchKnowledgeAsyncAction.run(() => super.fetchKnowledge());
  }

  late final _$createKnowledgeAsyncAction =
      AsyncAction('_KnowledgeStore.createKnowledge', context: context);

  @override
  Future<void> createKnowledge(String knowledgeName, String description) {
    return _$createKnowledgeAsyncAction
        .run(() => super.createKnowledge(knowledgeName, description));
  }

  late final _$searchKnowledgeAsyncAction =
      AsyncAction('_KnowledgeStore.searchKnowledge', context: context );

  @override
  Future<void> searchKnowledge(String search) {
    return _$searchKnowledgeAsyncAction
        .run(() => super.searchKnowledge(search));
  }

  late final _$deleteKnowledgeAsyncAction =
      AsyncAction('_KnowledgeStore.deleteKnowledge', context: context );

  @override
  Future<void> deleteKnowledge(String id) {
    return _$deleteKnowledgeAsyncAction.run(() => super.deleteKnowledge(id));
  }

  late final _$updateKnowledgeAsyncAction =
      AsyncAction('_KnowledgeStore.updateKnowledge', context: context );

  @override
  Future<void> updateKnowledge(
      String id, String knowledgeName, String description) {
    return _$updateKnowledgeAsyncAction
        .run(() => super.updateKnowledge(id, knowledgeName, description));
  }

  late final _$fetchKnowledgeUnitsAsyncAction =
      AsyncAction('_KnowledgeStore.fetchKnowledgeUnits', context: context );

  @override
  Future<void> fetchKnowledgeUnits(String knowledgeId) {
    return _$fetchKnowledgeUnitsAsyncAction
        .run(() => super.fetchKnowledgeUnits(knowledgeId));
  }

  late final _$uploadLocalFileAsyncAction =
      AsyncAction('_KnowledgeStore.uploadLocalFile', context: context   );

  @override
  Future<void> uploadLocalFile(String knowledgeId, String filePath) {
    return _$uploadLocalFileAsyncAction
        .run(() => super.uploadLocalFile(knowledgeId, filePath));
  }

  @override
  String toString() {
    return '''
knowledgeList: ${knowledgeList},
searchList: ${searchList},
knowledgeUnitList: ${knowledgeUnitList}
    ''';
  }
}
