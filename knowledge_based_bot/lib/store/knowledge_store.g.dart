// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knowledge_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$KnowledgeStore on _KnowledgeStore, Store {
  late final _$knowledgeListAtom =
      Atom(name: '_KnowledgeStore.knowledgeList', context: context);

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
      Atom(name: '_KnowledgeStore.searchList', context: context);

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
      Atom(name: '_KnowledgeStore.knowledgeUnitList', context: context);

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

  late final _$importedKnowledgeIdsAtom =
      Atom(name: '_KnowledgeStore.importedKnowledgeIds', context: context);

  @override
  List<String> get importedKnowledgeIds {
    _$importedKnowledgeIdsAtom.reportRead();
    return super.importedKnowledgeIds;
  }

  @override
  set importedKnowledgeIds(List<String> value) {
    _$importedKnowledgeIdsAtom.reportWrite(value, super.importedKnowledgeIds,
        () {
      super.importedKnowledgeIds = value;
    });
  }

  late final _$noti_messageAtom =
      Atom(name: '_KnowledgeStore.noti_message', context: context);

  @override
  String? get noti_message {
    _$noti_messageAtom.reportRead();
    return super.noti_message;
  }

  @override
  set noti_message(String? value) {
    _$noti_messageAtom.reportWrite(value, super.noti_message, () {
      super.noti_message = value;
    });
  }

  late final _$fetchKnowledgeAsyncAction =
      AsyncAction('_KnowledgeStore.fetchKnowledge', context: context);

  @override
  Future<void> fetchKnowledge() {
    return _$fetchKnowledgeAsyncAction.run(() => super.fetchKnowledge());
  }

  late final _$fetchImportedKnowledgesAsyncAction =
      AsyncAction('_KnowledgeStore.fetchImportedKnowledges', context: context);

  @override
  Future<void> fetchImportedKnowledges(String assistantId) {
    return _$fetchImportedKnowledgesAsyncAction
        .run(() => super.fetchImportedKnowledges(assistantId));
  }

  late final _$importKnowledgeAsyncAction =
      AsyncAction('_KnowledgeStore.importKnowledge', context: context);

  @override
  Future<void> importKnowledge(String assistantId, String knowledgeId) {
    return _$importKnowledgeAsyncAction
        .run(() => super.importKnowledge(assistantId, knowledgeId));
  }

  late final _$deleteKnowledgeFromAssistantAsyncAction = AsyncAction(
      '_KnowledgeStore.deleteKnowledgeFromAssistant',
      context: context);

  @override
  Future<void> deleteKnowledgeFromAssistant(
      String assistantId, String knowledgeId) {
    return _$deleteKnowledgeFromAssistantAsyncAction.run(
        () => super.deleteKnowledgeFromAssistant(assistantId, knowledgeId));
  }

  late final _$createKnowledgeAsyncAction =
      AsyncAction('_KnowledgeStore.createKnowledge', context: context);

  @override
  Future<void> createKnowledge(String knowledgeName, String description) {
    return _$createKnowledgeAsyncAction
        .run(() => super.createKnowledge(knowledgeName, description));
  }

  late final _$searchKnowledgeAsyncAction =
      AsyncAction('_KnowledgeStore.searchKnowledge', context: context);

  @override
  Future<void> searchKnowledge(String search) {
    return _$searchKnowledgeAsyncAction
        .run(() => super.searchKnowledge(search));
  }

  late final _$deleteKnowledgeAsyncAction =
      AsyncAction('_KnowledgeStore.deleteKnowledge', context: context);

  @override
  Future<void> deleteKnowledge(String assistantId, String id) {
    return _$deleteKnowledgeAsyncAction
        .run(() => super.deleteKnowledge(assistantId, id));
  }

  late final _$updateKnowledgeAsyncAction =
      AsyncAction('_KnowledgeStore.updateKnowledge', context: context);

  @override
  Future<void> updateKnowledge(
      String id, String knowledgeName, String description) {
    return _$updateKnowledgeAsyncAction
        .run(() => super.updateKnowledge(id, knowledgeName, description));
  }

  late final _$fetchKnowledgeUnitsAsyncAction =
      AsyncAction('_KnowledgeStore.fetchKnowledgeUnits', context: context);

  @override
  Future<void> fetchKnowledgeUnits(String knowledgeId) {
    return _$fetchKnowledgeUnitsAsyncAction
        .run(() => super.fetchKnowledgeUnits(knowledgeId));
  }

  late final _$uploadLocalFileAsyncAction =
      AsyncAction('_KnowledgeStore.uploadLocalFile', context: context);

  @override
  Future<void> uploadLocalFile(String knowledgeId, String filePath) {
    return _$uploadLocalFileAsyncAction
        .run(() => super.uploadLocalFile(knowledgeId, filePath));
  }

  late final _$uploadLocalFileWebAsyncAction =
      AsyncAction('_KnowledgeStore.uploadLocalFileWeb', context: context);

  @override
  Future<void> uploadLocalFileWeb(
      String knowledgeId, Uint8List fileBytes, String fileName) {
    return _$uploadLocalFileWebAsyncAction
        .run(() => super.uploadLocalFileWeb(knowledgeId, fileBytes, fileName));
  }

  late final _$uploadWebUrlAsyncAction =
      AsyncAction('_KnowledgeStore.uploadWebUrl', context: context);

  @override
  Future<void> uploadWebUrl(String knowledgeId, String url, String unitName) {
    return _$uploadWebUrlAsyncAction
        .run(() => super.uploadWebUrl(knowledgeId, url, unitName));
  }

  late final _$uploadSlackAsyncAction =
      AsyncAction('_KnowledgeStore.uploadSlack', context: context);

  @override
  Future<void> uploadSlack(String knowledgeId, String unitName,
      String slackWorkspace, String slackBotToken) {
    return _$uploadSlackAsyncAction.run(() => super
        .uploadSlack(knowledgeId, unitName, slackWorkspace, slackBotToken));
  }

  late final _$uploadConfluenceAsyncAction =
      AsyncAction('_KnowledgeStore.uploadConfluence', context: context);

  @override
  Future<void> uploadConfluence(
      String knowledgeId,
      String unitName,
      String wikiPageUrl,
      String confluenceUsername,
      String confluenceAccessToken) {
    return _$uploadConfluenceAsyncAction.run(() => super.uploadConfluence(
        knowledgeId,
        unitName,
        wikiPageUrl,
        confluenceUsername,
        confluenceAccessToken));
  }

  @override
  String toString() {
    return '''
knowledgeList: ${knowledgeList},
searchList: ${searchList},
knowledgeUnitList: ${knowledgeUnitList},
importedKnowledgeIds: ${importedKnowledgeIds},
noti_message: ${noti_message}
    ''';
  }
}
