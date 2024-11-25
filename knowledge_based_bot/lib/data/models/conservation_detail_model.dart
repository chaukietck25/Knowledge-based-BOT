// lib/data/models/conversation_detail_model.dart

import 'conservation_message.dart';

class ConversationDetailModel {
  final String cursor;
  final bool hasMore;
  final int limit;
  final List<ConversationMessage> items;

  ConversationDetailModel({
    required this.cursor,
    required this.hasMore,
    required this.limit,
    required this.items,
  });

  factory ConversationDetailModel.fromJson(Map<String, dynamic> json) {
    return ConversationDetailModel(
      cursor: json['cursor'] ?? '',
      hasMore: json['has_more'] ?? false,
      limit: json['limit'] ?? 20,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => ConversationMessage.fromJson(e))
              .toList() ??
          [],
    );
  }
}


