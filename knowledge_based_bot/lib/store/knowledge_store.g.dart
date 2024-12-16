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

  late final _$fetchKnowledgeAsyncAction =
      AsyncAction('_KnowledgeStore.fetchKnowledge', context: context);

  @override
  Future<void> fetchKnowledge() {
    return _$fetchKnowledgeAsyncAction.run(() => super.fetchKnowledge());
  }

  @override
  String toString() {
    return '''
knowledgeList: ${knowledgeList}
    ''';
  }
}
