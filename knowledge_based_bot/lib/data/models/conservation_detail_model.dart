import 'package:intl/intl.dart';

import 'message_model.dart';
class ConversationDetailModel {
  final String id;
  final String title;
  final DateTime createdAt;
  final List<MessageModel> messages;

  ConversationDetailModel({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.messages,
  });

  String get formattedDate => DateFormat('dd-MM-yyyy HH:mm').format(createdAt);

  factory ConversationDetailModel.fromJson(Map<String, dynamic> json) {
    return ConversationDetailModel(
      id: json['id'],
      title: json['title'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] * 1000),
      messages: (json['messages'] as List)
          .map((msg) => MessageModel.fromJson(msg))
          .toList(),
    );
  }
}